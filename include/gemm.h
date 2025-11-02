//
// Created by Zhen Peng on 5/28/25.
//

#ifndef TILING_GEMM_GEMM_H
#define TILING_GEMM_GEMM_H

#include <vector>
#include <fstream>
#include "soft_cache.h"
//#include <omp.h>
#include "rapid.h"

//--------
// Matrix
//--------

double *create_matrix_in_dram(uint64_t num_rows, uint64_t num_cols, double val=0);
void destroy_matrix_in_dram(double *matrix);
double *create_matrix_in_fam(rapid_handle fam, uint64_t num_rows, uint64_t num_cols, double val=0);
void destroy_matrix_in_fam(rapid_handle fam, double *matrix);
void print_matrix(double *matrix, uint64_t num_rows, uint64_t num_cols);
double sum_matrix(double *matrix, uint64_t num_rows, uint64_t num_cols);

//--------------
// GEMM Kernels
//--------------

void gemm_v0(double *A, uint64_t A1, uint64_t A2,
             double *B, uint64_t B1, uint64_t B2,
             double *C);
void gemm_v1_tiling(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                    double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                    double *C);
void gemm_v2_tiling_disorder(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                             double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                             double *C);
void gemm_v3_tiling_disorder(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                             double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                             double *C);

void gemm_v4_softcache(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile, DoubleBuffer &A_cache,
                       double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile, DoubleBuffer &B_cache,
                       double *C);

void gemm_v6_softcache_omp(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                       double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                       double *C);

/// Do swap on the auxiliary side
void gemm_v7_background_thread(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                               double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                               double *C);

/// Do swap on the main side
void gemm_v8_background_thread(double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
                               double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
                               double *C);

void gemm_v9_doublebuffer_parallel_jj(
    double *A, uint64_t A1, uint64_t A2, uint64_t A1_tile, uint64_t A2_tile,
    double *B, uint64_t B1, uint64_t B2, uint64_t B1_tile, uint64_t B2_tile,
    double *C,
    uint64_t num_workers);

//-----------
// Utilities
//-----------

template<class T>
double calculate_average_in_vector(std::vector<T> exe_times)
{
  if (exe_times.empty()) {
    return 0;
  }

  T avg_time = 0;
  for (auto time : exe_times) {
    avg_time += time;
  }
  avg_time /= exe_times.size();

  return avg_time;
}

template<class T>
void save_exe_times_into_file(std::string filename, std::vector<T> exe_times)
{
  std::ofstream fout;
  fout.open(filename);
  if (fout.is_open()) {
    for (auto time : exe_times) {
      fout << time << "\n";
    }
  } else {
    std::cerr << "Error: cannot create file " << filename << "\n";
  }
}

#endif //TILING_GEMM_GEMM_H
