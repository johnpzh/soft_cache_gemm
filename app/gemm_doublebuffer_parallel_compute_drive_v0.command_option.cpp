//
// Created by Zhen Peng on 10/29/25.
//

#include <iostream>
#include <fstream>
#include <sstream>
#include <chrono>
#include <stdio.h>
#include <string.h>
#include <unordered_map>
#include "gemm.h"
#include "rapid.h"

int main(int argc, char *argv[])
{
  /// app <matrix-size> <tile-size> <num-threads>
  if (argc != 4) {
    fprintf(stderr, "Usage: %s <matrix-size> <tile-size> <num-threads>\n", argv[0]);
    exit(EXIT_FAILURE);
  }
  uint64_t matrix_size = std::strtoull(argv[1], nullptr, 0);
  uint64_t tile_size = std::strtoull(argv[2], nullptr, 0);
  uint64_t num_threads = std::strtoull(argv[3], nullptr, 0);

  uint64_t num_aux_worker = 1;
  uint64_t num_compute_workers = num_threads;

  auto master_tt_start = std::chrono::high_resolution_clock::now();
  rapid_handle fam = rapid_initialize();

  uint64_t A1 = matrix_size;
  uint64_t A2 = matrix_size;
  uint64_t B1 = A2;
  uint64_t B2 = matrix_size;
  uint64_t C1 = A1;
  uint64_t C2 = B2;
  double *A = create_matrix_in_fam(fam, A1, A2, 1.1);
  double *B = create_matrix_in_fam(fam, B1, B2, 2.2);
  double *C = create_matrix_in_fam(fam, C1, C2);
//    double *A = create_matrix_in_dram(A1, A2, 1.1);
//    double *B = create_matrix_in_dram(B1, B2, 2.2);
//    double *C = create_matrix_in_dram(C1, C2);

  uint64_t A1_tile = tile_size;
  uint64_t A2_tile = tile_size;
  uint64_t B1_tile = A2_tile;
  uint64_t B2_tile = tile_size;

//          /// Correctness reference
//          auto baseline_tt_start = std::chrono::high_resolution_clock::now();
//          gemm_v0(A, A1, A2,
//                  B, B1, B2,
//                  C);
//          auto baseline_tt_end = std::chrono::high_resolution_clock::now();
//          std::chrono::duration<double> baseline_tt_duration = baseline_tt_end - baseline_tt_start;
//          std::cout << "sum_C: " << sum_matrix(C, C1, C2) << ", ";
//          std::cout << "Baseline: time_exe(s): " << baseline_tt_duration.count() << std::endl;
//          memset(C, 0, sizeof(double) * C1 * C2);

  /// Kernel
  auto tt_start = std::chrono::high_resolution_clock::now();
  if (num_compute_workers > 0) {
    gemm_v11_doublebuffer_parallel_compute_drive(
        A, A1, A2, A1_tile, A2_tile,
        B, B1, B2, B1_tile, B2_tile,
        C,
        num_compute_workers,
        num_aux_worker);
  } else {
    gemm_v12_doublebuffer_sequential_compute_drive(
        A, A1, A2, A1_tile, A2_tile,
        B, B1, B2, B1_tile, B2_tile,
        C);
  }
  auto tt_end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> tt_duration = tt_end - tt_start;
//        print_matrix(C, C1, C2);
  std::cout << "sum_C: " << sum_matrix(C, C1, C2) << ", ";
  std::cout << "FAM double-buffer dim_size: " << matrix_size
            << ", buffer_size: " << tile_size
            << ", num_compute_workers: " << num_compute_workers
            << ", time_exe(s): " << tt_duration.count()
            << std::endl;

  destroy_matrix_in_fam(fam, A);
  destroy_matrix_in_fam(fam, B);
  destroy_matrix_in_fam(fam, C);

  auto master_tt_end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> master_tt_duration = master_tt_end - master_tt_start;
  std::cout << "TOTAL_EXE_TIME(S): " << master_tt_duration.count() << std::endl;

  return 0;

}