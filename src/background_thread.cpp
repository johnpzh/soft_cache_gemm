//
// Created by Zhen Peng on 9/10/25.
//

#include <utility>
#include <iostream>
#include <algorithm>
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
//  copy_thread = std::thread([&](){
//    background_process_v1(A,
//                          A1,
//                          A2,
//                          A_buffer1,
//                          A_buffer2,
//                          A1_tile,
//                          A2_tile,
//                          A_buffer_is_ready,
//                          B,
//                          B1,
//                          B2,
//                          B_buffer1,
//                          B_buffer2,
//                          B1_tile,
//                          B2_tile,
//                          B_buffer_is_ready);
//  });
  copy_thread = std::thread(
    background_process_v1,
    A,
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
    B_buffer_is_ready
  );
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
//  copy_thread = std::thread([&](){
//    background_process_v2(A,
//                          A1,
//                          A2,
////                          A_buffer1,
//                          A_buffer2,
//                          A1_tile,
//                          A2_tile,
//                          A_buffer_is_ready,
//                          B,
//                          B1,
//                          B2,
////                          B_buffer1,
//                          B_buffer2,
//                          B1_tile,
//                          B2_tile,
//                          B_buffer_is_ready);
//  });
  copy_thread = std::thread(
    background_process_v2,
    A,
    A1,
    A2,
//  A_buffer1,
    A_buffer2,
    A1_tile,
    A2_tile,
    A_buffer_is_ready,
    B,
    B1,
    B2,
//  B_buffer1,
    B_buffer2,
    B1_tile,
    B2_tile,
    B_buffer_is_ready
  );
}

/// ------------------------------------------
/// Parallel Double Buffering on jj dimension
/// ------------------------------------------
std::mutex log_mtx;

void background_A_process(double *A,
                          uint64_t A1,
                          uint64_t A2,
                          double **A_buffer1,
                          double **A_buffer2,
                          uint64_t A1_tile,
                          uint64_t A2_tile,
//                          std::atomic<uint64_t> *A_in_use,
//                          std::atomic<uint64_t> *A_in_after_use,
                          std::vector<std::atomic<bool> *> &A_buffer_is_ready_list,
                          uint64_t num_workers)
{
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      copy_to_buffer(A,
                     A1, A2,
                     /*A1_offset=*/ii, /*A2_offset=*/kk,
                     *A_buffer2,
                     A1_tile, A2_tile,
                     A_block_rows, A_block_cols);
//      while (A_in_use->load(std::memory_order_acquire) > 0) {
//        ; /// Spin until all workers done with previous A
//
////        /// test
////        {
////          std::lock_guard<std::mutex> lk(log_mtx);
////          std::cout << "A aux spin... A_in_use: " << A_in_use->load(std::memory_order_acquire) << " ii: " << ii << " kk: " << kk << std::endl;
////        }
//////        std::this_thread::sleep_for(std::chrono::milliseconds(100));
////        /// end test
//      }
      while (std::any_of(A_buffer_is_ready_list.begin(),
                         A_buffer_is_ready_list.end(),
                         [](std::atomic<bool> *is_ready) {return is_ready->load(std::memory_order_acquire);})) {
        ; /// Spin until all workers done with previous A
      }
      swap_buffer(A_buffer1, A_buffer2);
//      /// test
//      {
//        std::lock_guard<std::mutex> lk(log_mtx);
//        std::cout << "A aux before store A_in_use: " << A_in_use->load(std::memory_order_acquire) << " ii: " << ii << " kk: " << kk << std::endl;
//      }
//      /// end test
//      while(A_in_after_use->load(std::memory_order_acquire) > 0) {
//        ; /// Spin until all workers finished waiting
//      }
//      A_in_use->store(num_workers, std::memory_order_release);
      std::for_each(A_buffer_is_ready_list.begin(),
                    A_buffer_is_ready_list.end(),
                    [](std::atomic<bool> *is_ready) {is_ready->store(true, std::memory_order_release);});
    }
  }
}


void background_B_process(uint64_t A1,
                          uint64_t A2,
                          uint64_t A1_tile,
                          uint64_t A2_tile,
                          double *B,
                          uint64_t B1,
                          uint64_t B2,
                          double **B_buffer1,
                          double **B_buffer2,
                          uint64_t B1_tile,
                          uint64_t B2_tile,
                          std::atomic<bool> *B_buffer_is_ready,
                          uint64_t j_start,
                          uint64_t num_local_j_tiles)
{
//  uint64_t B2_local = B2;  // For boundary checks
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    for (uint64_t kk = 0; kk < A2; kk += B1_tile) {
//      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = std::min(B1_tile, B1 - kk);  // Matches A_block_cols
      for (uint64_t local_j = 0; local_j < num_local_j_tiles; ++local_j) {
        uint64_t jj = j_start + local_j * B2_tile;
//        if (jj >= B2_local) break;
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);

        copy_to_buffer(B,
                       B1, B2,
                       /*B1_offset=*/kk, /*B2_offset=*/jj,
                       *B_buffer2,
                       B1_tile, B2_tile,
                       B_block_rows, B_block_cols);
        while (B_buffer_is_ready->load(std::memory_order_acquire)) {
          ; /// Spin until worker done with current B
//          /// test
////          std::cout << "spin in B aux..." << std::endl;
//          std::this_thread::sleep_for(std::chrono::milliseconds (100));
//          /// end test
        }
        swap_buffer(B_buffer1, B_buffer2);
        B_buffer_is_ready->store(true, std::memory_order_release);
      }
    }
  }
}

void compute_worker(uint64_t A1,
                    uint64_t A2,
                    uint64_t B1,
                    uint64_t B2,
                    double **A_buffer1,
                    uint64_t A1_tile,
                    uint64_t A2_tile,
//                    std::atomic<uint64_t> *A_in_use,
//                    std::atomic<uint64_t> *A_in_after_use,
                    std::atomic<bool> *A_buffer_is_ready,
                    double **B_buffer1,
                    uint64_t B1_tile,
                    uint64_t B2_tile,
                    std::atomic<bool> *B_buffer_is_ready,
                    double *C,
                    uint64_t j_start,
                    uint64_t num_local_j_tiles,
                    uint64_t worker_id)
{
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
//      while (A_in_use->load(std::memory_order_acquire) == 0) {
//        ; /// Spin until A loaded
////        /// test
////        {
////          std::lock_guard<std::mutex> lk(log_mtx);
////          std::cout << "A main spin before... worker_id: " << worker_id << " A_in_use: " << A_in_use->load(std::memory_order_acquire) << " ii: " << ii << " kk: " << kk << std::endl;
////        }
//////        std::this_thread::sleep_for(std::chrono::milliseconds(100));
////        /// end test
//      }
      while (!A_buffer_is_ready->load(std::memory_order_acquire)) {
        ; /// Spin
      }
      for (uint64_t local_j = 0; local_j < num_local_j_tiles; ++local_j) {
        uint64_t jj = j_start + local_j * B2_tile;
//        if (jj >= B2) break;
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
        while (!B_buffer_is_ready->load(std::memory_order_acquire)) {
          ; /// Spin until B loaded
//          /// test
////          std::cout << "spin in B main..." << std::endl;
//          std::this_thread::sleep_for(std::chrono::milliseconds (100));
//          /// end test
        }
        do_gemm_on_buffer(*A_buffer1, A1_tile, A2_tile, A_block_rows, A_block_cols,
                          *B_buffer1, B1_tile, B2_tile, B_block_rows, B_block_cols,
                          C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
        B_buffer_is_ready->store(false, std::memory_order_release);
      }
//      /// test
//      {
//        std::lock_guard<std::mutex> lk(log_mtx);
//        std::cout << "A main before fetch_sub worker_id: " << worker_id << " A_in_use: " << A_in_use->load(std::memory_order_acquire) << " ii: " << ii << " kk: " << kk << std::endl;
//      }
//      /// end test
//      A_in_use->fetch_sub(1, std::memory_order_seq_cst);  // Signal done with A
////      A_in_after_use->fetch_add(1, std::memory_order_seq_cst);
//      while (A_in_use->load(std::memory_order_acquire) > 0 ) {  /// a rendezvous barrier
//        ; /// Spin until all workers finished
//        /// test
//        {
////          std::lock_guard<std::mutex> lk(log_mtx);
////          std::cout << "A main spin after... worker_id: " << worker_id << " A_in_use: " << A_in_use->load(std::memory_order_acquire) << " ii: " << ii << " kk: " << kk << std::endl;
////          std::cout << "A main spin after... worker_id: " << worker_id << " ii: " << ii << " kk: " << kk << std::endl;
////            std::cout << "A main spin after... " << std::endl;
//        }
////        std::this_thread::sleep_for(std::chrono::milliseconds(100));
//        /// end test
//      }
//      A_in_after_use->fetch_sub(1, std::memory_order_seq_cst);
      A_buffer_is_ready->store(false, std::memory_order_release);
    }
  }
}

/// ------------------------------------------
/// Parallel Double Buffering on ii dimension
/// ------------------------------------------

void main_compute_on_ii(uint64_t A1,
                        uint64_t A2,
                        uint64_t A1_tile,
                        uint64_t A2_tile,
                        double **A_buffer1,
                        std::atomic<bool> *A_buffer_is_ready,
                        uint64_t B1,
                        uint64_t B2,
                        uint64_t B1_tile,
                        uint64_t B2_tile,
                        double **B_buffer1,
                        std::atomic<bool> *B_buffer_is_ready,
                        double *C,
                        uint64_t i_start,
                        uint64_t num_local_i_tiles)
{
  for (uint64_t local_i = 0; local_i < num_local_i_tiles; ++local_i) {
    uint64_t ii = i_start + local_i * A1_tile;
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
      /// Sync A_buffer
      while (!A_buffer_is_ready->load(std::memory_order_acquire)) {
        ; /// Spin
      }
      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
        /// Sync B_buffer
        while (!B_buffer_is_ready->load(std::memory_order_acquire)) {
          ; /// Spin
        }
        do_gemm_on_buffer(/*A_buffer_active=*/*A_buffer1, A1_tile, A2_tile, A_block_rows, A_block_cols,
                          /*B_buffer_active=*/*B_buffer1, B1_tile, B2_tile, B_block_rows, B_block_cols,
                          C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
        B_buffer_is_ready->store(false, std::memory_order_release);
      }
      A_buffer_is_ready->store(false, std::memory_order_release);
    }
  }
}

void aux_copy_on_ii(double *A,
                    uint64_t A1,
                    uint64_t A2,
                    uint64_t A1_tile,
                    uint64_t A2_tile,
                    double **A_buffer1,
                    double **A_buffer2,
                    std::atomic<bool> *A_buffer_is_ready,
                    double *B,
                    uint64_t B1,
                    uint64_t B2,
                    uint64_t B1_tile,
                    uint64_t B2_tile,
                    double **B_buffer1,
                    double **B_buffer2,
                    std::atomic<bool> *B_buffer_is_ready,
                    uint64_t i_start,
                    uint64_t num_local_i_tiles)
{
  for (uint64_t local_i = 0; local_i < num_local_i_tiles; ++local_i) {
    uint64_t ii = i_start + local_i * A1_tile;
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
        ; /// Spin
      }
      swap_buffer(A_buffer1, A_buffer2);
      A_buffer_is_ready->store(true, std::memory_order_release);

      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);

        copy_to_buffer(B,
                       B1, B2,
                       /*B1_offset=*/kk, /*B2_offset=*/jj,
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


/// ------------------------------------------------------------------------
/// Parallel Double Buffering, number of main and number aux are different.
/// Use computer workers to drive the procedure.
/// ------------------------------------------------------------------------
void compute_worker_drive(uint64_t A1,
                          uint64_t A2,
                          uint64_t A1_tile,
                          uint64_t A2_tile,
                          uint64_t *A1_offset_ptr,
                          uint64_t *A2_offset_ptr,
                          uint64_t *A_block_rows_ptr,
                          uint64_t *A_block_cols_ptr,
                          double **A_buffer1,
                          std::atomic<bool> *A_buffer_is_ready,
                          uint64_t B1,
                          uint64_t B2,
                          uint64_t B1_tile,
                          uint64_t B2_tile,
                          uint64_t *B1_offset_ptr,
                          uint64_t *B2_offset_ptr,
                          uint64_t *B_block_rows_ptr,
                          uint64_t *B_block_cols_ptr,
                          double **B_buffer1,
                          std::atomic<bool> *B_buffer_is_ready,
                          double *C,
                          uint64_t i_start,
                          uint64_t num_local_i_tiles,
                          std::atomic<bool> *is_finished)
{
  for (uint64_t local_i = 0; local_i < num_local_i_tiles; ++local_i) {
    uint64_t ii = i_start + local_i * A1_tile;
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    *A1_offset_ptr = ii;
    *A_block_rows_ptr = A_block_rows;
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
      *A2_offset_ptr = kk;
      *B1_offset_ptr = kk;
      *A_block_cols_ptr = A_block_cols;
      *B_block_rows_ptr = B_block_rows;
      /// Sync A_buffer
      A_buffer_is_ready->store(false, std::memory_order_release);
      while (!A_buffer_is_ready->load(std::memory_order_acquire)) {
        ; /// Spin
      }
      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
        uint64_t B_block_cols = std::min(B2_tile, B2 - jj);
        *B2_offset_ptr = jj;
        *B_block_cols_ptr = B_block_cols;
        /// Sync B_buffer
        B_buffer_is_ready->store(false, std::memory_order_release);
        while (!B_buffer_is_ready->load(std::memory_order_acquire)) {
          ; /// Spin
        }
        do_gemm_on_buffer(/*A_buffer_active=*/*A_buffer1, A1_tile, A2_tile, A_block_rows, A_block_cols,
            /*B_buffer_active=*/*B_buffer1, B1_tile, B2_tile, B_block_rows, B_block_cols,
                                              C, /*C1=*/A1, /*C2=*/B2, /*C1_offset=*/ii, /*C2_offset=*/jj);
        B_buffer_is_ready->store(false, std::memory_order_release);
      }
      A_buffer_is_ready->store(false, std::memory_order_release);
    }
  }

  is_finished->store(true, std::memory_order_release);
}

void aux_worker_pull(double *A,
                     uint64_t A1,
                     uint64_t A2,
                     uint64_t A1_tile,
                     uint64_t A2_tile,
                     std::vector<double *> &A_buffer1s,
                     std::vector<double *> &A_buffer2s,
                     std::vector<uint64_t> &A1_offset_list,
                     std::vector<uint64_t> &A2_offset_list,
                     std::vector<uint64_t> &A_block_rows_list,
                     std::vector<uint64_t> &A_block_cols_list,
                     std::vector<std::atomic<bool> *> &A_buffer_readys,
                     double *B,
                     uint64_t B1,
                     uint64_t B2,
                     uint64_t B1_tile,
                     uint64_t B2_tile,
                     std::vector<double *> &B_buffer1s,
                     std::vector<double *> &B_buffer2s,
                     std::vector<uint64_t> &B1_offset_list,
                     std::vector<uint64_t> &B2_offset_list,
                     std::vector<uint64_t> &B_block_rows_list,
                     std::vector<uint64_t> &B_block_cols_list,
                     std::vector<std::atomic<bool> *> &B_buffer_readys,
                     uint64_t compute_worker_start,
                     uint64_t num_local_compute_worker,
                     std::vector<std::atomic<bool> *> &compute_worker_finished)
{
  uint64_t compute_worker_bound = compute_worker_start + num_local_compute_worker;
  while(std::any_of(compute_worker_finished.begin() + compute_worker_start,
                    compute_worker_finished.begin() + compute_worker_bound,
                    [](std::atomic<bool> *is_finished) {
                      return !is_finished->load(std::memory_order_acquire);
                    })) {
    for (uint64_t w = compute_worker_start; w < compute_worker_bound; ++w) {
      if (A_buffer_readys[w]->load(std::memory_order_acquire)) {
        continue;
      }
      uint64_t A1_offset = A1_offset_list[w];
      uint64_t A2_offset = A2_offset_list[w];
      uint64_t A_block_rows = A_block_rows_list[w];
      uint64_t A_block_cols = A_block_cols_list[w];
      double **A_buffer1 = &A_buffer1s[w];
      double **A_buffer2 = &A_buffer2s[w];

      copy_to_buffer(A,
                     A1, A2,
                     A1_offset, A2_offset,
                     *A_buffer2,
                     A1_tile, A2_tile,
                     A_block_rows, A_block_cols);
      swap_buffer(A_buffer1, A_buffer2);
      A_buffer_readys[w]->store(true, std::memory_order_release);
    }

    for (uint64_t w = compute_worker_start; w < compute_worker_bound; ++w) {
      if (B_buffer_readys[w]->load(std::memory_order_acquire)) {
        continue;
      }
      uint64_t B1_offset = B1_offset_list[w];
      uint64_t B2_offset = B2_offset_list[w];
      uint64_t B_block_rows = B_block_rows_list[w];
      uint64_t B_block_cols = B_block_cols_list[w];
      double **B_buffer1 = &B_buffer1s[w];
      double **B_buffer2 = &B_buffer2s[w];

      copy_to_buffer(B,
                     B1, B2,
                     B1_offset, B2_offset,
                     *B_buffer2,
                     B1_tile, B2_tile,
                     B_block_rows, B_block_cols);
      swap_buffer(B_buffer1, B_buffer2);
      B_buffer_readys[w]->store(true, std::memory_order_release);
    }
  }
}


///// ------------------------------------------------------------------------
///// Parallel Double Buffering, number of main and number aux are different.
///// Use auxiliary workers to drive the procedure
///// ------------------------------------------------------------------------
//
//void aux_worker(double *A,
//                    uint64_t A1,
//                    uint64_t A2,
//                    uint64_t A1_tile,
//                    uint64_t A2_tile,
//                    uint64_t *A_block_rows,
//                    uint64_t *A_block_cols,
//                    double **A_buffer1,
//                    double **A_buffer2,
//                    std::atomic<bool> *A_buffer_is_ready,
//                    double *B,
//                    uint64_t B1,
//                    uint64_t B2,
//                    uint64_t B1_tile,
//                    uint64_t B2_tile,
//                    uint64_t *B_block_rows,
//                    uint64_t *B_block_cols,
//                    double **B_buffer1,
//                    double **B_buffer2,
//                    std::atomic<bool> *B_buffer_is_ready,
//                    uint64_t *C1_offset,
//                    uint64_t *C2_offset,
//                    uint64_t i_start,
//                    uint64_t num_local_i_tiles,
//                    std::atomic<bool> *is_all_finished)
//{
//  for (uint64_t local_i = 0; local_i < num_local_i_tiles; ++local_i) {
//    uint64_t ii = i_start + local_i * A1_tile;
//    *A_block_rows = std::min(A1_tile, A1 - ii);
//    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
//      *A_block_cols = std::min(A2_tile, A2 - kk);
//      *B_block_rows = *A_block_cols;
//
//      copy_to_buffer(A,
//                     A1, A2,
//                     /*A1_offset=*/ii, /*A2_offset=*/kk,
//                     *A_buffer2,
//                     A1_tile, A2_tile,
//                     *A_block_rows, *A_block_cols);
//      while (A_buffer_is_ready->load(std::memory_order_acquire)) {
//        ; /// Spin
//      }
//      swap_buffer(A_buffer1, A_buffer2);
//      A_buffer_is_ready->store(true, std::memory_order_release);
//
//      for (uint64_t jj = 0; jj < B2; jj += B2_tile) {
//        *B_block_cols = std::min(B2_tile, B2 - jj);
//
//        copy_to_buffer(B,
//                       B1, B2,
//                       /*B1_offset=*/kk, /*B2_offset=*/jj,
//                       *B_buffer2,
//                       B1_tile, B2_tile,
//                       *B_block_rows, *B_block_cols);
//        while (B_buffer_is_ready->load(std::memory_order_acquire)) {
//          ; /// Spin
//        }
//        swap_buffer(B_buffer1, B_buffer2);
//        *C1_offset = ii;
//        *C2_offset = jj;
//        B_buffer_is_ready->store(true, std::memory_order_release);
//      }
//    }
//  }
//  is_all_finished->store(true, std::memory_order_release);
//}
//
//void main_worker(std::vector<double *> A_buffer1s,
//                 uint64_t A1_tile,
//                 uint64_t A2_tile,
//                 std::vector<uint64_t> &A_block_rows_list,
//                 std::vector<uint64_t> &A_block_cols_list,
//                 std::vector<double *> B_buffer1s,
//                 uint64_t B1_tile,
//                 uint64_t B2_tile,
//                 std::vector<uint64_t> &B_block_rows_list,
//                 std::vector<uint64_t> &B_block_cols_list,
//                 double *C,
//                 uint64_t C1,
//                 uint64_t C2,
//                 std::vector<uint64_t> &C1_offset_list,
//                 std::vector<uint64_t> &C2_offset_list,
//                 std::vector<std::atomic<bool> *> &B_buffer_readys,
//                 uint64_t num_copy_workers,
//                 std::atomic<bool> *is_all_finished)
//{
//  while (!is_all_finished->load(std::memory_order_acquire)) {
//    for (uint64_t w = 0; w < num_copy_workers; ++w) {
//      std::atomic<bool> *B_buffer_is_ready = B_buffer_readys[w];
//      if (B_buffer_is_ready) {
//        double *A_buffer1 = A_buffer1s[w];
//        uint64_t A_block_rows = A_block_rows_list[w];
//        uint64_t A_block_cols = A_block_cols_list[w];
//        double *B_buffer1 = B_buffer1s[w];
//        uint64_t B_block_rows = B_block_rows_list[w];
//        uint64_t B_block_cols = B_block_cols_list[w];
//        uint64_t C1_offset = C1_offset_list[w];
//        uint64_t C2_offset = C2_offset_list[w];
//        do_gemm_on_buffer(A_buffer1,
//                          A1_tile,
//                          A2_tile,
//                          A_block_rows,
//                          A_block_cols,
//                          B_buffer1,
//                          B1_tile,
//                          B2_tile,
//                          B_block_rows,
//                          B_block_cols,
//                          C,
//                          C1,
//                          C2,
//                          C1_offset,
//                          C2_offset);
//        B_buffer_is_ready->store(false, std::memory_order_release);
//      }
//    }
//  }
//}


void sanity_check(double *array)
{
  std::cout << __FILE__ << ":" << __LINE__ << " sanity_check();" << std::endl;
}