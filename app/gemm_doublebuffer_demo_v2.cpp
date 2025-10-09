//
// Created by Zhen Peng on 9/4/25.
//
#include <iostream>
#include "gemm.h"

int main()
{
  uint64_t dim_size = 5;
  uint64_t A1 = dim_size;
  uint64_t A2 = dim_size;
  uint64_t B1 = A2;
  uint64_t B2 = dim_size;
  uint64_t C1 = A1;
  uint64_t C2 = B2;
  double *A = create_matrix_in_dram(A1, A2, 1.1);
  double *B = create_matrix_in_dram(B1, B2, 2.2);
  double *C = create_matrix_in_dram(C1, C2);
  uint64_t tile_dim_size = 2;
  uint64_t A1_tile = tile_dim_size;
  uint64_t A2_tile = tile_dim_size;
  uint64_t B1_tile = A2_tile;
  uint64_t B2_tile = tile_dim_size;

  auto tt_start = std::chrono::high_resolution_clock::now();
  gemm_v7_background_thread(A, A1, A2, A1_tile, A2_tile,
                            B, B1, B2, B1_tile, B2_tile,
                            C);
//  gemm_v8_background_thread(A, A1, A2, A1_tile, A2_tile,
//                            B, B1, B2, B1_tile, B2_tile,
//                            C);

  auto tt_end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> tt_duration = tt_end - tt_start;
  std::cout << "DRAM test correctness dim_size: " << dim_size << ", time_exe(s): " << tt_duration.count() << "\n";

  print_matrix(C, C1, C2);
  destroy_matrix_in_dram(A);
  destroy_matrix_in_dram(B);
  destroy_matrix_in_dram(C);

  return 0;
}