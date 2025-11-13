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

int main()
{
  auto master_tt_start = std::chrono::high_resolution_clock::now();
  rapid_handle fam = rapid_initialize();
  uint64_t num_repeats = 10;  /// When dim_size 4096, tile_dim_size 8, num_repeats 2 -> time_exe(s) 49.648
  /// When dim_size 4096, tile_dim_size 8, num_repeats 4 -> time_exe(s) 76.3903
  /// Not sure why.

  std::vector<uint64_t> dim_sizes;
  for (uint64_t dim_size = 4096; dim_size <= 8192; dim_size *= 2) {
//  for (uint64_t dim_size = 8; dim_size <= 512; dim_size *= 2) {
    dim_sizes.push_back(dim_size);
  }
//  std::vector<double> gemm_no_tiling_avg_times;
//  std::vector<double> gemm_tiling_avg_times;

  std::vector<uint64_t> tile_dim_sizes;
  for (uint64_t tile_dim_size = 8; tile_dim_size <= 2048; tile_dim_size *= 2) {
//  for (uint64_t tile_dim_size = 8; tile_dim_size <= 8; tile_dim_size *= 2) {
    tile_dim_sizes.push_back(tile_dim_size);
  }

  std::vector<uint64_t> num_workers_list;
  for (uint64_t w = 1; w <= 16; w *= 2) {
    num_workers_list.push_back(w);  /// (2*w + 1) threads
  }
  num_workers_list.push_back(27);  /// (54 + 1) threads
//  for (uint64_t w = 8; w <= 8; w *= 2) {
//    num_workers_list.push_back(w);  /// (2*w + 1) threads
//  }

//  std::unordered_map<uint64_t, std::vector<double>> gemm_tiling_avg_times_table;
  for (uint64_t dim_size : dim_sizes) {
    uint64_t A1 = dim_size;
    uint64_t A2 = dim_size;
    uint64_t B1 = A2;
    uint64_t B2 = dim_size;
    uint64_t C1 = A1;
    uint64_t C2 = B2;
    double *A = create_matrix_in_fam(fam, A1, A2, 1.1);
    double *B = create_matrix_in_fam(fam, B1, B2, 2.2);
    double *C = create_matrix_in_fam(fam, C1, C2);
//    double *A = create_matrix_in_dram(A1, A2, 1.1);
//    double *B = create_matrix_in_dram(B1, B2, 2.2);
//    double *C = create_matrix_in_dram(C1, C2);

    /// Tiling
//    uint64_t tile_dim_size = 512;
    std::unordered_map<uint64_t, std::vector<double>> gemm_tiling_avg_times_table;
    for (uint64_t tile_dim_size: tile_dim_sizes) {
      uint64_t A1_tile = tile_dim_size;
      uint64_t A2_tile = tile_dim_size;
      uint64_t B1_tile = A2_tile;
      uint64_t B2_tile = tile_dim_size;


//      uint64_t num_workers = 12;
      for (uint64_t num_workers: num_workers_list) {
        std::vector<double> tiling_exe_times;
        for (uint64_t r_i = 0; r_i < num_repeats; ++r_i) {
          memset(C, 0, C1 * C2 * sizeof(double));


          /// Kernel
//          auto baseline_tt_start = std::chrono::high_resolution_clock::now();
//          gemm_v0(A, A1, A2,
//                  B, B1, B2,
//                  C);
//          auto baseline_tt_end = std::chrono::high_resolution_clock::now();
//          std::chrono::duration<double> baseline_tt_duration = baseline_tt_end - baseline_tt_start;
//          std::cout << "sum_C: " << sum_matrix(C, C1, C2) << std::endl;
//          std::cout << "Baseline: time_exe(s): " << baseline_tt_duration.count() << std::endl;
//          memset(C, 0, sizeof(double) * C1 * C2);

          auto tt_start = std::chrono::high_resolution_clock::now();
          gemm_v10_doublebuffer_parallel_ii(
              A, A1, A2, A1_tile, A2_tile,
              B, B1, B2, B1_tile, B2_tile,
              C, num_workers);
          auto tt_end = std::chrono::high_resolution_clock::now();
          std::chrono::duration<double> tt_duration = tt_end - tt_start;
//        print_matrix(C, C1, C2);
          std::cout << "sum_C: " << sum_matrix(C, C1, C2) << std::endl;
          std::cout << "FAM double-buffer dim_size: " << dim_size
                    << ", buffer_size: " << tile_dim_size
                    << ", num_workers: " << num_workers
                    << ", r_i: " << r_i
                    << ", time_exe(s): " << tt_duration.count()
                    << std::endl;


          tiling_exe_times.push_back(tt_duration.count());
        }
        /// Save all exe times
//    std::string tiling_filename = std::format("output.gemm.dram.tiling.size{}.log", dim_size);  /// since C++20
        std::string tiling_filename;
        {
          std::stringstream ss;
          ss << "output.gemm.fam.parallel-double-buffer.matrix-size-" << dim_size
             << ".tile-size-" << tile_dim_size << ".num-workers-" << num_workers << ".log";
          tiling_filename = ss.str();
        }
        save_exe_times_into_file(tiling_filename, tiling_exe_times);

        /// Calculate average
        double tiling_avg_time = calculate_average_in_vector(tiling_exe_times);
        gemm_tiling_avg_times_table[tile_dim_size].push_back(tiling_avg_time);
      }  /// num_workers_list

    }  /// tile_dim_sizes

    /// Save results to a collection file

//    std::string collect_filename("output.gemm.fam.collection.buffer-sizes.seq.csv");
    std::string collect_filename;
    {
      std::stringstream ss;
      ss << "output.gemm.fam.collection.matrix-size-" << dim_size << ".buffer-sizes.num-workers.parallel-jj.csv";
      collect_filename = ss.str();
    }
    std::ofstream fout;
    fout.open(collect_filename);
    if (fout.is_open()) {
      std::string header("tile_size");
      for (uint64_t num_workers: num_workers_list) {
        header += ",#workers-" + std::to_string(num_workers);
      }
      fout << header << std::endl;
      for (uint64_t tile_dim_size: tile_dim_sizes) {
        fout << tile_dim_size;
        for (uint64_t w = 0; w < num_workers_list.size(); ++w) {
          fout << "," << gemm_tiling_avg_times_table[tile_dim_size][w];
        }
        fout << std::endl;
      }
      std::cout << "Saved to file " << collect_filename << std::endl;
    } else {
      std::cerr << "Error: cannot open file " << collect_filename << std::endl;
    }

    destroy_matrix_in_fam(fam, A);
    destroy_matrix_in_fam(fam, B);
    destroy_matrix_in_fam(fam, C);
//    destroy_matrix_in_dram(A);
//    destroy_matrix_in_dram(B);
//    destroy_matrix_in_dram(C);
  } /// dim_sizes

  auto master_tt_end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> master_tt_duration = master_tt_end - master_tt_start;
  std::cout << "TOTAL_EXE_TIME(S): " << master_tt_duration.count() << std::endl;

  return 0;

}