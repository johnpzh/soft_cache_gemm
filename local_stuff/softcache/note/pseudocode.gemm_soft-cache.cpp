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