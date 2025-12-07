# parallel_compute_workers.rapid.matrix-{}.tile-{}.compute-{}.mlir

source_file="dialect/parallel_compute_workers.mlir"
rm -v dialect/parallel_compute_workers.rapid.matrix-*

matrix_size_list=(4096 8192 16384)
tile_size_list=(8 16 32 64 128 256 512 1024 2048)
compute_worker_list=(1 2 4 8 16 27 32 54 64 110)

for matrix_size in "${matrix_size_list[@]}"; do
  for tile_size in "${tile_size_list[@]}"; do
    for compute_workers in "${compute_worker_list[@]}"; do
      output_file="dialect/parallel_compute_workers.rapid.matrix-${matrix_size}.tile-${tile_size}.compute-${compute_workers}.mlir"
      sed "s/%A1 = arith.constant 5/%A1 = arith.constant ${matrix_size}/g; \
          s/%A2 = arith.constant 5/%A2 = arith.constant ${matrix_size}/g; \
          s/%B1 = arith.constant 5/%B1 = arith.constant ${matrix_size}/g; \
          s/%B2 = arith.constant 5/%B2 = arith.constant ${matrix_size}/g; \
          s/%C1 = arith.constant 5/%C1 = arith.constant ${matrix_size}/g; \
          s/%C2 = arith.constant 5/%C2 = arith.constant ${matrix_size}/g; \
          s/5x5xf64/${matrix_size}x${matrix_size}xf64/g; \
          s/%A1_tile = arith.constant 2/%A1_tile = arith.constant ${tile_size}/g; \
          s/%A2_tile = arith.constant 2/%A2_tile = arith.constant ${tile_size}/g; \
          s/%B1_tile = arith.constant 2/%B1_tile = arith.constant ${tile_size}/g; \
          s/%B2_tile = arith.constant 2/%B2_tile = arith.constant ${tile_size}/g; \
          s/%num_compute_workers = arith.constant 4/%num_compute_workers = arith.constant ${compute_workers}/g;" \
          "${source_file}" \
          > "${output_file}"
      echo "Saved scf code to ${output_file}"
    done
  done
done