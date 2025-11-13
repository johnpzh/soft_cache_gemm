//
// Created by Zhen Peng on 5/28/25.
//

#include <algorithm>
#include <iostream>
#include <thread>
#include <stdlib.h>
#include <cstring>
#include "gemm.h"
#include "background_thread.h"

//--------
// Matrix
//--------

double *create_matrix_in_dram(uint64_t num_rows, uint64_t num_cols, double val)
{
  uint64_t size = num_rows * num_cols;
  double *matrix = (double *) malloc(size * sizeof(double));
  if (val) {
    std::fill(matrix, matrix + size, val);
  } else {
    memset(matrix, 0, size * sizeof(double));
  }

  return matrix;
}

void destroy_matrix_in_dram(double *matrix)
{
  free(matrix);
}

//double *create_matrix_in_fam(rapid_handle fam, uint64_t num_rows, uint64_t num_cols, double val)
//{
//  uint64_t size = num_rows * num_cols;
//  double *matrix = (double *) rapid_malloc(fam, size * sizeof(double));
//  if (val) {
//    std::fill(matrix, matrix + size, val);
//  } else {
//    memset(matrix, 0, size * sizeof(double));
//  }
//
//  return matrix;
//}
//
//void destroy_matrix_in_fam(rapid_handle fam, double *matrix)
//{
//  rapid_free(fam, matrix);
//}

void print_matrix(double *matrix, uint64_t num_rows, uint64_t num_cols)
{
  for (uint64_t i = 0; i < num_rows; ++i) {
    for (uint64_t j = 0; j < num_cols; ++j) {
      std::cout << matrix[i * num_cols + j] << ", ";
    }
    std::cout << "\n";
  }
}

double sum_matrix(double *matrix, uint64_t num_rows, uint64_t num_cols)
{
  double sum = 0.0;
  for (uint64_t i = 0; i < num_rows; ++i) {
    for (uint64_t j = 0; j < num_cols; ++j) {
      sum += matrix[i * num_cols + j];
    }
  }
  return sum;
}

//--------------
// GEMM Kernels
//--------------

void gemm_v0(double *A, uint64_t A1, uint64_t A2,
             double *B, uint64_t B1, uint64_t B2,
             double *C)
{
  for (uint64_t i = 0; i < A1; ++i) {
    for (uint64_t k = 0; k < A2; ++k) {
      for (uint64_t j = 0; j < B2; ++j) {
        /// C[i,j] += A[i,k] * B[k,j];
        C[i * B2 + j] += A[i * A2 + k] * B[k * B2 + j];
      }
    }
  }
}

/// C[i,j] = A[i,k] * B[k,j]
/// ii-kk-jj, i-k-j
void gemm_v1_tiling(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                    double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                    double *C)
{
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t i_bound = std::min(ii + A1_tile, A1);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t k_bound = std::min(kk + A2_tile, A2);
      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t j_bound = std::min(jj + B2_tile, B2);
        /// Tile
        for (uint64_t i = ii; i < i_bound; ++i) {
          for (uint64_t k = kk; k < k_bound; ++k) {
            for (uint64_t j = jj; j < j_bound; ++j) {
              C[i * B2 + j] += A[i * A2 + k] * B[k * B2 + j];
            }
          }
        }
      }
    }
  }
}

/// C[i,j] = A[i,k] * B[k,j]
/// jj-kk-ii, i-j-k
void gemm_v2_tiling_disorder(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                    double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                    double *C)
{
  for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
    uint64_t j_bound = std::min(jj + B2_tile, B2);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t k_bound = std::min(kk + A2_tile, A2);
      for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
        uint64_t i_bound = std::min(ii + A1_tile, A1);
        /// Tile
        for (uint64_t i = ii; i < i_bound; ++i) {
          for (uint64_t j = jj; j < j_bound; ++j) {
            for (uint64_t k = kk; k < k_bound; ++k) {
              C[i * B2 + j] += A[i * A2 + k] * B[k * B2 + j];
            }
          }
        }
      }
    }
  }
}

/// C[i,j] = A[i,k] * B[k,j]
/// ii-kk-jj, i-j-k
void gemm_v3_tiling_disorder(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                    double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                    double *C)
{
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t i_bound = std::min(ii + A1_tile, A1);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t k_bound = std::min(kk + A2_tile, A2);
      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t j_bound = std::min(jj + B2_tile, B2);
        /// Tile
        for (uint64_t i = ii; i < i_bound; ++i) {
          for (uint64_t j = jj; j < j_bound; ++j) {
            for (uint64_t k = kk; k < k_bound; ++k) {
              C[i * B2 + j] += A[i * A2 + k] * B[k * B2 + j];
            }
          }
        }
      }
    }
  }
}


/// C[i,j] = A[i,k] * B[k,j]
/// ii-kk-jj, i-k-j
void gemm_v4_softcache(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile, DoubleBuffer &A_cache,
                       double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile, DoubleBuffer &B_cache,
                       double *C)
{
  /// Main procedure
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    /// test
//    printf("ii: %llu\n", ii);
    /// end test
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      /// test
//      printf("kk: %llu\n", kk);
      /// end test
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
      std::thread copy_thread_A;
      if (kk == 0) {
        /// new row in A. Prepare the A_cache
//        copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
//                  A_cache.getActive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
        copy_thread_A = std::thread([&](){
//          copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
//                    A_cache.getActive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
          copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
                    A_cache.getActive(), /*block_rows=*/A_block_rows, /*block_cols=*/A_block_cols);
        });

        /// test
//        {
//          printf("%d: A_cache.getActive():\n", __LINE__);
//          A_cache.getActive().print(/*rows=*/A1_tile, /*cols=*/A2_tile);
//        }
        /// end test
      }

      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        /// test
//        printf("jj: %llu\n", jj);
        /// end test
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
        std::thread copy_thread_B;
        if (jj == 0) {
          /// new row in B. Prepare the B_cache
//          copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
//                    B_cache.getActive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
          copy_thread_B = std::thread([&](){
//            copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
//                      B_cache.getActive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
            copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
                      B_cache.getActive(), /*block_rows=*/B_block_rows, /*block_cols=*/B_block_cols);
          });
          /// test
//          {
//            printf("%d: B_cache.getActive():\n", __LINE__);
//            B_cache.getActive().print(/*rows=*/B1_tile, /*cols=*/B2_tile);
//          }
          /// end test
        }
        /// Compute in the active cache block
//        computeBlock(A_cache.getActive(), /*A1_tile=*/A1_tile, /*A2_tile=*/A2_tile,
//                     B_cache.getActive(), /*B1_tile=*/B1_tile, /*B2_tile=*/B2_tile,
//                     C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
        std::thread compute_thread([&]() {
//          computeBlock(A_cache.getActive(), /*A1_tile=*/A1_tile, /*A2_tile=*/A2_tile,
//                       B_cache.getActive(), /*B1_tile=*/B1_tile, /*B2_tile=*/B2_tile,
//                       C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
          computeBlock(A_cache.getActive(), /*A1_tile=*/A_block_rows, /*A2_tile=*/A_block_cols,
                       B_cache.getActive(), /*B1_tile=*/B_block_rows, /*B2_tile=*/B_block_cols,
                       C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
        });

        if (copy_thread_A.joinable()) {
          copy_thread_A.join();
        }
        if (copy_thread_B.joinable()) {
          copy_thread_B.join();
        }
        compute_thread.join();
        /// test
//        {
//          printf("-- %d: A_cache:\n", __LINE__);
////          A_cache.getActive().print(A_block_rows, A_block_cols);
//          A_cache.getActive().print(A1_tile, A2_tile);
//          printf("-- %d: B_cache:\n", __LINE__);
////          B_cache.getActive().print(B_block_rows, B_block_cols);
//          B_cache.getActive().print(B1_tile, B2_tile);
//          printf("-- %d: C[%llu-,%llu-]:\n", __LINE__, ii, jj);
////          printf("i_bound: %llu, ii: %llu, k_bound: %llu, kk: %llu, j_bound: %llu, jj: %llu\n",
////                 i_bound, ii, k_bound, kk, j_bound, jj);
//          printf("A1_tile: %llu, A2_tile: %llu, B1_tile: %llu, B2_tile: %llu\n",
//                 A1_tile, A2_tile, B1_tile, B2_tile);
//          uint64_t row_i_bound = std::min(A1, ii + A1_tile);
//          uint64_t col_j_bound = std::min(B2, jj + B2_tile);
//          for (uint64_t row_i = ii; row_i < row_i_bound; ++row_i) {
//            for (uint64_t col_j = jj; col_j < col_j_bound; ++col_j) {
//              printf("%lf, ", C[row_i * B2 + col_j]);
//            }
//            printf("\n");
//          }
//        }
        /// end test

        std::thread prefetch_B_thread;
        std::thread prefetch_A_thread;
//        bool is_B_prefetched = false;
//        bool is_A_prefetched = false;
//        uint64_t jj_next = jj + B2_tile;
        uint64_t jj_next = jj + B_block_cols;
        if (jj_next < B2) {
          /// If there more jPrefetch B to the inactive cache block
//          copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
//                    B_cache.getInactive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
          uint64_t next_B_block_cols = std::min(B2_tile, B2 - jj_next);
          prefetch_B_thread = std::thread([&]() {
//            copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
//                      B_cache.getInactive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
            copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
                      B_cache.getInactive(), /*block_rows=*/B_block_rows, /*block_cols=*/next_B_block_cols);
          });
//          is_B_prefetched = true;
          /// test
//          {
//            printf("%d: B_cache.getInactive():\n", __LINE__);
//            B_cache.getInactive().print(/*rows=*/B1_tile, /*cols=*/B2_tile);
//          }
          /// end test
        }
        uint64_t kk_next = kk + A2_tile;
        if (jj_next >= B2 && kk_next < A2) {
          /// Prefetch A to the inactive cache block
          uint64_t next_A_block_cols = std::min(A2_tile, A2 - kk_next);
//          copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
//                    A_cache.getInactive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
          prefetch_A_thread = std::thread([&]() {
//            copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
//                      A_cache.getInactive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
            copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
                      A_cache.getInactive(), /*block_rows=*/A_block_rows, /*block_cols=*/next_A_block_cols);
          });
//          is_A_prefetched = true;
          /// test
//          {
//            printf("%d: A_cache.getInactive():\n", __LINE__);
//            A_cache.getInactive().print(/*rows=*/A1_tile, /*cols=*/A2_tile);
//          }
          /// end test
        }

        /// Join
//        compute_thread.join();
        if (prefetch_B_thread.joinable()) {
          prefetch_B_thread.join();
          B_cache.swap();
        }
        if (prefetch_A_thread.joinable()) {
          prefetch_A_thread.join();
          A_cache.swap();
        }
//        if (is_B_prefetched) {
//          B_cache.swap();
//        }
//        if (is_A_prefetched) {
//          A_cache.swap();
//        }

//        /////////////////////////////////////////////
//        /// Tile
//        for (uint64_t i = ii; i < i_bound; ++i) {
//          for (uint64_t k = kk; k < k_bound; ++k) {
//            for (uint64_t j = jj; j < j_bound; ++j) {
//              C[i * B2 + j] += A[i * A2 + k] * B[k * B2 + j];
//            }
//          }
//        }
      }
    }
  }
}


/// C[i,j] = A[i,k] * B[k,j]
/// ii-kk-jj, i-k-j
void gemm_v6_softcache_omp(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                       double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                       double *C)
{
  /// Main procedure
#pragma omp parallel for
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    DoubleBuffer A_cache(A1_tile, A2_tile);
    DoubleBuffer B_cache(B1_tile, B2_tile);
    /// test
//    printf("ii: %llu\n", ii);
    /// end test
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      /// test
//      printf("kk: %llu\n", kk);
      /// end test
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
      std::thread copy_thread_A;
      if (kk == 0) {
        /// new row in A. Prepare the A_cache
//        copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
//                  A_cache.getActive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
        copy_thread_A = std::thread([&](){
//          copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
//                    A_cache.getActive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
          copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
                    A_cache.getActive(), /*block_rows=*/A_block_rows, /*block_cols=*/A_block_cols);
        });

        /// test
//        {
//          printf("%d: A_cache.getActive():\n", __LINE__);
//          A_cache.getActive().print(/*rows=*/A1_tile, /*cols=*/A2_tile);
//        }
        /// end test
      }

      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        /// test
//        printf("jj: %llu\n", jj);
        /// end test
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
        std::thread copy_thread_B;
        if (jj == 0) {
          /// new row in B. Prepare the B_cache
//          copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
//                    B_cache.getActive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
          copy_thread_B = std::thread([&](){
//            copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
//                      B_cache.getActive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
            copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
                      B_cache.getActive(), /*block_rows=*/B_block_rows, /*block_cols=*/B_block_cols);
          });
          /// test
//          {
//            printf("%d: B_cache.getActive():\n", __LINE__);
//            B_cache.getActive().print(/*rows=*/B1_tile, /*cols=*/B2_tile);
//          }
          /// end test
        }
        /// Compute in the active cache block
//        computeBlock(A_cache.getActive(), /*A1_tile=*/A1_tile, /*A2_tile=*/A2_tile,
//                     B_cache.getActive(), /*B1_tile=*/B1_tile, /*B2_tile=*/B2_tile,
//                     C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
        std::thread compute_thread([&]() {
//          computeBlock(A_cache.getActive(), /*A1_tile=*/A1_tile, /*A2_tile=*/A2_tile,
//                       B_cache.getActive(), /*B1_tile=*/B1_tile, /*B2_tile=*/B2_tile,
//                       C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
          computeBlock(A_cache.getActive(), /*A1_tile=*/A_block_rows, /*A2_tile=*/A_block_cols,
                       B_cache.getActive(), /*B1_tile=*/B_block_rows, /*B2_tile=*/B_block_cols,
                       C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
        });

        if (copy_thread_A.joinable()) {
          copy_thread_A.join();
        }
        if (copy_thread_B.joinable()) {
          copy_thread_B.join();
        }
        compute_thread.join();
        /// test
//        {
//          printf("-- %d: A_cache:\n", __LINE__);
////          A_cache.getActive().print(A_block_rows, A_block_cols);
//          A_cache.getActive().print(A1_tile, A2_tile);
//          printf("-- %d: B_cache:\n", __LINE__);
////          B_cache.getActive().print(B_block_rows, B_block_cols);
//          B_cache.getActive().print(B1_tile, B2_tile);
//          printf("-- %d: C[%llu-,%llu-]:\n", __LINE__, ii, jj);
////          printf("i_bound: %llu, ii: %llu, k_bound: %llu, kk: %llu, j_bound: %llu, jj: %llu\n",
////                 i_bound, ii, k_bound, kk, j_bound, jj);
//          printf("A1_tile: %llu, A2_tile: %llu, B1_tile: %llu, B2_tile: %llu\n",
//                 A1_tile, A2_tile, B1_tile, B2_tile);
//          uint64_t row_i_bound = std::min(A1, ii + A1_tile);
//          uint64_t col_j_bound = std::min(B2, jj + B2_tile);
//          for (uint64_t row_i = ii; row_i < row_i_bound; ++row_i) {
//            for (uint64_t col_j = jj; col_j < col_j_bound; ++col_j) {
//              printf("%lf, ", C[row_i * B2 + col_j]);
//            }
//            printf("\n");
//          }
//        }
        /// end test

        std::thread prefetch_B_thread;
        std::thread prefetch_A_thread;
//        bool is_B_prefetched = false;
//        bool is_A_prefetched = false;
//        uint64_t jj_next = jj + B2_tile;
        uint64_t jj_next = jj + B_block_cols;
        if (jj_next < B2) {
          /// If there more jPrefetch B to the inactive cache block
//          copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
//                    B_cache.getInactive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
          uint64_t next_B_block_cols = std::min(B2_tile, B2 - jj_next);
          prefetch_B_thread = std::thread([&]() {
//            copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
//                      B_cache.getInactive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
            copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
                      B_cache.getInactive(), /*block_rows=*/B_block_rows, /*block_cols=*/next_B_block_cols);
          });
//          is_B_prefetched = true;
          /// test
//          {
//            printf("%d: B_cache.getInactive():\n", __LINE__);
//            B_cache.getInactive().print(/*rows=*/B1_tile, /*cols=*/B2_tile);
//          }
          /// end test
        }
        uint64_t kk_next = kk + A2_tile;
        if (jj_next >= B2 && kk_next < A2) {
          /// Prefetch A to the inactive cache block
          uint64_t next_A_block_cols = std::min(A2_tile, A2 - kk_next);
//          copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
//                    A_cache.getInactive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
          prefetch_A_thread = std::thread([&]() {
//            copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
//                      A_cache.getInactive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
            copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
                      A_cache.getInactive(), /*block_rows=*/A_block_rows, /*block_cols=*/next_A_block_cols);
          });
//          is_A_prefetched = true;
          /// test
//          {
//            printf("%d: A_cache.getInactive():\n", __LINE__);
//            A_cache.getInactive().print(/*rows=*/A1_tile, /*cols=*/A2_tile);
//          }
          /// end test
        }

        /// Join
//        compute_thread.join();
        if (prefetch_B_thread.joinable()) {
          prefetch_B_thread.join();
          B_cache.swap();
        }
        if (prefetch_A_thread.joinable()) {
          prefetch_A_thread.join();
          A_cache.swap();
        }
//        if (is_B_prefetched) {
//          B_cache.swap();
//        }
//        if (is_A_prefetched) {
//          A_cache.swap();
//        }

//        /////////////////////////////////////////////
//        /// Tile
//        for (uint64_t i = ii; i < i_bound; ++i) {
//          for (uint64_t k = kk; k < k_bound; ++k) {
//            for (uint64_t j = jj; j < j_bound; ++j) {
//              C[i * B2 + j] += A[i * A2 + k] * B[k * B2 + j];
//            }
//          }
//        }
      }
    }
  }
}

/// Do swap on the auxiliary side
void gemm_v7_background_thread(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                               double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                               double *C)
{
  uint64_t A_buffer_size = A1_tile * A2_tile;
  double *A_buffer1 = (double *) malloc(A_buffer_size * sizeof(double));
  double *A_buffer2 = (double *) malloc(A_buffer_size * sizeof(double));
  std::atomic<bool> A_buffer_is_ready(false);

  uint64_t B_buffer_size = B1_tile * B2_tile;
  double *B_buffer1 = (double *) malloc(B_buffer_size * sizeof(double));
  double *B_buffer2 = (double *) malloc(B_buffer_size * sizeof(double));
  std::atomic<bool> B_buffer_is_ready(false);

  /// Initialize the background thread
  std::thread copy_thread;
  intialize_thread_v1(copy_thread,
                      A,
                      A1,
                      A2,
                      &A_buffer1,
                      &A_buffer2,
                      A1_tile,
                      A2_tile,
                      &A_buffer_is_ready,
                      B,
                      B1,
                      B2,
                      &B_buffer1,
                      &B_buffer2,
                      B1_tile,
                      B2_tile,
                      &B_buffer_is_ready);

  /// The kernel
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
      /// Sync A_buffer
      while (!A_buffer_is_ready.load(std::memory_order_acquire)) {
        ;  /// Spin
      }
      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
        /// Sync B_buffer
        while (!B_buffer_is_ready.load(std::memory_order_acquire)) {
          ; /// Spin
        }
        do_gemm_on_buffer(/*A_buffer_active=*/A_buffer1, A1_tile, A2_tile, A_block_rows, A_block_cols,
                          /*B_buffer_active=*/B_buffer1, B1_tile, B2_tile, B_block_rows, B_block_cols,
                          C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
        B_buffer_is_ready.store(false, std::memory_order_release);
      }
      A_buffer_is_ready.store(false, std::memory_order_release);
    }
  }

  /// Clean up
  copy_thread.join();
  free(A_buffer1);
  free(A_buffer2);
  free(B_buffer1);
  free(B_buffer2);
}


/// Do the swap on the main side
void gemm_v8_background_thread(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                               double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                               double *C)
{
  uint64_t A_buffer_size = A1_tile * A2_tile;
  double *A_buffer1 = (double *) malloc(A_buffer_size * sizeof(double));
  double *A_buffer2 = (double *) malloc(A_buffer_size * sizeof(double));
  std::atomic<bool> A_buffer_is_ready(false);

  uint64_t B_buffer_size = B1_tile * B2_tile;
  double *B_buffer1 = (double *) malloc(B_buffer_size * sizeof(double));
  double *B_buffer2 = (double *) malloc(B_buffer_size * sizeof(double));
  std::atomic<bool> B_buffer_is_ready(false);

  /// Initialize the background thread
  std::thread copy_thread;
  intialize_thread_v2(copy_thread,
                      A,
                      A1,
                      A2,
//                      &A_buffer1,
                      &A_buffer2,
                      A1_tile,
                      A2_tile,
                      &A_buffer_is_ready,
                      B,
                      B1,
                      B2,
//                      &B_buffer1,
                      &B_buffer2,
                      B1_tile,
                      B2_tile,
                      &B_buffer_is_ready);

  /// The kernel
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
      /// Sync A_buffer
      while (!A_buffer_is_ready.load(std::memory_order_acquire)) {
        ;  /// Spin
      }
      swap_buffer(&A_buffer1, &A_buffer2);
      A_buffer_is_ready.store(false, std::memory_order_release);
      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
        /// Sync B_buffer
        while (!B_buffer_is_ready.load(std::memory_order_acquire)) {
          ; /// Spin
        }
        swap_buffer(&B_buffer1, &B_buffer2);
        B_buffer_is_ready.store(false, std::memory_order_release);
        do_gemm_on_buffer(/*A_buffer_active=*/A_buffer1, A1_tile, A2_tile, A_block_rows, A_block_cols,
                          /*B_buffer_active=*/B_buffer1, B1_tile, B2_tile, B_block_rows, B_block_cols,
                          C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
      }
    }
  }

  /// Clean up
  copy_thread.join();
  free(A_buffer1);
  free(A_buffer2);
  free(B_buffer1);
  free(B_buffer2);
}


void gemm_v9_doublebuffer_parallel_jj(
    double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
    double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
    double *C,
    uint64_t num_workers)
{
  if (0 == num_workers) {
    /// Fallback to sequential
    num_workers = 1;
  }
  uint64_t num_j_tiles = (B2 + B2_tile - 1) / B2_tile;
  uint64_t tiles_per_workers = num_j_tiles / num_workers;
  uint64_t remainder = num_j_tiles % num_workers;

  /// Shared A buffers
  uint64_t A_buffer_size = A1_tile * A2_tile;
  double *A_buffer1 = (double *) malloc(A_buffer_size * sizeof(double));
  double *A_buffer2 = (double *) malloc(A_buffer_size * sizeof(double));
  double **A_buffer1_ptr = &A_buffer1;
  double **A_buffer2_ptr = &A_buffer2;
//  std::atomic<bool> A_buffer_is_ready(false);
//  std::atomic<uint64_t> A_in_use(0);
//  std::atomic<uint64_t> A_in_after_use(0);
  std::vector<std::atomic<bool> *> A_buffer_is_ready_list(num_workers);
  for (uint64_t w = 0; w < num_workers; ++w) {
    A_buffer_is_ready_list[w] = new std::atomic<bool>(false);
  }

  /// Launch shared A aux thread
  std::thread A_copy_thread(background_A_process, A, A1, A2,
                            A_buffer1_ptr, A_buffer2_ptr,
                            A1_tile, A2_tile,
//                            &A_in_use,
//                            &A_in_after_use,
                            std::ref(A_buffer_is_ready_list),
                            num_workers);

  /// Per-worker resource for B aux threads
  std::vector<std::thread> compute_threads(num_workers);
  std::vector<std::thread> B_copy_threads(num_workers);
  std::vector<double *> worker_B_buffer1s(num_workers);
  std::vector<double *> worker_B_buffer2s(num_workers);
  std::vector<std::atomic<bool> *> worker_B_readys(num_workers);
  uint64_t B_buffer_size = B1_tile * B2_tile;
  for (uint64_t w = 0; w < num_workers; ++w) {
    worker_B_buffer1s[w] = (double *) malloc(B_buffer_size * sizeof(double));
    worker_B_buffer2s[w] = (double *) malloc(B_buffer_size * sizeof(double));
    worker_B_readys[w] = new std::atomic<bool>(false);
  }
//  std::vector<uint64_t> j_starts(num_workers);
//  std::vector<uint64_t> num_local_j_tiles_vec(num_workers);

//  uint64_t current_tile_start = 0;
  uint64_t j_start = 0;
  for (uint64_t w = 0; w < num_workers; ++w) {
    uint64_t num_local_j_tiles = tiles_per_workers + (w < remainder ? 1 : 0);
//    uint64_t j_start = current_tile_start * B2_tile;

    /// Per-worker B buffers
//    uint64_t B_buffer_size = B1_tile * B2_tile;
//    double *B_buffer1 = (double *) malloc(B_buffer_size * sizeof(double));
//    double *B_buffer2 = (double *) malloc(B_buffer_size * sizeof(double));
//    double **B_buffer1_ptr = &B_buffer1;
//    double **B_buffer2_ptr = &B_buffer2;
//    worker_B_buffer1s[w] = B_buffer1;
//    worker_B_buffer2s[w] = B_buffer2;
//    std::atomic<bool> B_buffer_is_ready(false);
//    std::atomic<bool> *B_buffer_is_ready = new std::atomic<bool>(false);
//    worker_B_readys[w] = B_buffer_is_ready;
    double **B_buffer1_ptr = &worker_B_buffer1s[w];
    double **B_buffer2_ptr = &worker_B_buffer2s[w];
    std::atomic<bool> *B_buffer_is_ready = worker_B_readys[w];
    std::atomic<bool> *A_buffer_is_ready = A_buffer_is_ready_list[w];

    /// Launch per-worker B aux thread
    B_copy_threads[w] = std::thread(background_B_process,
                                    A1,
                                    A2,
                                    A1_tile,
                                    A2_tile,
                                    B,
                                    B1,
                                    B2,
                                    B_buffer1_ptr,
                                    B_buffer2_ptr,
                                    B1_tile,
                                    B2_tile,
                                    B_buffer_is_ready,
                                    j_start,
                                    num_local_j_tiles);

    /// Launch per-worker compute thread
    compute_threads[w] = std::thread(compute_worker,
                                     A1,
                                     A2,
                                     B1,
                                     B2,
                                     A_buffer1_ptr,
                                     A1_tile,
                                     A2_tile,
//                                     &A_in_use,
//                                     &A_in_after_use,
                                     A_buffer_is_ready,
                                     B_buffer1_ptr,
                                     B1_tile,
                                     B2_tile,
                                     B_buffer_is_ready,
                                     C,
                                     j_start,
                                     num_local_j_tiles,
                                     w);

//    current_tile_start += num_local_j_tiles;
      j_start += (num_local_j_tiles * B2_tile);
  }

  /// Join all workders
  A_copy_thread.join();
  for (auto &t : B_copy_threads) {
    t.join();
  }
  for (auto &t : compute_threads) {
    t.join();
  }

  /// Cleanup
  free(A_buffer1);
  free(A_buffer2);
  for (uint64_t w = 0; w < num_workers; ++w) {
    free(worker_B_buffer1s[w]);
    free(worker_B_buffer2s[w]);
    delete A_buffer_is_ready_list[w];
    delete worker_B_readys[w];
  }

}

void gemm_v10_doublebuffer_parallel_ii(
    double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
    double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
    double *C,
    uint64_t num_workers)
{
  if (0 == num_workers) {
    /// Fallback to sequential
    num_workers = 1;
  }
  uint64_t num_i_tiles = (A1 + A1_tile - 1) / A1_tile;
  uint64_t tiles_per_workers_base = num_i_tiles / num_workers;
  uint64_t remainder = num_i_tiles % num_workers;
  std::vector<uint64_t> tiles_per_workers_list(num_workers);
  for (uint64_t w = 0; w < num_workers; ++w) {
    tiles_per_workers_list[w] = tiles_per_workers_base + (w < remainder ? 1 : 0);
  }

  /// A Buffers
  uint64_t A_buffer_size = A1_tile * A2_tile;
  std::vector<double *> A_buffer1s(num_workers);
  std::vector<double *> A_buffer2s(num_workers);
  std::vector<std::atomic<bool> *> A_buffer_readys(num_workers);
  for (uint64_t w = 0; w < num_workers; ++w) {
    A_buffer1s[w] = (double *) malloc(A_buffer_size * sizeof(double));
    A_buffer2s[w] = (double *) malloc(A_buffer_size * sizeof(double));
    A_buffer_readys[w] = new std::atomic<bool>(false);
  }

  /// B Buffers
  uint64_t B_buffer_size = B1_tile * B2_tile;
  std::vector<double *> B_buffer1s(num_workers);
  std::vector<double *> B_buffer2s(num_workers);
  std::vector<std::atomic<bool> *> B_buffer_readys(num_workers);
  for (uint64_t w = 0; w < num_workers; ++w) {
    B_buffer1s[w] = (double *) malloc(B_buffer_size * sizeof(double));
    B_buffer2s[w] = (double *) malloc(B_buffer_size * sizeof(double));
    B_buffer_readys[w] = new std::atomic<bool>(false);
  }

  /// Threads
  std::vector<std::thread> compute_threads(num_workers);
  std::vector<std::thread> copy_threads(num_workers);

  uint64_t i_start = 0;
  for (uint64_t w = 0; w < num_workers; ++w) {
    double **A_buffer1_ptr = &A_buffer1s[w];
    double **A_buffer2_ptr = &A_buffer2s[w];
    double **B_buffer1_ptr = &B_buffer1s[w];
    double **B_buffer2_ptr = &B_buffer2s[w];
    std::atomic<bool> *A_buffer_is_ready = A_buffer_readys[w];
    std::atomic<bool> *B_buffer_is_ready = B_buffer_readys[w];
    uint64_t num_local_i_tiles = tiles_per_workers_list[w];

    copy_threads[w] = std::thread(aux_copy_on_ii,
                                  A,
                                  A1,
                                  A2,
                                  A1_tile,
                                  A2_tile,
                                  A_buffer1_ptr,
                                  A_buffer2_ptr,
                                  A_buffer_is_ready,
                                  B,
                                  B1,
                                  B2,
                                  B1_tile,
                                  B2_tile,
                                  B_buffer1_ptr,
                                  B_buffer2_ptr,
                                  B_buffer_is_ready,
                                  i_start,
                                  num_local_i_tiles);

    compute_threads[w] = std::thread(main_compute_on_ii,
                                     A1,
                                     A2,
                                     A1_tile,
                                     A2_tile,
                                     A_buffer1_ptr,
                                     A_buffer_is_ready,
                                     B1,
                                     B2,
                                     B1_tile,
                                     B2_tile,
                                     B_buffer1_ptr,
                                     B_buffer_is_ready,
                                     C,
                                     i_start,
                                     num_local_i_tiles);

    i_start += (num_local_i_tiles * A1_tile);
  }

  /// Join all workers
  for (uint64_t w = 0; w < num_workers; ++w) {
    copy_threads[w].join();
    compute_threads[w].join();
  }

  /// Cleanup
  for (uint64_t w = 0; w < num_workers; ++w) {
    free(A_buffer1s[w]);
    free(A_buffer2s[w]);
    delete A_buffer_readys[w];
    free(B_buffer1s[w]);
    free(B_buffer2s[w]);
    delete B_buffer_readys[w];
  }
}

void gemm_v11_doublebuffer_parallel_compute_drive(
    double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
    double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
    double *C,
    uint64_t num_compute_workers,
    uint64_t num_aux_workers)
{
  uint64_t num_i_tiles = (A1 + A1_tile - 1) / A1_tile;
  uint64_t tiles_per_workers_base = num_i_tiles / num_compute_workers;
  uint64_t remainder = num_i_tiles % num_compute_workers;
  std::vector<uint64_t> tiles_per_workers_list(num_compute_workers);
  for (uint64_t w = 0; w < num_compute_workers; ++w) {
    tiles_per_workers_list[w] = tiles_per_workers_base + (w < remainder ? 1 : 0);
  }

  /// A Buffers
  uint64_t A_buffer_size = A1_tile * A2_tile;
  std::vector<double *> A_buffer1s(num_compute_workers);
  std::vector<double *> A_buffer2s(num_compute_workers);
  std::vector<std::atomic<bool> *> A_buffer_readys(num_compute_workers);
  std::vector<uint64_t> A1_offset_list(num_compute_workers);
  std::vector<uint64_t> A2_offset_list(num_compute_workers);
  std::vector<uint64_t> A_block_rows_list(num_compute_workers);
  std::vector<uint64_t> A_block_cols_list(num_compute_workers);

  for (uint64_t w = 0; w < num_compute_workers; ++w) {
    A_buffer1s[w] = (double *) malloc(A_buffer_size * sizeof(double));
    A_buffer2s[w] = (double *) malloc(A_buffer_size * sizeof(double));
    A_buffer_readys[w] = new std::atomic<bool>(true); /// Initial true; drived by the compute worker
  }

  /// B Buffers
  uint64_t B_buffer_size = B1_tile * B2_tile;
  std::vector<double *> B_buffer1s(num_compute_workers);
  std::vector<double *> B_buffer2s(num_compute_workers);
  std::vector<std::atomic<bool> *> B_buffer_readys(num_compute_workers);
  std::vector<uint64_t> B1_offset_list(num_compute_workers);
  std::vector<uint64_t> B2_offset_list(num_compute_workers);
  std::vector<uint64_t> B_block_rows_list(num_compute_workers);
  std::vector<uint64_t> B_block_cols_list(num_compute_workers);
  for (uint64_t w = 0; w < num_compute_workers; ++w) {
    B_buffer1s[w] = (double *) malloc(B_buffer_size * sizeof(double));
    B_buffer2s[w] = (double *) malloc(B_buffer_size * sizeof(double));
    B_buffer_readys[w] = new std::atomic<bool>(true); /// Initial true; drived by the compute worker
  }

  /// Threads
  std::vector<std::thread> compute_threads(num_compute_workers);
  std::vector<std::thread> aux_threads(num_aux_workers);
  std::vector<std::atomic<bool> *> compute_worker_finished(num_compute_workers);
  for (uint64_t w = 0; w < num_compute_workers; ++w) {
    compute_worker_finished[w] = new std::atomic<bool>(false);
  }
  uint64_t computer_per_aux_base = num_compute_workers / num_aux_workers;
  uint64_t remainder2 = num_compute_workers % num_aux_workers;
  std::vector<uint64_t> compute_per_aux_list(num_aux_workers);
  for (uint64_t w = 0; w < num_aux_workers; ++w) {
    compute_per_aux_list[w] = computer_per_aux_base + (w < remainder2 ? 1 : 0);
  }

  uint64_t i_start = 0;
  for (uint64_t w = 0; w < num_compute_workers; ++w) {
    double **A_buffer1_ptr = &A_buffer1s[w];
    double **B_buffer1_ptr = &B_buffer1s[w];
    std::atomic<bool> *A_buffer_is_ready = A_buffer_readys[w];
    std::atomic<bool> *B_buffer_is_ready = B_buffer_readys[w];
    uint64_t num_local_i_tiles = tiles_per_workers_list[w];
    uint64_t *A1_offset_ptr = &A1_offset_list[w];
    uint64_t *A2_offset_ptr = &A2_offset_list[w];
    uint64_t *A_block_rows_ptr = &A_block_rows_list[w];
    uint64_t *A_block_cols_ptr = &A_block_cols_list[w];
    uint64_t *B1_offset_ptr = &B1_offset_list[w];
    uint64_t *B2_offset_ptr = &B2_offset_list[w];
    uint64_t *B_block_rows_ptr = &B_block_rows_list[w];
    uint64_t *B_block_cols_ptr = &B_block_cols_list[w];
    std::atomic<bool> *is_finished = compute_worker_finished[w];


    compute_threads[w] = std::thread(compute_worker_drive,
                                     A1,
                                     A2,
                                     A1_tile,
                                     A2_tile,
                                     A1_offset_ptr,
                                     A2_offset_ptr,
                                     A_block_rows_ptr,
                                     A_block_cols_ptr,
                                     A_buffer1_ptr,
                                     A_buffer_is_ready,
                                     B1,
                                     B2,
                                     B1_tile,
                                     B2_tile,
                                     B1_offset_ptr,
                                     B2_offset_ptr,
                                     B_block_rows_ptr,
                                     B_block_cols_ptr,
                                     B_buffer1_ptr,
                                     B_buffer_is_ready,
                                     C,
                                     i_start,
                                     num_local_i_tiles,
                                     is_finished);

    i_start += (num_local_i_tiles * A1_tile);
  }

  uint64_t compute_worker_start = 0;
  for (uint64_t w = 0; w < num_aux_workers; ++w) {
    uint64_t num_local_compute_worker = compute_per_aux_list[w];

    aux_threads[w] = std::thread(aux_worker_pull,
                                 A,
                                 A1,
                                 A2,
                                 A1_tile,
                                 A2_tile,
                                 std::ref(A_buffer1s),
                                 std::ref(A_buffer2s),
                                 std::ref(A1_offset_list),
                                 std::ref(A2_offset_list),
                                 std::ref(A_block_rows_list),
                                 std::ref(A_block_cols_list),
                                 std::ref(A_buffer_readys),
                                 B,
                                 B1,
                                 B2,
                                 B1_tile,
                                 B2_tile,
                                 std::ref(B_buffer1s),
                                 std::ref(B_buffer2s),
                                 std::ref(B1_offset_list),
                                 std::ref(B2_offset_list),
                                 std::ref(B_block_rows_list),
                                 std::ref(B_block_cols_list),
                                 std::ref(B_buffer_readys),
                                 compute_worker_start,
                                 num_local_compute_worker,
                                 std::ref(compute_worker_finished));

    compute_worker_start += num_local_compute_worker;
  }

  /// Join all workers
  for (uint64_t w = 0; w < num_compute_workers; ++w) {
    compute_threads[w].join();
  }
  for (uint64_t w = 0; w < num_aux_workers; ++w) {
    aux_threads[w].join();
  }

  /// Cleanup
  for (uint64_t w = 0; w < num_compute_workers; ++w) {
    free(A_buffer1s[w]);
    free(A_buffer2s[w]);
    delete A_buffer_readys[w];
    free(B_buffer1s[w]);
    free(B_buffer2s[w]);
    delete B_buffer_readys[w];
    delete compute_worker_finished[w];
  }
}

///// C[i,j] = A[i,k] * B[k,j]
///// ii-kk-jj, i-k-j
///// Do prefetch between rows.
//void gemm_v5_softcache(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile, DoubleBuffer &A_cache,
//                       double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile, DoubleBuffer &B_cache,
//                       double *C)
//{
//  /// Main procedure
//  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
//    /// test
////    printf("ii: %llu\n", ii);
//    /// end test
//    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
//    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
//      /// test
////      printf("kk: %llu\n", kk);
//      /// end test
//      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
//      uint64_t B_block_rows = A_block_cols;
//      std::thread copy_thread_A;
//      if (kk == 0) {
//        /// new row in A. Prepare the A_cache
////        copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
////                  A_cache.getActive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
//        copy_thread_A = std::thread([&](){
////          copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
////                    A_cache.getActive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
//          copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
//                    A_cache.getActive(), /*block_rows=*/A_block_rows, /*block_cols=*/A_block_cols);
//        });
//
//        /// test
////        {
////          printf("%d: A_cache.getActive():\n", __LINE__);
////          A_cache.getActive().print(/*rows=*/A1_tile, /*cols=*/A2_tile);
////        }
//        /// end test
//      }
//
//      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
//        /// test
////        printf("jj: %llu\n", jj);
//        /// end test
//        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
//        std::thread copy_thread_B;
//        if (jj == 0) {
//          /// new row in B. Prepare the B_cache
////          copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
////                    B_cache.getActive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
//          copy_thread_B = std::thread([&](){
////            copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
////                      B_cache.getActive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
//            copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
//                      B_cache.getActive(), /*block_rows=*/B_block_rows, /*block_cols=*/B_block_cols);
//          });
//          /// test
////          {
////            printf("%d: B_cache.getActive():\n", __LINE__);
////            B_cache.getActive().print(/*rows=*/B1_tile, /*cols=*/B2_tile);
////          }
//          /// end test
//        }
//        /// Compute in the active cache block
////        computeBlock(A_cache.getActive(), /*A1_tile=*/A1_tile, /*A2_tile=*/A2_tile,
////                     B_cache.getActive(), /*B1_tile=*/B1_tile, /*B2_tile=*/B2_tile,
////                     C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
//        std::thread compute_thread([&]() {
////          computeBlock(A_cache.getActive(), /*A1_tile=*/A1_tile, /*A2_tile=*/A2_tile,
////                       B_cache.getActive(), /*B1_tile=*/B1_tile, /*B2_tile=*/B2_tile,
////                       C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
//          computeBlock(A_cache.getActive(), /*A1_tile=*/A_block_rows, /*A2_tile=*/A_block_cols,
//                       B_cache.getActive(), /*B1_tile=*/B_block_rows, /*B2_tile=*/B_block_cols,
//                       C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
//        });
//
//        if (copy_thread_A.joinable()) {
//          copy_thread_A.join();
//        }
//        if (copy_thread_B.joinable()) {
//          copy_thread_B.join();
//        }
//        compute_thread.join();
//        /// test
////        {
////          printf("-- %d: A_cache:\n", __LINE__);
//////          A_cache.getActive().print(A_block_rows, A_block_cols);
////          A_cache.getActive().print(A1_tile, A2_tile);
////          printf("-- %d: B_cache:\n", __LINE__);
//////          B_cache.getActive().print(B_block_rows, B_block_cols);
////          B_cache.getActive().print(B1_tile, B2_tile);
////          printf("-- %d: C[%llu-,%llu-]:\n", __LINE__, ii, jj);
//////          printf("i_bound: %llu, ii: %llu, k_bound: %llu, kk: %llu, j_bound: %llu, jj: %llu\n",
//////                 i_bound, ii, k_bound, kk, j_bound, jj);
////          printf("A1_tile: %llu, A2_tile: %llu, B1_tile: %llu, B2_tile: %llu\n",
////                 A1_tile, A2_tile, B1_tile, B2_tile);
////          uint64_t row_i_bound = std::min(A1, ii + A1_tile);
////          uint64_t col_j_bound = std::min(B2, jj + B2_tile);
////          for (uint64_t row_i = ii; row_i < row_i_bound; ++row_i) {
////            for (uint64_t col_j = jj; col_j < col_j_bound; ++col_j) {
////              printf("%lf, ", C[row_i * B2 + col_j]);
////            }
////            printf("\n");
////          }
////        }
//        /// end test
//
//        std::thread prefetch_B_thread;
//        std::thread prefetch_A_thread;
////        bool is_B_prefetched = false;
////        bool is_A_prefetched = false;
////        uint64_t jj_next = jj + B2_tile;
//        uint64_t jj_next = jj + B_block_cols;
//        if (jj_next < B2) {
//          /// If there more jPrefetch B to the inactive cache block
////          copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
////                    B_cache.getInactive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
//          uint64_t next_B_block_cols = std::min(B2_tile, B2 - jj_next);
//          prefetch_B_thread = std::thread([&]() {
////            copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
////                      B_cache.getInactive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
//            copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
//                      B_cache.getInactive(), /*block_rows=*/B_block_rows, /*block_cols=*/next_B_block_cols);
//          });
////          is_B_prefetched = true;
//          /// test
////          {
////            printf("%d: B_cache.getInactive():\n", __LINE__);
////            B_cache.getInactive().print(/*rows=*/B1_tile, /*cols=*/B2_tile);
////          }
//          /// end test
//        } else { /// jj_next >= B2
//          uint64_t kk_next = kk + A2_tile;
//          if (kk_next < A2) {
//            /// Prefetch B-block in the next row
//            jj_next = 0;
//            uint64_t next_B_block_rows = std::min(B1_tile, A2 - kk_next);
//            uint64_t next_B_block_cols = std::min(B2_tile, B2 - jj_next);
//            prefetch_B_thread = std::thread([&]() {
//              copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
//                        B_cache.getInactive(), /*block_rows=*/next_B_block_rows, /*block_cols=*/next_B_block_cols);
//            });
//            /// Prefetch A-block in current row
//            uint64_t next_A_block_cols = std::min(A2_tile, A2 - kk_next);
//            prefetch_A_thread = std::thread([&]() {
//              copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
//                        A_cache.getInactive(), /*block_rows=*/A_block_rows, /*block_cols=*/next_A_block_cols);
//            });
//          } else {
//            uint64_t ii_next = ii + A1_tile;
//            if (ii_next < A1) {
//              /// TODO: 1. prefetch here. 2. No need to copy the first block of the row then.
//            }
//          }
//
//        }
//
//
//
//        ////////////////////////////
//        uint64_t kk_next = kk + A2_tile;
//        if (jj_next >= B2 && kk_next < A2) {
//          /// Prefetch A to the inactive cache block
//          uint64_t next_A_block_cols = std::min(A2_tile, A2 - kk_next);
////          copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
////                    A_cache.getInactive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
//          prefetch_A_thread = std::thread([&]() {
////            copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
////                      A_cache.getInactive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
//            copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
//                      A_cache.getInactive(), /*block_rows=*/A_block_rows, /*block_cols=*/next_A_block_cols);
//          });
////          is_A_prefetched = true;
//          /// test
////          {
////            printf("%d: A_cache.getInactive():\n", __LINE__);
////            A_cache.getInactive().print(/*rows=*/A1_tile, /*cols=*/A2_tile);
////          }
//          /// end test
//        }
//
//        /// Join
////        compute_thread.join();
//        if (prefetch_B_thread.joinable()) {
//          prefetch_B_thread.join();
//          B_cache.swap();
//        }
//        if (prefetch_A_thread.joinable()) {
//          prefetch_A_thread.join();
//          A_cache.swap();
//        }
////        if (is_B_prefetched) {
////          B_cache.swap();
////        }
////        if (is_A_prefetched) {
////          A_cache.swap();
////        }
//
////        /////////////////////////////////////////////
////        /// Tile
////        for (uint64_t i = ii; i < i_bound; ++i) {
////          for (uint64_t k = kk; k < k_bound; ++k) {
////            for (uint64_t j = jj; j < j_bound; ++j) {
////              C[i * B2 + j] += A[i * A2 + k] * B[k * B2 + j];
////            }
////          }
////        }
//      }
//    }
//  }
//}

//-----------
// Utilities
//-----------