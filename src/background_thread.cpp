//
// Created by Zhen Peng on 9/10/25.
//

#include <utility>
#include <iostream>
#include "background_thread.h"

void copy_to_buffer(double *A,
                    uint64_t A1,
                    uint64_t A2,
                    uint64_t A1_offset,
                    uint64_t A2_offset,
                    double *B,
                    uint64_t B1,
                    uint64_t B2,
                    uint64_t block_rows,
                    uint64_t block_cols)
{
  for (uint64_t i = 0; i < block_rows; ++i) {
    uint64_t a_i = A1_offset + i;
    for (uint64_t j = 0; j < block_cols; ++j) {
      uint64_t a_j = A2_offset + j;
      B[i * B2 + j] = A[a_i * A2 + a_j];
    }
  }
}

void do_gemm_on_buffer(double *A_buffer_active,
                       uint64_t A1_tile, uint64_t A2_tile,
                       uint64_t A_block_rows, uint64_t A_block_cols,
                       double *B_buffer_active,
                       uint64_t B1_tile, uint64_t B2_tile,
                       uint64_t B_block_rows, uint64_t B_block_cols,
                       double *C,
                       uint64_t C1, uint64_t C2,
                       uint64_t C1_offset, uint64_t C2_offset)
{
  for (uint64_t i = 0; i < A_block_rows; ++i) {
    uint64_t c_i = C1_offset + i;
    for (uint64_t k = 0; k < A_block_cols; ++k) {
      for (uint64_t j = 0; j < B_block_cols; ++j) {
        uint64_t c_j = C2_offset + j;
        C[c_i * C2 + c_j] += A_buffer_active[i * A2_tile + k] * B_buffer_active[k * B2_tile + j];
      }
    }
  }
}

void swap_buffer(double **buffer1, double **buffer2)
{
  std::swap(*buffer1, *buffer2);
}

/// Do swap on the auxiliary side
void background_process_v1(double *A,
                           uint64_t A1,
                           uint64_t A2,
                           double **A_buffer1,
                           double **A_buffer2,
                           uint64_t A1_tile,
                           uint64_t A2_tile,
                           std::atomic<bool> *A_buffer_is_ready,
                           double *B,
                           uint64_t B1,
                           uint64_t B2,
                           double **B_buffer1,
                           double **B_buffer2,
                           uint64_t B1_tile,
                           uint64_t B2_tile,
                           std::atomic<bool> *B_buffer_is_ready)
{
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;

      copy_to_buffer(A,
                     A1, A2,
                     /*A1_offset=*/ii, /*A2_offset=*/kk,
                     *A_buffer2,
                     A1_tile, A2_tile,
                     A_block_rows, A_block_cols);
      while (A_buffer_is_ready->load(std::memory_order_acquire)) {
        ;  /// Spin
      }
      swap_buffer(A_buffer1, A_buffer2);
      A_buffer_is_ready->store(true, std::memory_order_release);

      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);

        copy_to_buffer(B,
                       B1, B2,
                       kk, jj,
                       *B_buffer2,
                       B1_tile, B2_tile,
                       B_block_rows, B_block_cols);
        while (B_buffer_is_ready->load(std::memory_order_acquire)) {
          ; /// Spin
        }
        swap_buffer(B_buffer1, B_buffer2);
        B_buffer_is_ready->store(true, std::memory_order_release);
      }
    }
  }
}

/// Do swap on the auxiliary side
void intialize_thread_v1(std::thread &copy_thread,
                         double *A,
                         uint64_t A1,
                         uint64_t A2,
                         double **A_buffer1,
                         double **A_buffer2,
                         uint64_t A1_tile,
                         uint64_t A2_tile,
                         std::atomic<bool> *A_buffer_is_ready,
                         double *B,
                         uint64_t B1,
                         uint64_t B2,
                         double **B_buffer1,
                         double **B_buffer2,
                         uint64_t B1_tile,
                         uint64_t B2_tile,
                         std::atomic<bool> *B_buffer_is_ready)
{
  copy_thread = std::thread([&](){
    background_process_v1(A,
                          A1,
                          A2,
                          A_buffer1,
                          A_buffer2,
                          A1_tile,
                          A2_tile,
                          A_buffer_is_ready,
                          B,
                          B1,
                          B2,
                          B_buffer1,
                          B_buffer2,
                          B1_tile,
                          B2_tile,
                          B_buffer_is_ready);
  });
}


/// Do swap on the main side
void background_process_v2(double *A,
                           uint64_t A1,
                           uint64_t A2,
//                           double **A_buffer1,
                           double **A_buffer2,
                           uint64_t A1_tile,
                           uint64_t A2_tile,
                           std::atomic<bool> *A_buffer_is_ready,
                           double *B,
                           uint64_t B1,
                           uint64_t B2,
//                           double **B_buffer1,
                           double **B_buffer2,
                           uint64_t B1_tile,
                           uint64_t B2_tile,
                           std::atomic<bool> *B_buffer_is_ready)
{
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
      while (A_buffer_is_ready->load(std::memory_order_acquire)) {
        ;  /// Spin
      }
      copy_to_buffer(A,
                     A1, A2,
          /*A1_offset=*/ii, /*A2_offset=*/kk,
                     *A_buffer2,
                     A1_tile, A2_tile,
                     A_block_rows, A_block_cols);
      A_buffer_is_ready->store(true, std::memory_order_release);

      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
        while (B_buffer_is_ready->load(std::memory_order_acquire)) {
          ; /// Spin
        }
        copy_to_buffer(B,
                       B1, B2,
                       kk, jj,
                       *B_buffer2,
                       B1_tile, B2_tile,
                       B_block_rows, B_block_cols);
        B_buffer_is_ready->store(true, std::memory_order_release);
      }
    }
  }
}

/// Do swap on the main side
void intialize_thread_v2(std::thread &copy_thread,
                         double *A,
                         uint64_t A1,
                         uint64_t A2,
//                         double **A_buffer1,
                         double **A_buffer2,
                         uint64_t A1_tile,
                         uint64_t A2_tile,
                         std::atomic<bool> *A_buffer_is_ready,
                         double *B,
                         uint64_t B1,
                         uint64_t B2,
//                         double **B_buffer1,
                         double **B_buffer2,
                         uint64_t B1_tile,
                         uint64_t B2_tile,
                         std::atomic<bool> *B_buffer_is_ready)
{
  copy_thread = std::thread([&](){
    background_process_v2(A,
                          A1,
                          A2,
//                          A_buffer1,
                          A_buffer2,
                          A1_tile,
                          A2_tile,
                          A_buffer_is_ready,
                          B,
                          B1,
                          B2,
//                          B_buffer1,
                          B_buffer2,
                          B1_tile,
                          B2_tile,
                          B_buffer_is_ready);
  });
}

void sanity_check(double *array)
{
  std::cout << __FILE__ << ":" << __LINE__ << " sanity_check();" << std::endl;
}