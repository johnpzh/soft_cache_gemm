struct CacheBlock {
  std::vector<double> data_;
  uint64_t size_ = 0;
  bool is_ready_ = false;
  std::mutex mutex_;
  std::condition_variable cv_;
};

struct DoubleBuffer {
  CacheBlock buffer_[2];
  uint64_t active_buffer_ = 0;
};

void copyBlock(const double *src, uint64_t rows, uint64_t cols, uint64_t row_offset, uint64_t col_offset,
               CacheBlock &cache, uint64_t block_rows, uint64_t block_cols)
{
  /// Unset cache
  std::lock_guard<std::mutex> lock(cache.mutex_);
  cache.resize(block_rows * block_cols);

  /// Copy
  copy(src, cache);

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
  compute(A_cache, B_cache, C);
}