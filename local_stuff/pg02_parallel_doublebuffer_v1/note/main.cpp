void compute_worker(uint64_t A1,
                    uint64_t A2,
                    uint64_t B1,
                    uint64_t B2,
                    double **A_buffer1,
                    uint64_t A1_tile,
                    uint64_t A2_tile,
                    std::atomic<uint64_t> *A_in_use,
                    double **B_buffer1,
                    uint64_t B1_tile,
                    uint64_t B2_tile,
                    std::atomic<bool> *B_buffer_is_ready,
                    double *C,
                    uint64_t j_start,
                    uint64_t num_local_j_tiles,
                    uint64_t worker_id)
{
  for (uint64_t ii = 0; ii < A1; ii += A1_tile) {
    uint64_t A_block_rows = std::min(A1_tile, A1 - ii);
    for (uint64_t kk = 0; kk < A2; kk += A2_tile) {
      uint64_t A_block_cols = std::min(A2_tile, A2 - kk);
      uint64_t B_block_rows = A_block_cols;
      while (A_in_use == 0) {
        ;  // Spin until A loaded
      }

      compute();

      --A_in_use
      ++A_in_wait;
      while (A_in_use > 0 ) {  /// a rendezvous barrier
        ; /// Spin until all workers finished
      }
      --A_in_wait;
    }
  }
}