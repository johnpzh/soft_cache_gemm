//
// Created by Zhen Peng on 7/2/25.
//

#include <algorithm>
#include <assert.h>
#include <stdio.h>
#include "soft_cache.h"

void copyBlock(const double *src, uint64_t rows, uint64_t cols, uint64_t row_offset, uint64_t col_offset,
               CacheBlock &cache, uint64_t block_rows, uint64_t block_cols)
{
//  assert(row_offset + block_rows <= rows && "Error: the block rows is beyond the src rows.");
//  assert(col_offset + block_cols <= cols && "Error: the block cols is beyond the src cols.");

  /// Unset cache
  std::lock_guard<std::mutex> lock(cache.mutex_);
  cache.resize(block_rows * block_cols);

  /// Copy
//  uint64_t src_base = row_offset * cols + col_offset;
//  uint64_t src_curr = src_base;
//  uint64_t cache_curr = 0;
//  for (uint64_t i = 0; i < block_rows; ++i) {
//    std::copy(src + src_curr, src + src_curr + block_cols,
//              cache.data_.begin() + cache_curr);
//    src_curr += cols;
//    cache_curr += block_cols;
//  }
  for (uint64_t i = 0; i < block_rows; ++i) {
    uint64_t src_i = row_offset + i;
    for (uint64_t j = 0; j < block_cols; ++j) {
      uint64_t src_j = col_offset + j;
      if (src_i < rows && src_j < cols) {
        cache[i * block_cols + j] = src[src_i * cols + src_j];
      } else {
        /// Padding zeros
        cache[i * block_cols + j] = 0.0;
      }
    }
  }

  /// Set cache ready
  cache.setReady();
  cache.cv_.notify_all();
}

void computeBlock(CacheBlock &A_cache, uint64_t A1_tile, uint64_t A2_tile,
                  CacheBlock &B_cache, uint64_t B1_tile, uint64_t B2_tile,
                  double *C, uint64_t C1, uint64_t C2, uint64_t C1_offset, uint64_t C2_offset)
{
  /// Wait for caches to be ready
  {
    std::unique_lock<std::mutex> lock(A_cache.mutex_);
    A_cache.cv_.wait(lock, [&A_cache] {
      return A_cache.is_ready_;
    });
  }
  {
    std::unique_lock<std::mutex> lock(B_cache.mutex_);
    B_cache.cv_.wait(lock, [&B_cache] {
      return B_cache.is_ready_;
    });
  }

  /// Compute
//  for (uint64_t i = 0; i < A1_tile; ++i) {
//    for (uint64_t k = 0; k < A2_tile; ++k) {
//      for (uint64_t j = 0; j < B2_tile; ++j) {
//        C[(C1_offset + i) * C2 + (C2_offset + j)] += A_cache[i * A2_tile + k] * B_cache[k * B2_tile + j];
//      }
//    }
//  }
  for (uint64_t i = 0; i < A1_tile; ++i) {
    uint64_t c_i = C1_offset + i;
    for (uint64_t k = 0; k < A2_tile; ++k) {
      for (uint64_t j = 0; j < B2_tile; ++j) {
        uint64_t c_j = C2_offset + j;
        if (c_i < C1 && c_j < C2) {
          C[c_i * C2 + c_j] += A_cache[i * A2_tile + k] * B_cache[k * B2_tile + j];
        }
      }
    }
  }
}

void CacheBlock::print(uint64_t rows, uint64_t cols) const
{
  printf("data_[%llu]: \n", size_);
  for (uint64_t i = 0; i < rows; ++i) {
    for (uint64_t j = 0; j < cols; ++j) {
      printf("%lf, ", data_[i * cols + j]);
    }
    printf("\n");
  }
}