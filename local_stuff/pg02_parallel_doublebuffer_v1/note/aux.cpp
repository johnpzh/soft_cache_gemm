void background_A_process(double *A,
                          uint64_t A1,
                          uint64_t A2,
                          double **A_buffer1,
                          double **A_buffer2,
                          uint64_t A1_tile,
                          uint64_t A2_tile,
                          std::atomic<uint64_t> *A_in_use,
                          uint64_t num_workers)
{
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      copy_to_buffer(A,
                     A1, A2,
                     /*A1_offset=*/ii, /*A2_offset=*/kk,
                     *A_buffer2,
                     A1_tile, A2_tile,
                     A_block_rows, A_block_cols);
      while (A_in_use > 0 || A_in_wait > 0) {
        ;  // Spin until all workers done with previous A

      }
      swap_buffer(A_buffer1, A_buffer2);
      A_is_use = num_workers;
    }
  }
}