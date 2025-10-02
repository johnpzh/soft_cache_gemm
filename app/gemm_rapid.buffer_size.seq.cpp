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
  uint64_t num_repeats = 4;

  std::vector<uint64_t> dim_sizes;
  for (uint64_t dim_size = 4096; dim_size <= 8192; dim_size *= 2) {
//  for (uint64_t dim_size = 1024; dim_size <= 1024; dim_size *= 2) {
    dim_sizes.push_back(dim_size);
  }
//  std::vector<double> gemm_no_tiling_avg_times;
//  std::vector<double> gemm_tiling_avg_times;

  std::vector<uint64_t> tile_dim_sizes;
//  for (uint64_t tile_dim_size = 128; tile_dim_size <= 2048; tile_dim_size *= 2) {
  for (uint64_t tile_dim_size = 8; tile_dim_size <= 64; tile_dim_size *= 2) {
    tile_dim_sizes.push_back(tile_dim_size);
  }

  std::unordered_map<uint64_t, std::vector<double>> gemm_tiling_avg_times_table;
//  for (uint64_t dim_size = 512; dim_size <= 8192; dim_size *= 2) {
////  for (uint64_t dim_size = 512; dim_size <= 1024; dim_size *= 2) {
//    dim_sizes.push_back(dim_size);
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
//    std::unordered_map<uint64_t, std::vector<double>> tiling_exe_times_table;

    /// Tiling
//    uint64_t tile_dim_size = 512;
    for (uint64_t tile_dim_size: tile_dim_sizes) {
      uint64_t A1_tile = tile_dim_size;
      uint64_t A2_tile = tile_dim_size;
      uint64_t B1_tile = A2_tile;
      uint64_t B2_tile = tile_dim_size;
      DoubleBuffer A_cache(A1_tile, A2_tile);
      DoubleBuffer B_cache(B1_tile, B2_tile);

//      auto &tiling_exe_times = tiling_exe_times_table[tile_dim_size];
      std::vector<double> tiling_exe_times;
//      auto &gemm_tiling_avg_times = gemm_tiling_avg_times_table[tile_dim_size];
      for (uint64_t r_i = 0; r_i < num_repeats; ++r_i) {
        memset(C, 0, C1 * C2 * sizeof(double));

        auto tt_start = std::chrono::high_resolution_clock::now();
        /// Kernel
//        gemm_v4_softcache(A, A1, A2, A1_tile, A2_tile, A_cache,
//                          B, B1, B2, B1_tile, B2_tile, B_cache,
//                          C);
        gemm_v7_background_thread(A, A1, A2, A1_tile, A2_tile,
                                  B, B1, B2, B1_tile, B2_tile,
                                  C);
        auto tt_end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> tt_duration = tt_end - tt_start;
        std::cout << "FAM double-buffer dim_size: " << dim_size << ", buffer_size: " << tile_dim_size << ", r_i: " << r_i << ", time_exe(s): "
                  << tt_duration.count() << std::endl;

//        print_matrix(C, C1, C2);
        tiling_exe_times.push_back(tt_duration.count());

      }
      /// Save all exe times
//    std::string tiling_filename = std::format("output.gemm.dram.tiling.size{}.log", dim_size);
      std::string tiling_filename;
      {
        std::stringstream ss;
        ss << "output.gemm.fam.double-buffer.matrix-size-" << dim_size << ".tile-size-" << tile_dim_size << ".log";
        tiling_filename = ss.str();
      }
      save_exe_times_into_file(tiling_filename, tiling_exe_times);

      /// Calculate average
      double tiling_avg_time = calculate_average_in_vector(tiling_exe_times);
      gemm_tiling_avg_times_table[tile_dim_size].push_back(tiling_avg_time);
    }

    destroy_matrix_in_fam(fam, A);
    destroy_matrix_in_fam(fam, B);
    destroy_matrix_in_fam(fam, C);
  }

  /// Save results to a collection file
  std::string collect_filename("output.gemm.fam.collection.buffer-sizes.seq.csv");
  std::ofstream fout;
  fout.open(collect_filename);
  if (fout.is_open()) {
//    std::string header("Matrix_size,RAPID.No-Tiling(s),RAPID.SoftCache.Tiling(s)");
    std::string header("Matrix_size");
    for (uint64_t tile_dim_size: tile_dim_sizes) {
      header += ",RAPID.DoubleBuffer.Tile-size-" + std::to_string(tile_dim_size);
    }
    fout << header << std::endl;
    for (uint64_t row_i = 0; row_i < dim_sizes.size(); ++row_i) {
//      fout << dim_sizes[row_i] << "," << gemm_no_tiling_avg_times[row_i] << "," << gemm_tiling_avg_times[row_i] << std::endl;
      fout << dim_sizes[row_i];
      for (uint64_t tile_dim_size: tile_dim_sizes) {
        fout << "," << gemm_tiling_avg_times_table[tile_dim_size][row_i];
      }
      fout << std::endl;
    }

    std::cout << "Saved to file " << collect_filename << std::endl;
  } else {
    std::cerr << "Error: cannot open file " << collect_filename << std::endl;
  }

  auto master_tt_end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> master_tt_duration = master_tt_end - master_tt_start;
  std::cout << "TOTAL_EXE_TIME(S): " << master_tt_duration.count() << std::endl;

  return 0;
//  { /// gemm_in_dram and tiling
//    uint64_t A1 = 4;
//    uint64_t A2 = 3;
//    uint64_t A1_tile = 2;
//    uint64_t A2_tile = 2;
//    uint64_t B1 = A2;
//    uint64_t B2 = 2;
//    uint64_t B1_tile = A2_tile;
//    uint64_t B2_tile = 2;
//    uint64_t C1 = A1;
//    uint64_t C2 = B2;
//    double *A = create_matrix_in_dram(A1, A2, 1.1);
//    double *B = create_matrix_in_dram(B1, B2, 2.2);
//    double *C = create_matrix_in_dram(C1, C2);
//
//    auto tt_start = std::chrono::high_resolution_clock::now();
//    gemm_v1_tiling(A, A1, A2, A1_tile, A2_tile,
//                   B, B1, B2, B1_tile, B2_tile,
//                   C);
//    auto tt_end = std::chrono::high_resolution_clock::now();
//    auto tt_duration = std::chrono::duration_cast<std::chrono::seconds>(tt_end - tt_start);
//    std::cout << "time_exe(s): " << tt_duration.count() << std::endl;
//
//    print_matrix(C, C1, C2);
//
//    destroy_matrix_in_dram(A);
//    destroy_matrix_in_dram(B);
//    destroy_matrix_in_dram(C);
//  }

}
