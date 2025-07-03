#include <iostream>
#include <fstream>
#include <sstream>
#include <chrono>
//#include <format>
#include <stdio.h>
#include "gemm.h"

int main()
{
  auto master_tt_start = std::chrono::high_resolution_clock::now();
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
  DoubleBuffer A_cache(A1, A2);
  DoubleBuffer B_cache(B1, B2);

//  for (uint64_t i = 0; i < A1 * A2; ++i) {
//    A[i] = i;
//    B[i] = i;
//  }

  auto tt_start = std::chrono::high_resolution_clock::now();
  /// Kernel
//  gemm_v0(A, A1, A2,
//          B, B1, B2,
//          C);
  gemm_v4_softcache(A, A1, A2, A1_tile, A2_tile, A_cache,
                    B, B1, B2, B1_tile, B2_tile, B_cache,
                    C);

  auto tt_end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> tt_duration = tt_end - tt_start;
  std::cout << "DRAM test correctness dim_size: " << dim_size << ", time_exe(s): " << tt_duration.count() << "\n";

  print_matrix(C, C1, C2);
  destroy_matrix_in_dram(A);
  destroy_matrix_in_dram(B);
  destroy_matrix_in_dram(C);

  return 0;
}
