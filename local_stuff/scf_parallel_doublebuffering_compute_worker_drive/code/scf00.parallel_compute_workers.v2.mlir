module {
func.func @pp_index(%val: index) {
  %val_cast = arith.index_cast %val : index to i64
  func.call @printI64(%val_cast) : (i64) -> ()
  func.call @printComma() : () -> ()

  return
}

func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cst0 = arith.constant 0.0 : f64
  %cst1 = arith.constant 1.1 : f64
  %cst2 = arith.constant 2.2 : f64
  %char0 = arith.constant 0 : i8
  %char1 = arith.constant 1 : i8

  %A1 = arith.constant 5 : index
  %A2 = arith.constant 5 : index
  %B1 = arith.constant 5 : index
  %B2 = arith.constant 5 : index
  %C1 = arith.constant 5 : index
  %C2 = arith.constant 5 : index
  %A_size = arith.muli %A1, %A2 : index
  %B_size = arith.muli %B1, %B2 : index
  %C_size = arith.muli %C1, %C2 : index
  %A1_tile = arith.constant 2 : index
  %A2_tile = arith.constant 2 : index
  %B1_tile = arith.constant 2 : index
  %B2_tile = arith.constant 2 : index
  %A_tile_size = arith.muli %A1_tile, %A2_tile : index
  %B_tile_size = arith.muli %B1_tile, %B2_tile : index

  // %A_matrix = memref.alloc() {allocator = "rapid"} : memref<5x5xf64>
  // %B_matrix = memref.alloc() {allocator = "rapid"} : memref<5x5xf64>
  // %C_matrix = memref.alloc() {allocator = "rapid"} : memref<5x5xf64>
  %A_matrix = memref.alloc() : memref<5x5xf64>
  %B_matrix = memref.alloc() : memref<5x5xf64>
  %C_matrix = memref.alloc() : memref<5x5xf64>
  scf.for %i = %c0 to %A1 step %c1 {
    scf.for %j = %c0 to %A2 step %c1 {
      memref.store %cst1, %A_matrix[%i, %j] : memref<5x5xf64>
    }
  }
  scf.for %i = %c0 to %B1 step %c1 {
    scf.for %j = %c0 to %B2 step %c1 {
      memref.store %cst2, %B_matrix[%i, %j] : memref<5x5xf64>
    }
  }
  scf.for %i = %c0 to %C1 step %c1 {
    scf.for %j = %c0 to %C2 step %c1 {
      memref.store %cst0, %C_matrix[%i, %j] : memref<5x5xf64>
    }
  }

  %num_compute_workers = arith.constant 1 : index
  %num_aux_workers = arith.constant 1 : index

  %A_cast = memref.cast %A_matrix : memref<5x5xf64> to memref<*xf64>
  %B_cast = memref.cast %B_matrix : memref<5x5xf64> to memref<*xf64>
  %C_cast = memref.cast %C_matrix : memref<5x5xf64> to memref<*xf64>


  %0 = call @getTime() : () -> f64

  /// --------
  /// Buffers
  /// --------
  /// A_buffer1s
  %A_buffer1s = memref.alloc(%num_compute_workers) : memref<?xmemref<*xmemref<*xf64>>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %buffer_m = memref.alloc(%A_tile_size) : memref<?xf64>
    %buffer_m_cast = memref.cast %buffer_m : memref<?xf64> to memref<*xf64>
    %buffer_mm = memref.alloc() : memref<1xmemref<*xf64>>
    memref.store %buffer_m_cast, %buffer_mm[%c0] : memref<1xmemref<*xf64>>
    %buffer_mm_cast = memref.cast %buffer_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
    memref.store %buffer_mm_cast, %A_buffer1s[%i] : memref<?xmemref<*xmemref<*xf64>>>
  }
  /// A_buffer2s
  %A_buffer2s = memref.alloc(%num_compute_workers) : memref<?xmemref<*xmemref<*xf64>>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %buffer_m = memref.alloc(%A_tile_size) : memref<?xf64>
    %buffer_m_cast = memref.cast %buffer_m : memref<?xf64> to memref<*xf64>
    %buffer_mm = memref.alloc() : memref<1xmemref<*xf64>>
    memref.store %buffer_m_cast, %buffer_mm[%c0] : memref<1xmemref<*xf64>>
    %buffer_mm_cast = memref.cast %buffer_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
    memref.store %buffer_mm_cast, %A_buffer2s[%i] : memref<?xmemref<*xmemref<*xf64>>>
  }
  /// A_buffer_readys
  %A_buffer_readys = memref.alloc(%num_compute_workers) : memref<?xmemref<*xi8>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %is_ready = memref.alloc() : memref<1xi8>
    %is_ready_cast = memref.cast %is_ready : memref<1xi8> to memref<*xi8>
    memref.store %char1, %is_ready[%c0] : memref<1xi8>
    memref.store %is_ready_cast, %A_buffer_readys[%i] : memref<?xmemref<*xi8>>
  }
  /// A1_offset_list
  %A1_offset_list = memref.alloc(%num_compute_workers) : memref<?xmemref<*xindex>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %offset = memref.alloc() : memref<1xindex>
    %offset_cast = memref.cast %offset : memref<1xindex> to memref<*xindex>
    memref.store %offset_cast, %A1_offset_list[%i] : memref<?xmemref<*xindex>>
  }
  /// A2_offset_list
  %A2_offset_list = memref.alloc(%num_compute_workers) : memref<?xmemref<*xindex>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %offset = memref.alloc() : memref<1xindex>
    %offset_cast = memref.cast %offset : memref<1xindex> to memref<*xindex>
    memref.store %offset_cast, %A2_offset_list[%i] : memref<?xmemref<*xindex>>
  }
  /// A_block_rows_list
  %A_block_rows_list = memref.alloc(%num_compute_workers) : memref<?xmemref<*xindex>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %val = memref.alloc() : memref<1xindex>
    %val_cast = memref.cast %val : memref<1xindex> to memref<*xindex>
    memref.store %val_cast, %A_block_rows_list[%i] : memref<?xmemref<*xindex>>
  }
  /// A_block_cols_list
  %A_block_cols_list = memref.alloc(%num_compute_workers) : memref<?xmemref<*xindex>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %val = memref.alloc() : memref<1xindex>
    %val_cast = memref.cast %val : memref<1xindex> to memref<*xindex>
    memref.store %val_cast, %A_block_cols_list[%i] : memref<?xmemref<*xindex>>
  }

  /// B_buffer1s
  %B_buffer1s = memref.alloc(%num_compute_workers) : memref<?xmemref<*xmemref<*xf64>>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %buffer_m = memref.alloc(%B_tile_size) : memref<?xf64>
    %buffer_m_cast = memref.cast %buffer_m : memref<?xf64> to memref<*xf64>
    %buffer_mm = memref.alloc() : memref<1xmemref<*xf64>>
    memref.store %buffer_m_cast, %buffer_mm[%c0] : memref<1xmemref<*xf64>>
    %buffer_mm_cast = memref.cast %buffer_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
    memref.store %buffer_mm_cast, %B_buffer1s[%i] : memref<?xmemref<*xmemref<*xf64>>>
  }
  /// B_buffer2s
  %B_buffer2s = memref.alloc(%num_compute_workers) : memref<?xmemref<*xmemref<*xf64>>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %buffer_m = memref.alloc(%B_tile_size) : memref<?xf64>
    %buffer_m_cast = memref.cast %buffer_m : memref<?xf64> to memref<*xf64>
    %buffer_mm = memref.alloc() : memref<1xmemref<*xf64>>
    memref.store %buffer_m_cast, %buffer_mm[%c0] : memref<1xmemref<*xf64>>
    %buffer_mm_cast = memref.cast %buffer_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
    memref.store %buffer_mm_cast, %B_buffer2s[%i] : memref<?xmemref<*xmemref<*xf64>>>
  }
  /// B_buffer_readys
  %B_buffer_readys = memref.alloc(%num_compute_workers) : memref<?xmemref<*xi8>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %is_ready = memref.alloc() : memref<1xi8>
    %is_ready_cast = memref.cast %is_ready : memref<1xi8> to memref<*xi8>
    memref.store %char1, %is_ready[%c0] : memref<1xi8>
    memref.store %is_ready_cast, %B_buffer_readys[%i] : memref<?xmemref<*xi8>>
  }
  /// B1_offset_list
  %B1_offset_list = memref.alloc(%num_compute_workers) : memref<?xmemref<*xindex>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %offset = memref.alloc() : memref<1xindex>
    %offset_cast = memref.cast %offset : memref<1xindex> to memref<*xindex>
    memref.store %offset_cast, %B1_offset_list[%i] : memref<?xmemref<*xindex>>
  }
  /// B2_offset_list
  %B2_offset_list = memref.alloc(%num_compute_workers) : memref<?xmemref<*xindex>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %offset = memref.alloc() : memref<1xindex>
    %offset_cast = memref.cast %offset : memref<1xindex> to memref<*xindex>
    memref.store %offset_cast, %B2_offset_list[%i] : memref<?xmemref<*xindex>>
  }
  /// B_block_rows_list
  %B_block_rows_list = memref.alloc(%num_compute_workers) : memref<?xmemref<*xindex>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %val = memref.alloc() : memref<1xindex>
    %val_cast = memref.cast %val : memref<1xindex> to memref<*xindex>
    memref.store %val_cast, %B_block_rows_list[%i] : memref<?xmemref<*xindex>>
  }
  /// B_block_cols_list
  %B_block_cols_list = memref.alloc(%num_compute_workers) : memref<?xmemref<*xindex>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %val = memref.alloc() : memref<1xindex>
    %val_cast = memref.cast %val : memref<1xindex> to memref<*xindex>
    memref.store %val_cast, %B_block_cols_list[%i] : memref<?xmemref<*xindex>>
  }

  /// -----------------------
  /// Compute workders flags
  /// -----------------------
  %compute_workers_finished = memref.alloc(%num_compute_workers) : memref<?xmemref<*xi8>>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %is_finished = memref.alloc() : memref<1xi8>
    %is_finished_cast = memref.cast %is_finished : memref<1xi8> to memref<*xi8>
    memref.store %char0, %is_finished[%c0] : memref<1xi8>
    memref.store %is_finished_cast, %compute_workers_finished[%i] : memref<?xmemref<*xi8>>
  }

  /// ---------------------
  /// Aux workers boundary
  /// ---------------------
  %compute_per_aux_base = arith.divui %num_compute_workers, %num_aux_workers : index
  %compute_per_aux_remainder = arith.remui %num_compute_workers, %num_aux_workers : index
  %compute_per_aux_list = memref.alloc(%num_aux_workers) : memref<?xindex>
  scf.for %i = %c0 to %num_aux_workers step %c1 {
    %is_remainder = arith.cmpi ult, %i, %compute_per_aux_remainder : index
    %plus = scf.if %is_remainder -> index {
      scf.yield %c1 : index
    } else {
      scf.yield %c0 : index
    }
    %compute_per_aux = arith.addi %compute_per_aux_base, %plus : index
    memref.store %compute_per_aux, %compute_per_aux_list[%i] : memref<?xindex>
  }

  /// -------------------------
  /// Compute workers boundary
  /// -------------------------
  %A1_tile_sub_one = arith.subi %A1_tile, %c1 : index
  %A1_ceiling = arith.addi %A1, %A1_tile_sub_one : index
  %num_i_tiles = arith.divui %A1_ceiling, %A1_tile : index /// num_i_tiles = (A1 + A1_tile - 1) / A1_tile
  %tiles_per_worker_base = arith.divui %num_i_tiles, %num_compute_workers : index
  %tiles_per_worker_remainder = arith.remui %num_i_tiles, %num_compute_workers : index
  %tiles_per_worker_list = memref.alloc(%num_compute_workers) : memref<?xindex>
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %is_remainder = arith.cmpi ult, %i, %tiles_per_worker_remainder : index
    %plus = scf.if %is_remainder -> index {
      scf.yield %c1 : index
    } else {
      scf.yield %c0 : index
    }
    %tiles_per_worker = arith.addi %tiles_per_worker_base, %plus : index
    memref.store %tiles_per_worker, %tiles_per_worker_list[%i] : memref<?xindex>
  }

  /// -----------------------
  /// Launch compute workers
  /// -----------------------
  // %compute_group = async.create_group %num_compute_workers : !async.group

  scf.for %w = %c0 to %num_compute_workers step %c1 iter_args(%i_start = %c0) -> (index) {
    %A_buffer1_ptr_cast = memref.load %A_buffer1s[%w] : memref<?xmemref<*xmemref<*xf64>>>
    %B_buffer1_ptr_cast = memref.load %B_buffer1s[%w] : memref<?xmemref<*xmemref<*xf64>>>
    %A_buffer_is_ready_cast = memref.load %A_buffer_readys[%w] : memref<?xmemref<*xi8>>
    %B_buffer_is_ready_cast = memref.load %B_buffer_readys[%w] : memref<?xmemref<*xi8>>
    %num_local_i_tiles = memref.load %tiles_per_worker_list[%w] : memref<?xindex>
    %A1_offset_ptr = memref.load %A1_offset_list[%w] : memref<?xmemref<*xindex>>
    %A2_offset_ptr = memref.load %A2_offset_list[%w] : memref<?xmemref<*xindex>>
    %A_block_rows_ptr = memref.load %A_block_rows_list[%w] : memref<?xmemref<*xindex>>
    %A_block_cols_ptr = memref.load %A_block_cols_list[%w] : memref<?xmemref<*xindex>>
    %B1_offset_ptr = memref.load %B1_offset_list[%w] : memref<?xmemref<*xindex>>
    %B2_offset_ptr = memref.load %B2_offset_list[%w] : memref<?xmemref<*xindex>>
    %B_block_rows_ptr = memref.load %B_block_rows_list[%w] : memref<?xmemref<*xindex>>
    %B_block_cols_ptr = memref.load %B_block_cols_list[%w] : memref<?xmemref<*xindex>>
    %is_finished_ptr = memref.load %compute_workers_finished[%w] : memref<?xmemref<*xi8>>

    /// Call compute worker function asynchronously
    // %token = async.execute {
      func.call @comet_double_buffer_compute_worker_drive(
        %A1,                     /// uint64_t A1
        %A2,                     /// uint64_t A2
        %A1_tile,                /// uint64_t A1_tile
        %A2_tile,                /// uint64_t A2_tile
        %A1_offset_ptr,          /// uint64_t *A1_offset_ptr
        %A2_offset_ptr,          /// uint64_t *A2_offset_ptr
        %A_block_rows_ptr,       /// uint64_t *A_block_rows_ptr
        %A_block_cols_ptr,       /// uint64_t *A_block_cols_ptr
        %A_buffer1_ptr_cast,     /// double **A_buffer1
        %A_buffer_is_ready_cast, /// int8_t *A_buffer_is_ready
        %B1,                     /// uint64_t B1
        %B2,                     /// uint64_t B2
        %B1_tile,                /// uint64_t B1_tile
        %B2_tile,                /// uint64_t B2_tile
        %B1_offset_ptr,          /// uint64_t *B1_offset_ptr
        %B2_offset_ptr,          /// uint64_t *B2_offset_ptr
        %B_block_rows_ptr,       /// uint64_t *B_block_rows_ptr
        %B_block_cols_ptr,       /// uint64_t *B_block_cols_ptr
        %B_buffer1_ptr_cast,     /// double **B_buffer1
        %B_buffer_is_ready_cast, /// int8_t *B_buffer_is_ready
        %C_cast,                 /// double *C
        %i_start,                /// uint64_t i_start
        %num_local_i_tiles,      /// uint64_t num_local_i_tiles
        %is_finished_ptr         /// int8_t *is_finished
      ) : (
        index,
        index,
        index,
        index,
        memref<*xindex>,
        memref<*xindex>,
        memref<*xindex>,
        memref<*xindex>,
        memref<*xmemref<*xf64>>,
        memref<*xi8>,
        index,
        index,
        index,
        index,
        memref<*xindex>,
        memref<*xindex>,
        memref<*xindex>,
        memref<*xindex>,
        memref<*xmemref<*xf64>>,
        memref<*xi8>,
        memref<*xf64>,
        index,
        index,
        memref<*xi8>
      ) -> ()
    //   async.yield
    // }
    // async.add_to_group %token, %compute_group : !async.token

    /// Update i_start
    %forward = arith.muli %num_local_i_tiles, %A1_tile : index
    %i_next = arith.addi %i_start, %forward : index
    scf.yield %i_next : index
  }

  /// -------------------------
  /// Launch auxiliary workers
  /// -------------------------
  %A_buffer1s_cast = memref.cast %A_buffer1s : memref<?xmemref<*xmemref<*xf64>>> to memref<*xmemref<*xmemref<*xf64>>>
  %A_buffer2s_cast = memref.cast %A_buffer2s : memref<?xmemref<*xmemref<*xf64>>> to memref<*xmemref<*xmemref<*xf64>>>
  %B_buffer1s_cast = memref.cast %B_buffer1s : memref<?xmemref<*xmemref<*xf64>>> to memref<*xmemref<*xmemref<*xf64>>>
  %B_buffer2s_cast = memref.cast %B_buffer2s : memref<?xmemref<*xmemref<*xf64>>> to memref<*xmemref<*xmemref<*xf64>>>
  %A_buffer_readys_cast = memref.cast %A_buffer_readys : memref<?xmemref<*xi8>> to memref<*xmemref<*xi8>>
  %B_buffer_readys_cast = memref.cast %B_buffer_readys : memref<?xmemref<*xi8>> to memref<*xmemref<*xi8>>
  %tiles_per_worker_list_cast = memref.cast %tiles_per_worker_list : memref<?xindex> to memref<*xindex>
  %A1_offset_list_cast = memref.cast %A1_offset_list : memref<?xmemref<*xindex>> to memref<*xmemref<*xindex>>
  %A2_offset_list_cast = memref.cast %A2_offset_list : memref<?xmemref<*xindex>> to memref<*xmemref<*xindex>>
  %A_block_rows_list_cast = memref.cast %A_block_rows_list : memref<?xmemref<*xindex>> to memref<*xmemref<*xindex>>
  %A_block_cols_list_cast = memref.cast %A_block_cols_list : memref<?xmemref<*xindex>> to memref<*xmemref<*xindex>>
  %B1_offset_list_cast = memref.cast %B1_offset_list : memref<?xmemref<*xindex>> to memref<*xmemref<*xindex>>
  %B2_offset_list_cast = memref.cast %B2_offset_list : memref<?xmemref<*xindex>> to memref<*xmemref<*xindex>>
  %B_block_rows_list_cast = memref.cast %B_block_rows_list : memref<?xmemref<*xindex>> to memref<*xmemref<*xindex>>
  %B_block_cols_list_cast = memref.cast %B_block_cols_list : memref<?xmemref<*xindex>> to memref<*xmemref<*xindex>>
  %compute_workers_finished_cast = memref.cast %compute_workers_finished : memref<?xmemref<*xi8>> to memref<*xmemref<*xi8>>

  // %aux_group = async.create_group %num_aux_workers : !async.group
  scf.for %w = %c0 to %num_aux_workers step %c1 iter_args(%compute_worker_start = %c0) -> (index) {
    %num_local_compute_workers = memref.load %compute_per_aux_list[%w] : memref<?xindex>

    /// Call auxiliary worker function asynchronously
    // %token = async.execute {
      func.call @comet_double_buffer_aux_worker_pull(
        %A_cast,                       /// double *A
        %A1,                           /// uint64_t A1
        %A2,                           /// uint64_t A2
        %A1_tile,                      /// uint64_t A1_tile
        %A2_tile,                      /// uint64_t A2_tile
        %A_buffer1s_cast,              /// std::vector<double *> &A_buffer1s
        %A_buffer2s_cast,              /// std::vector<double *> &A_buffer2s
        %A1_offset_list_cast,          /// std::vector<uint64_t> &A1_offset_list
        %A2_offset_list_cast,          /// std::vector<uint64_t> &A2_offset_list
        %A_block_rows_list_cast,       /// std::vector<uint64_t> &A_block_rows_list
        %A_block_cols_list_cast,       /// std::vector<uint64_t> &A_block_cols_list
        %A_buffer_readys_cast,         /// std::vector<int8_t *> &A_buffer_readys
        %B_cast,                       /// double *B
        %B1,                           /// uint64_t B1
        %B2,                           /// uint64_t B2
        %B1_tile,                      /// uint64_t B1_tile
        %B2_tile,                      /// uint64_t B2_tile
        %B_buffer1s_cast,              /// std::vector<double *> &B_buffer1s
        %B_buffer2s_cast,              /// std::vector<double *> &B_buffer2s
        %B1_offset_list_cast,          /// std::vector<uint64_t> &B1_offset_list
        %B2_offset_list_cast,          /// std::vector<uint64_t> &B2_offset_list
        %B_block_rows_list_cast,       /// std::vector<uint64_t> &B_block_rows_list
        %B_block_cols_list_cast,       /// std::vector<uint64_t> &B_block_cols_list
        %B_buffer_readys_cast,         /// std::vector<int8_t *> &B_buffer_readys
        %compute_worker_start,         /// uint64_t compute_worker_start
        %num_local_compute_workers,    /// uint64_t num_local_compute_workers
        %compute_workers_finished_cast, /// std::vector<int8_t *> &compute_workers_finished
        %num_compute_workers           /// uint64_t num_compute_workers
      ) : (
        memref<*xf64>,
        index,
        index,
        index,
        index,
        memref<*xmemref<*xmemref<*xf64>>>,
        memref<*xmemref<*xmemref<*xf64>>>,
        memref<*xmemref<*xindex>>,
        memref<*xmemref<*xindex>>,
        memref<*xmemref<*xindex>>,
        memref<*xmemref<*xindex>>,
        memref<*xmemref<*xi8>>,
        memref<*xf64>,
        index,
        index,
        index,
        index,
        memref<*xmemref<*xmemref<*xf64>>>,
        memref<*xmemref<*xmemref<*xf64>>>,
        memref<*xmemref<*xindex>>,
        memref<*xmemref<*xindex>>,
        memref<*xmemref<*xindex>>,
        memref<*xmemref<*xindex>>,
        memref<*xmemref<*xi8>>,
        index,
        index,
        memref<*xmemref<*xi8>>,
        index
      ) -> ()
    //   async.yield
    // }
    // async.add_to_group %token, %aux_group : !async.token

    /// Update compute_worker_start
    %compute_worker_next = arith.addi %compute_worker_start, %num_local_compute_workers : index
    scf.yield %compute_worker_next : index
  }

  // async.await_all %compute_group
  // async.await_all %aux_group
  scf.while (%curr_count = %c0) : (index) -> index {
    %condition = arith.cmpi ne, %curr_count, %num_compute_workers : index
    scf.condition(%condition) %curr_count : index
  } do {
  ^bb0(%arg0: index):
    %new_count = scf.for %w = %c0 to %num_compute_workers step %c1 iter_args(%count = %c0) -> (index) {
      %flag_ptr = memref.load %compute_workers_finished[%w] : memref<?xmemref<*xi8>>
      %flag = func.call @comet_atomic_load_n_i8(%flag_ptr) : (memref<*xi8>) -> (i8)
      %flag_extend = arith.index_cast %flag : i8 to index
      %next_count = arith.addi %flag_extend, %count : index
      scf.yield %next_count : index
    }
    scf.yield %new_count : index
  }

  %1 = call @getTime() : () -> f64

  func.call @comet_print_matrix_f64(%C_cast, %A1, %B2) : (memref<*xf64>, index, index) -> ()
  %sum = memref.alloc() : memref<1xf64>
  memref.store %cst0, %sum[%c0] : memref<1xf64>
  scf.for %i = %c0 to %C1 step %c1 {
    scf.for %j = %c0 to %C2 step %c1 {
      %C_val = memref.load %C_matrix[%i, %j] : memref<5x5xf64>
      %old_val = memref.load %sum[%c0] : memref<1xf64>
      %new_val = arith.addf %old_val, %C_val : f64
      memref.store %new_val, %sum[%c0] : memref<1xf64>
    }
  }
  %sum_val = memref.load %sum[%c0] : memref<1xf64>
  func.call @printF64(%sum_val) : (f64) -> ()
  func.call @printNewline() : () -> ()


  call @printElapsedTime(%0, %1) : (f64, f64) -> ()

  // ////////////////////
  // %A_buffer1s_cast = memref.cast %A_buffer1s : memref<?xmemref<*xmemref<*xf64>>> to memref<*xmemref<*xmemref<*xf64>>>
  // func.call @comet_test_array_of_buffers(%num_compute_workers, %A1_tile, %A2_tile, %A_buffer1s_cast) : (index, index, index, memref<*xmemref<*xmemref<*xf64>>>) -> ()

  // /// test async
  // // %compute_threads = memref.alloc(%num_compute_workers) : memref<?x!async.token>
  // %compute_threads = async.create_group %num_compute_workers : !async.group
  // scf.for %w = %c0 to %num_compute_workers step %c1 {
  //   %A_buffer_ptr_cast = memref.load %A_buffer1s[%w] : memref<?xmemref<*xmemref<*xf64>>>
  //   // func.call @comet_test_write_to_buffer(%w, %A1_tile, %A2_tile, %A_buffer_ptr_cast) : (index, index, index, memref<*xmemref<*xf64>>) -> ()
  //   %token = async.execute {
  //     func.call @comet_test_write_to_buffer(%w, %A1_tile, %A2_tile, %A_buffer_ptr_cast) : (index, index, index, memref<*xmemref<*xf64>>) -> ()
  //     async.yield
  //   }
  //   // memref.store %token, %compute_threads[%w] : memref<?x!async.token>
  //   async.add_to_group %token, %compute_threads : !async.token
  // }
  // // scf.for %w = %c0 to %num_compute_workers step %c1 {
  // //   %token = memref.load %compute_threads[%w] : memref<?x!async.token>
  // //   async.await %token : !async.token
  // // }
  // async.await_all %compute_threads
  // func.call @comet_test_array_of_buffers(%num_compute_workers, %A1_tile, %A2_tile, %A_buffer1s_cast) : (index, index, index, memref<*xmemref<*xmemref<*xf64>>>) -> ()
  // /// End test async



  /// ---------
  /// Clean up
  /// ---------
  // memref.dealloc %A_matrix : memref<5x5xf64>
  // memref.dealloc %B_matrix : memref<5x5xf64>
  // memref.dealloc %C_matrix : memref<5x5xf64>
  /// Deallocate buffers
  /// A_buffer1s
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %buffer_mm_cast = memref.load %A_buffer1s[%i] : memref<?xmemref<*xmemref<*xf64>>>
    %buffer_mm = memref.cast %buffer_mm_cast : memref<*xmemref<*xf64>> to memref<1xmemref<*xf64>>
    %buffer_m_cast = memref.load %buffer_mm[%c0] : memref<1xmemref<*xf64>>
    memref.dealloc %buffer_m_cast : memref<*xf64>
    memref.dealloc %buffer_mm_cast : memref<*xmemref<*xf64>>
  }
  memref.dealloc %A_buffer1s : memref<?xmemref<*xmemref<*xf64>>>
  /// A_buffer2s
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %buffer_mm_cast = memref.load %A_buffer2s[%i] : memref<?xmemref<*xmemref<*xf64>>>
    %buffer_mm = memref.cast %buffer_mm_cast : memref<*xmemref<*xf64>> to memref<1xmemref<*xf64>>
    %buffer_m_cast = memref.load %buffer_mm[%c0] : memref<1xmemref<*xf64>>
    memref.dealloc %buffer_m_cast : memref<*xf64>
    memref.dealloc %buffer_mm_cast : memref<*xmemref<*xf64>>
  }
  memref.dealloc %A_buffer2s : memref<?xmemref<*xmemref<*xf64>>>
  /// A_buffer_readys
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %is_ready_cast = memref.load %A_buffer_readys[%i] : memref<?xmemref<*xi8>>
    memref.dealloc %is_ready_cast : memref<*xi8>
  }
  memref.dealloc %A_buffer_readys : memref<?xmemref<*xi8>>
  /// A1_offset_list
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %offset_cast = memref.load %A1_offset_list[%i]: memref<?xmemref<*xindex>>
    memref.dealloc %offset_cast : memref<*xindex>
  }
  memref.dealloc %A1_offset_list : memref<?xmemref<*xindex>>
  /// A2_offset_list
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %offset_cast = memref.load %A2_offset_list[%i]: memref<?xmemref<*xindex>>
    memref.dealloc %offset_cast : memref<*xindex>
  }
  memref.dealloc %A2_offset_list : memref<?xmemref<*xindex>>
  /// A_block_rows_list
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %val_cast = memref.load %A_block_rows_list[%i]: memref<?xmemref<*xindex>>
    memref.dealloc %val_cast : memref<*xindex>
  }
  memref.dealloc %A_block_rows_list : memref<?xmemref<*xindex>>
  /// A_block_cols_list
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %val_cast = memref.load %A_block_cols_list[%i]: memref<?xmemref<*xindex>>
    memref.dealloc %val_cast : memref<*xindex>
  }
  memref.dealloc %A_block_cols_list : memref<?xmemref<*xindex>>

  /// B_buffer1s
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %buffer_mm_cast = memref.load %B_buffer1s[%i] : memref<?xmemref<*xmemref<*xf64>>>
    %buffer_mm = memref.cast %buffer_mm_cast : memref<*xmemref<*xf64>> to memref<1xmemref<*xf64>>
    %buffer_m_cast = memref.load %buffer_mm[%c0] : memref<1xmemref<*xf64>>
    memref.dealloc %buffer_m_cast : memref<*xf64>
    memref.dealloc %buffer_mm_cast : memref<*xmemref<*xf64>>
  }
  memref.dealloc %B_buffer1s : memref<?xmemref<*xmemref<*xf64>>>
  /// B_buffer2s
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %buffer_mm_cast = memref.load %B_buffer2s[%i] : memref<?xmemref<*xmemref<*xf64>>>
    %buffer_mm = memref.cast %buffer_mm_cast : memref<*xmemref<*xf64>> to memref<1xmemref<*xf64>>
    %buffer_m_cast = memref.load %buffer_mm[%c0] : memref<1xmemref<*xf64>>
    memref.dealloc %buffer_m_cast : memref<*xf64>
    memref.dealloc %buffer_mm_cast : memref<*xmemref<*xf64>>
  }
  memref.dealloc %B_buffer2s : memref<?xmemref<*xmemref<*xf64>>>
  /// B_buffer_readys
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %is_ready_cast = memref.load %B_buffer_readys[%i] : memref<?xmemref<*xi8>>
    memref.dealloc %is_ready_cast : memref<*xi8>
  }
  memref.dealloc %B_buffer_readys : memref<?xmemref<*xi8>>
  /// B1_offset_list
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %offset_cast = memref.load %B1_offset_list[%i]: memref<?xmemref<*xindex>>
    memref.dealloc %offset_cast : memref<*xindex>
  }
  memref.dealloc %B1_offset_list : memref<?xmemref<*xindex>>
  /// B2_offset_list
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %offset_cast = memref.load %B2_offset_list[%i]: memref<?xmemref<*xindex>>
    memref.dealloc %offset_cast : memref<*xindex>
  }
  memref.dealloc %B2_offset_list : memref<?xmemref<*xindex>>
  /// B_block_rows_list
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %val_cast = memref.load %B_block_rows_list[%i]: memref<?xmemref<*xindex>>
    memref.dealloc %val_cast : memref<*xindex>
  }
  memref.dealloc %B_block_rows_list : memref<?xmemref<*xindex>>
  /// B_block_cols_list
  scf.for %i = %c0 to %num_compute_workers step %c1 {
    %val_cast = memref.load %B_block_cols_list[%i]: memref<?xmemref<*xindex>>
    memref.dealloc %val_cast : memref<*xindex>
  }
  memref.dealloc %B_block_cols_list : memref<?xmemref<*xindex>>

  return
}

func.func private @comet_print_matrix_f64(memref<*xf64>, index, index)
func.func private @comet_atomic_load_n_i8(memref<*xi8>) -> i8
func.func private @comet_atomic_store_n_i8(memref<*xi8>, i8)
func.func private @comet_test_array_of_buffers(index, index, index, memref<*xmemref<*xmemref<*xf64>>>)
func.func private @comet_test_write_to_buffer(index, index, index, memref<*xmemref<*xf64>>)
func.func private @comet_double_buffer_compute_worker_drive(
  index,                   /// uint64_t A1
  index,                   /// uint64_t A2
  index,                   /// uint64_t A1_tile
  index,                   /// uint64_t A2_tile
  memref<*xindex>,         /// uint64_t *A1_offset_ptr
  memref<*xindex>,         /// uint64_t *A2_offset_ptr
  memref<*xindex>,         /// uint64_t *A_block_rows_ptr
  memref<*xindex>,         /// uint64_t *A_block_cols_ptr
  memref<*xmemref<*xf64>>, /// double **A_buffer1
  memref<*xi8>,            /// int8_t *A_buffer_is_ready
  index,                   /// uint64_t B1
  index,                   /// uint64_t B2
  index,                   /// uint64_t B1_tile
  index,                   /// uint64_t B2_tile
  memref<*xindex>,         /// uint64_t *B1_offset_ptr
  memref<*xindex>,         /// uint64_t *B2_offset_ptr
  memref<*xindex>,         /// uint64_t *B_block_rows_ptr
  memref<*xindex>,         /// uint64_t *B_block_cols_ptr
  memref<*xmemref<*xf64>>, /// double **B_buffer1
  memref<*xi8>,            /// int8_t *B_buffer_is_ready
  memref<*xf64>,           /// double *C
  index,                   /// uint64_t i_start
  index,                   /// uint64_t num_local_i_tiles
  memref<*xi8>             /// int8_t *is_finished
)
func.func private @comet_double_buffer_aux_worker_pull(
  memref<*xf64>,                     /// double *A
  index,                             /// uint64_t A1
  index,                             /// uint64_t A2
  index,                             /// uint64_t A1_tile
  index,                             /// uint64_t A2_tile
  memref<*xmemref<*xmemref<*xf64>>>, /// std::vector<double *> &A_buffer1s
  memref<*xmemref<*xmemref<*xf64>>>, /// std::vector<double *> &A_buffer2s
  memref<*xmemref<*xindex>>,         /// std::vector<uint64_t> &A1_offset_list
  memref<*xmemref<*xindex>>,         /// std::vector<uint64_t> &A2_offset_list
  memref<*xmemref<*xindex>>,         /// std::vector<uint64_t> &A_block_rows_list
  memref<*xmemref<*xindex>>,         /// std::vector<uint64_t> &A_block_cols_list
  memref<*xmemref<*xi8>>,            /// std::vector<int8_t *> &A_buffer_readys
  memref<*xf64>,                     /// double *B
  index,                             /// uint64_t B1
  index,                             /// uint64_t B2
  index,                             /// uint64_t B1_tile
  index,                             /// uint64_t B2_tile
  memref<*xmemref<*xmemref<*xf64>>>, /// std::vector<double *> &B_buffer1s
  memref<*xmemref<*xmemref<*xf64>>>, /// std::vector<double *> &B_buffer2s
  memref<*xmemref<*xindex>>,         /// std::vector<uint64_t> &B1_offset_list
  memref<*xmemref<*xindex>>,         /// std::vector<uint64_t> &B2_offset_list
  memref<*xmemref<*xindex>>,         /// std::vector<uint64_t> &B_block_rows_list
  memref<*xmemref<*xindex>>,         /// std::vector<uint64_t> &B_block_cols_list
  memref<*xmemref<*xi8>>,            /// std::vector<int8_t *> &B_buffer_readys
  index,                             /// uint64_t compute_worker_start
  index,                             /// uint64_t num_local_compute_workers
  memref<*xmemref<*xi8>>,            /// std::vector<int8_t *> &compute_workers_finished
  index                              /// uint64_t num_compute_workers
)
func.func private @getTime() -> f64
func.func private @printElapsedTime(f64, f64)
func.func private @printI64(i64)
func.func private @printF64(f64)
func.func private @printComma()
func.func private @printNewline()
}