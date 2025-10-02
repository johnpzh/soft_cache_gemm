//
// Created by Zhen Peng on 7/3/25.
//

void GEMM_with_SoftCache(
    Matrix A, int A1, int A2,
    DoubleBuffer A_cache, int A1_tile, int A2_tile,
    Matrix B, int B1, int B2,
    DoubleBuffer B_cache, int B1_tile, int B2_tile,
    Matrix C/*out*/)
{
  for (int ii = 0; ii < A1; ii += A1_tile) {
    int A_block_rows = min(A1_tile, A1 - ii);
    for (int kk = 0; kk < A2; kk += A2_tile) {
      int A_block_cols = min(A2_tile, A2 - kk);
      int B_block_rows = A_block_cols;
      if (kk == 0) {
        copyBlock(/*src=*/A, /*dst=*/A_cache.getActive());
      }
      for (int jj = 0; jj < B2; jj += B2_tile) {
        int B_block_cols = min(B2_tile, B2 - jj);
        if (jj == 0) {
          copyBlock(/*src=*/B, /*dst=*/B_cache.getActive());
        }
        compute(A_cache.getActive(), B_cache.getActive(), C/*out*/);
        /// Prefetch B
        if (jj + B_block_cols < B2) {
          copyBlock(/*src=*/B, /*dst=*/B_cache.getInactive());
          B_cache.swap();
        }
        /// Prefetch A
        if (jj + B_block_cols >= B2 && kk + A_block_cols < A2) {
          copyBlock(/*src=*/A, /*dst=*/A_cache.getInactive());
          A_cache.swap();
        }
      }
    }
  }
}

void GEMM_with_DoubleBuffer2(
    Matrix A, int A1, int A2,
    DoubleBuffer A_cache, int A1_tile, int A2_tile,
    Matrix B, int B1, int B2,
    DoubleBuffer B_cache, int B1_tile, int B2_tile,
    Matrix C/*out*/)
{
  for (int ii = 0; ii < A1; ii += A1_tile) {
    int A_block_rows = min(A1_tile, A1 - ii);
    for (int kk = 0; kk < A2; kk += A2_tile) {
      int A_block_cols = min(A2_tile, A2 - kk);
      int B_block_rows = A_block_cols;

      {/// done by auxiliary thread
        copyBlock(/*src=*/A, /*dst=*/A_cache.inactive);
        swapBlock(A_cache);
      }

      for (int jj = 0; jj < B2; jj += B2_tile) {
        int B_block_cols = min(B2_tile, B2 - jj);

        {/// done by auxiliary thread
          copyBlock(/*src=*/B, /*dst=*/B_cache.inactive);
          swapBlock(B_cache);
        }
        compute(A_cache.active, B_cache.active, C/*out*/);
        swapBlock(B_cache);
      }
      swapBlock(A_cache);
    }
  }
}


void GEMM_with_DoubleBuffer2_main(
    Matrix A, int A1, int A2,
    DoubleBuffer A_buffer, int A1_tile, int A2_tile, std::atomic<bool> *A_buffer_is_ready=false,
    Matrix B, int B1, int B2,
    DoubleBuffer B_buffer, int B1_tile, int B2_tile, std::atomic<bool> *B_buffer_is_ready=false,
    Matrix C/*out*/)
{
  for (int ii = 0; ii < A1; ii += A1_tile) {
    int A_block_rows = min(A1_tile, A1 - ii);
    for (int kk = 0; kk < A2; kk += A2_tile) {
      int A_block_cols = min(A2_tile, A2 - kk);
      int B_block_rows = A_block_cols;
      while (!A_buffer_is_ready) {
        ; /// Spin
      }
      for (int jj = 0; jj < B2; jj += B2_tile) {
        int B_block_cols = min(B2_tile, B2 - jj);
        while (!B_buffer_is_ready) {
          ; /// Spin
        }
        compute(A_buffer.active, B_buffer.active, C/*out*/);
        B_buffer_is_ready = false;
      }
      A_buffer_is_ready = false;
    }
  }
}

void GEMM_with_DoubleBuffer2_auxiliary(
    Matrix A, int A1, int A2,
    DoubleBuffer A_buffer, int A1_tile, int A2_tile, std::atomic<bool> *A_buffer_is_ready=false,
    Matrix B, int B1, int B2,
    DoubleBuffer B_buffer, int B1_tile, int B2_tile, std::atomic<bool> *B_buffer_is_ready=false,
    Matrix C/*out*/)
{
  for (int ii = 0; ii < A1; ii += A1_tile) {
    int A_block_rows = min(A1_tile, A1 - ii);
    for (int kk = 0; kk < A2; kk += A2_tile) {
      int A_block_cols = min(A2_tile, A2 - kk);
      int B_block_rows = A_block_cols;
      copy(/*src=*/A, /*dst=*/A_buffer.inactive);
      while (A_buffer_is_ready) {
        ; /// Spin
      }
      swap(A_buffer);
      A_buffer_is_ready = true;

      for (int jj = 0; jj < B2; jj += B2_tile) {
        int B_block_cols = min(B2_tile, B2 - jj);
        copy(/*src=*/B, /*dst=*/B_buffer.inactive);
        while (B_buffer_is_ready) {
          ; /// Spin
        }
        swap(B_buffer);
        B_buffer_is_ready = true;
      }
    }
  }
}

