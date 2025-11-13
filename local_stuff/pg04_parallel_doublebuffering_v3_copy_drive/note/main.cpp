//
// Created by Zhen Peng on 11/5/25.
//
int is_not_finished;
int worker_id;
int B_buffer_is_ready;
int *B_buffer_readys;

void compute_worker()
{
  while (is_not_finished) {
    for (worker_id = 0 to num_workers) {
      B_buffer_is_ready = B_buffer_readys[worker_id];
      if (B_buffer_is_ready) {
        /// Fisrt, Fetch the sizes and locations
        /// Secon, do compute
        do_gemm_on_buffer(A_buffer1
                          /* ... */);
        B_buffer_is_ready->store(false, std::memory_order_release);
      }
    }
  }
}