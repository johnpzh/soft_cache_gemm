//
// Created by Zhen Peng on 9/10/25.
//

#ifndef SOFTCACHE_DEMO_BACKGROUND_THREAD_H
#define SOFTCACHE_DEMO_BACKGROUND_THREAD_H

#include <atomic>
#include <thread>
#include <iostream>
#include "soft_cache.h"

template<typename T>
void print_block(T *A,
                 uint64_t A1,
                 uint64_t A2,
                 uint64_t block1,
                 uint64_t block2)
{
  std::cout << "#### print_block [" << block1 << " x " << block2 << "]" << std::endl;
  for (uint64_t i = 0; i < block1; ++i) {
    for (uint64_t j = 0; j < block2; ++j) {
      std::cout << A[i * A2 + j] << " ";
    }
    std::cout << std::endl;
  }
}


void copy_to_buffer(double *A, /* source matrix */
                    uint64_t A1, uint64_t A2, /* source matrix dimensions */
                    uint64_t A1_offset, uint64_t A2_offset, /* source location offset */
                    double *B, /* destination buffer */
                    uint64_t B1, uint64_t B2, /* destination buffer dimensions */
                    uint64_t block_rows, uint64_t block_cols /* copied block dimensions */);


void do_gemm_on_buffer(double *A_buffer_active,
                       uint64_t A1_tile, uint64_t A2_tile, /* A buffer dimensions */
                       uint64_t A_block_rows, uint64_t A_block_cols, /* current block dimensions in A */
                       double *B_buffer_active,
                       uint64_t B1_tile, uint64_t B2_tile, /* B buffer dimensions */
                       uint64_t B_block_rows, uint64_t B_block_cols, /* current block dimensions in B */
                       double *C,
                       uint64_t C1, uint64_t C2, /* C dimensions */
                       uint64_t C1_offset, uint64_t C2_offset /* writing location offset */);


void swap_buffer(double **buffer1, double **buffer2);

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
                           std::atomic<bool> *B_buffer_is_ready);

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
                           std::atomic<bool> *B_buffer_is_ready);


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
                         std::atomic<bool> *B_buffer_is_ready);

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
                         std::atomic<bool> *B_buffer_is_ready);


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
                          uint64_t num_workers);
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
                          uint64_t num_local_j_tiles);
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
                    uint64_t worker_id);

#ifdef __cplusplus
extern "C" {
#endif

void sanity_check(double *array);

#ifdef __cplusplus
}
#endif


#endif //SOFTCACHE_DEMO_BACKGROUND_THREAD_H
