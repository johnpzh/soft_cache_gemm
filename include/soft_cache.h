//
// Created by Zhen Peng on 7/2/25.
//

#ifndef SOFTCACHE_DEMO_SOFTCACHE_H
#define SOFTCACHE_DEMO_SOFTCACHE_H

#include <stdlib.h>
#include <mutex>
#include <condition_variable>
#include <vector>
#include <atomic>

struct CacheBlock {
  std::vector<double> data_;
  uint64_t size_ = 0;
  bool is_ready_ = false;
  std::mutex mutex_;
  std::condition_variable cv_;

  CacheBlock() = default;

  CacheBlock(uint64_t rows, uint64_t cols)
  {
    resize(rows * cols);
  }

  void resize(uint64_t size)
  {
    if (size > data_.size()) {
      data_.resize(size);
    }
    is_ready_ = false;
    size_ = size;
  }

  void setReady()
  {
    is_ready_ = true;
  }

  void unset()
  {
    is_ready_ = false;
  }

  double &operator[](uint64_t index)
  {
    return data_[index];
  }

  const double &operator[](uint64_t index) const
  {
    return data_[index];
  }

  void print(uint64_t rows, uint64_t cols) const;
};

struct DoubleBuffer {
  CacheBlock buffer_[2];
  uint64_t active_buffer_ = 0;

  DoubleBuffer() = default;

  DoubleBuffer(uint64_t rows, uint64_t cols)
  {
    buffer_[0].resize(rows * cols);
    buffer_[1].resize(rows * cols);
  }

  CacheBlock &getActive()
  {
    return buffer_[active_buffer_];
  }

  CacheBlock &getInactive()
  {
    return buffer_[1 - active_buffer_];
  }

  void swap()
  {
    active_buffer_ = 1 - active_buffer_;
  }
};

void copyBlock(const double *src, uint64_t rows, uint64_t cols, uint64_t row_offset, uint64_t col_offset,
               CacheBlock &cache, uint64_t block_rows, uint64_t block_cols);

void computeBlock(CacheBlock &A_cache, uint64_t A1, uint64_t A2,
                  CacheBlock &B_cache, uint64_t B1, uint64_t B2,
                  double *C, uint64_t C1, uint64_t C2, uint64_t C1_offset, uint64_t C2_offset);


/*
 * A simpler version for library use in the future.
 */
struct DoubleBufferV2 {
  double *buffer_[2];
  uint32_t active_buffer_ = 0;
  std::atomic<bool> *is_ready_;
  uint64_t num_rows_ = 0;
  uint64_t num_cols_ = 0;
  uint64_t size_ = 0;

  DoubleBufferV2() = default;

  DoubleBufferV2(double *buffer1,
                double *buffer2,
                std::atomic<bool> *is_ready,
                uint64_t num_rows,
                uint64_t num_cols) : is_ready_(is_ready), num_rows_(num_rows), num_cols_(num_cols)
  {
    buffer_[0] = buffer1;
    buffer_[1] = buffer2;
    size_ = num_rows * num_cols;
  }

  double *getActive()
  {
    return buffer_[active_buffer_];
  }

  double *getInactive()
  {
    return buffer_[1 - active_buffer_];
  }

  void swap()
  {
    active_buffer_ = 1 - active_buffer_;
  }
};


#endif //SOFTCACHE_DEMO_SOFTCACHE_H
