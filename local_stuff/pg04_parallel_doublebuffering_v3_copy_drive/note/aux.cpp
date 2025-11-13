//
// Created by Zhen Peng on 11/5/25.
//
#include <stdlib.h>
#include <iostream>

int B_buffer_is_ready;
int *B_buffer_ready;
int num_local_i_tiles;
int A1, A2, A1_tile, A2_tile;
double *A, **A_buffer2;
void copy_worker(uint64_t worker_id,
                 int i_start,
                 int num_local_i_tiles)
{
  B_buffer_is_ready = B_buffer_ready[worker_id];
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
      swap_buffer(A_buffer1, A_buffer2);
      /// Set sizes and locations, to be fetched by compute workers
      A_block_rows_list[worker_id] = A_block_rows;
      /// ...

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
        B_block_rows_list[worker_id] = B_block_rows;
        /// ...
        B_buffer_is_ready->store(true, std::memory_order_release);
      }
    }
  }
}