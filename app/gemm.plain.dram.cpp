//
// Created by Zhen Peng on 10/21/25.
//

#include <iostream>
#include <fstream>
#include <sstream>
#include <chrono>
//#include <format>
#include <stdio.h>
#include <unordered_map>
#include "gemm.h"
//#include "rapid.h"

int main()
{
  auto master_tt_start = std::chrono::high_resolution_clock::now();
//  rapid_handle fam = rapid_initialize();
  uint64_t num_repeats = 4;

  std::vector<uint64_t> dim_sizes;
  std::vector<double> gemm_no_tiling_avg_times;

  for (uint64_t dim_size = 4096; dim_size <= 8192; dim_size *= 2) {
//  for (uint64_t dim_size = 256; dim_size <= 512; dim_size *= 2) {
    dim_sizes.push_back(dim_size);
  }

  for (uint64_t dim_size : dim_sizes) {
    uint64_t A1 = dim_size;
    uint64_t A2 = dim_size;
    uint64_t B1 = A2;
    uint64_t B2 = dim_size;
    uint64_t C1 = A1;
    uint64_t C2 = B2;
    double *A = create_matrix_in_dram(A1, A2, 1.1);
    double *B = create_matrix_in_dram(B1, B2, 2.2);
    double *C = create_matrix_in_dram(C1, C2);


    std::vector<double> no_tiling_exe_times;

    /// No Tiling
    for (uint64_t r_i = 0; r_i < num_repeats; ++r_i) {

      auto tt_start = std::chrono::high_resolution_clock::now();
      /// Kernel
      gemm_v0(A, A1, A2,
              B, B1, B2,
              C);
      auto tt_end = std::chrono::high_resolution_clock::now();
      std::chrono::duration<double> tt_duration = tt_end - tt_start;
      std::cout << "DRAM plain dim_size: " << dim_size << ", r_i: " << r_i << ", time_exe(s): " << tt_duration.count() << "\n";

//        print_matrix(C, C1, C2);
      no_tiling_exe_times.push_back(tt_duration.count());
    }
    /// Save all exe times
//    std::string no_tiling_filename = std::format("output.gemm.dram.no-tiling.size{}.log", dim_size);
    std::string no_tiling_filename;
    {
      std::stringstream ss;
      ss << "output.gemm.dram.plain.size" << dim_size << ".log";
      no_tiling_filename = ss.str();
    }
    save_exe_times_into_file(no_tiling_filename, no_tiling_exe_times);
    /// Calculate average
    double no_tiling_avg_time = calculate_average_in_vector(no_tiling_exe_times);
    gemm_no_tiling_avg_times.push_back(no_tiling_avg_time);

    destroy_matrix_in_dram(A);
    destroy_matrix_in_dram(B);
    destroy_matrix_in_dram(C);
  }

  /// Save results to a collection file
  std::string collect_filename("output.gemm.dram.plain.collection.csv");
  std::ofstream fout;
  fout.open(collect_filename);
  if (fout.is_open()) {
    std::string header("Matrix_size,DRAM.Plain(s)");
    fout << header << "\n";
    for (uint64_t row_i = 0; row_i < dim_sizes.size(); ++row_i) {
      fout << dim_sizes[row_i] << "," << gemm_no_tiling_avg_times[row_i];
      fout << "\n";
    }

    std::cout << "Saved to file " << collect_filename << "\n";
  } else {
    std::cerr << "Error: cannot open file " << collect_filename << "\n";
  }

  auto master_tt_end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> master_tt_duration = master_tt_end - master_tt_start;
  std::cout << "TOTAL_EXE_TIME(S): " << master_tt_duration.count() << "\n";

  return 0;

}
