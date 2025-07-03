//
// Created by Zhen Peng on 5/28/25.
//

#include <algorithm>
#include <iostream>
#include <thread>
#include <stdlib.h>
#include <cstring>
#include "gemm.h"

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

double *create_matrix_in_fam(rapid_handle fam, uint64_t num_rows, uint64_t num_cols, double val)
{
  uint64_t size = num_rows * num_cols;
  double *matrix = (double *) rapid_malloc(fam, size * sizeof(double));
  if (val) {
    std::fill(matrix, matrix + size, val);
  } else {
    memset(matrix, 0, size * sizeof(double));
  }

  return matrix;
}

void destroy_matrix_in_fam(rapid_handle fam, double *matrix)
{
  rapid_free(fam, matrix);
}

void print_matrix(double *matrix, uint64_t num_rows, uint64_t num_cols)
{
  for (uint64_t i = 0; i < num_rows; ++i) {
    for (uint64_t j = 0; j < num_cols; ++j) {
      std::cout << matrix[i * num_cols + j] << ", ";
    }
    std::cout << "\n";
  }
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
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      /// test
//      printf("kk: %llu\n", kk);
      /// end test
      std::thread copy_thread_A;
      if (kk == 0) {
        /// new row in A. Prepare the A_cache
//        copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
//                  A_cache.getActive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
        copy_thread_A = std::thread([&](){
          copyBlock(A, A1, A2, /*row_offset=*/ii, /*col_offset=*/kk,
                    A_cache.getActive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
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
        std::thread copy_thread_B;
        if (jj == 0) {
          /// new row in B. Prepare the B_cache
//          copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
//                    B_cache.getActive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
          copy_thread_B = std::thread([&](){
            copyBlock(B, B1, B2, /*row_offset=*/kk, /*col_offset=*/jj,
                      B_cache.getActive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
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
          computeBlock(A_cache.getActive(), /*A1_tile=*/A1_tile, /*A2_tile=*/A2_tile,
                       B_cache.getActive(), /*B1_tile=*/B1_tile, /*B2_tile=*/B2_tile,
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
        uint64_t jj_next = jj + B2_tile;
        if (jj_next < B2) {
          /// If there more jPrefetch B to the inactive cache block
//          copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
//                    B_cache.getInactive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
          prefetch_B_thread = std::thread([&]() {
            copyBlock(B, /*rows=*/B1, /*cols=*/B2, /*row_offset=*/kk, /*col_offset=*/jj_next,
                      B_cache.getInactive(), /*block_rows=*/B1_tile, /*block_cols=*/B2_tile);
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
//          copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
//                    A_cache.getInactive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
          prefetch_A_thread = std::thread([&]() {
            copyBlock(A, /*rows=*/A1, /*cols=*/A2, /*row_offset=*/ii, /*col_offset=*/kk_next,
                      A_cache.getInactive(), /*block_rows=*/A1_tile, /*block_cols=*/A2_tile);
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

//-----------
// Utilities
//-----------
