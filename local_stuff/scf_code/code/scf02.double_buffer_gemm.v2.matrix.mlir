
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
  %c2 = arith.constant 2 : index
  %c17 = arith.constant 17 : index
  %cst0 = arith.constant 0.0 : f64
  %cst1 = arith.constant 1.1 : f64
  %cst2 = arith.constant 2.2 : f64
  %cst17 = arith.constant 17.0 : f64
  %char0 = arith.constant 0 : i8
  %char1 = arith.constant 1 : i8
  %char17 = arith.constant 17 : i8

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

  %0 = call @getTime() : () -> f64

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

  // %A = memref.alloc(%A_size) : memref<?xf64>
  // %B = memref.alloc(%B_size) : memref<?xf64>
  // %C = memref.alloc(%C_size) : memref<?xf64>
  // scf.for %arg0 = %c0 to %A_size step %c1 {
  //   memref.store %cst1, %A[%arg0] : memref<?xf64>
  // }
  // scf.for %arg0 = %c0 to %B_size step %c1 {
  //   memref.store %cst2, %B[%arg0] : memref<?xf64>
  // }
  // scf.for %arg0 = %c0 to %C_size step %c1 {
  //   memref.store %cst0, %C[%arg0] : memref<?xf64>
  // }
  %A_buffer1_mm = memref.alloc() : memref<1xmemref<*xf64>>
  %A_buffer1_memref = memref.alloc(%A_tile_size) : memref<?xf64>
  %A_buffer1_memref_cast = memref.cast %A_buffer1_memref : memref<?xf64> to memref<*xf64>
  memref.store %A_buffer1_memref_cast, %A_buffer1_mm[%c0] : memref<1xmemref<*xf64>>

  %A_buffer2_mm = memref.alloc() : memref<1xmemref<*xf64>>
  %A_buffer2_memref = memref.alloc(%A_tile_size) : memref<?xf64>
  %A_buffer2_memref_cast = memref.cast %A_buffer2_memref : memref<?xf64> to memref<*xf64>
  memref.store %A_buffer2_memref_cast, %A_buffer2_mm[%c0] : memref<1xmemref<*xf64>>

  %B_buffer1_mm = memref.alloc() : memref<1xmemref<*xf64>>
  %B_buffer1_memref = memref.alloc(%A_tile_size) : memref<?xf64>
  %B_buffer1_memref_cast = memref.cast %B_buffer1_memref : memref<?xf64> to memref<*xf64>
  memref.store %B_buffer1_memref_cast, %B_buffer1_mm[%c0] : memref<1xmemref<*xf64>>

  %B_buffer2_mm = memref.alloc() : memref<1xmemref<*xf64>>
  %B_buffer2_memref = memref.alloc(%A_tile_size) : memref<?xf64>
  %B_buffer2_memref_cast = memref.cast %B_buffer2_memref : memref<?xf64> to memref<*xf64>
  memref.store %B_buffer2_memref_cast, %B_buffer2_mm[%c0] : memref<1xmemref<*xf64>>

  %A_buffer_is_ready = memref.alloc(%c1) : memref<?xi8>
  memref.store %char0, %A_buffer_is_ready[%c0] : memref<?xi8>

  %B_buffer_is_ready = memref.alloc(%c1) : memref<?xi8>
  memref.store %char0, %B_buffer_is_ready[%c0] : memref<?xi8>

  // %A_cast = memref.cast %A : memref<?xf64> to memref<*xf64>
  %A_cast = memref.cast %A_matrix : memref<5x5xf64> to memref<*xf64>
  %A1_cast = arith.index_cast %A1 : index to i64
  %A2_cast = arith.index_cast %A2 : index to i64
  %A_buffer1_mm_cast = memref.cast %A_buffer1_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %A_buffer2_mm_cast = memref.cast %A_buffer2_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %A1_tile_cast = arith.index_cast %A1_tile : index to i64
  %A2_tile_cast = arith.index_cast %A2_tile : index to i64
  %A_buffer_is_ready_cast = memref.cast %A_buffer_is_ready : memref<?xi8> to memref<*xi8>

  // %B_cast = memref.cast %B : memref<?xf64> to memref<*xf64>
  %B_cast = memref.cast %B_matrix : memref<5x5xf64> to memref<*xf64>
  %B1_cast = arith.index_cast %B1 : index to i64
  %B2_cast = arith.index_cast %B2 : index to i64
  %B_buffer1_mm_cast = memref.cast %B_buffer1_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %B_buffer2_mm_cast = memref.cast %B_buffer2_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %B1_tile_cast = arith.index_cast %B1_tile : index to i64
  %B2_tile_cast = arith.index_cast %B2_tile : index to i64
  %B_buffer_is_ready_cast = memref.cast %B_buffer_is_ready : memref<?xi8> to memref<*xi8>

  %token = async.execute {
    func.call @comet_initialize_double_buffer_thread(
      %A_cast,                 /// double *A
      %A1_cast,                /// uint64_t A1
      %A2_cast,                /// uint64_t A2
      %A_buffer1_mm_cast,      /// double **A_buffer1
      %A_buffer2_mm_cast,      /// double **A_buffer2
      %A1_tile_cast,           /// uint64_t A1_tile
      %A2_tile_cast,           /// uint64_t A2_tile
      %A_buffer_is_ready_cast, /// int8_t *A_buffer_is_ready
      %B_cast,                 /// double *B
      %B1_cast,                /// uint64_t B1
      %B2_cast,                /// uint64_t B2
      %B_buffer1_mm_cast,      /// double **B_buffer1
      %B_buffer2_mm_cast,      /// double **B_buffer2
      %B1_tile_cast,           /// uint64_t B1_tile
      %B2_tile_cast,           /// uint64_t B2_tile
      %B_buffer_is_ready_cast  /// int8_t *B_buffer_is_ready
    ) : (
      memref<*xf64>,           /// double *A
      i64,                     /// uint64_t A1
      i64,                     /// uint64_t A2
      memref<*xmemref<*xf64>>, /// double **A_buffer1
      memref<*xmemref<*xf64>>, /// double **A_buffer2
      i64,                     /// uint64_t A1_tile
      i64,                     /// uint64_t A2_tile
      memref<*xi8>,            /// int8_t *A_buffer_is_ready
      memref<*xf64>,           /// double *B
      i64,                     /// uint64_t B1
      i64,                     /// uint64_t B2
      memref<*xmemref<*xf64>>, /// double **B_buffer1
      memref<*xmemref<*xf64>>, /// double **B_buffer2
      i64,                     /// uint64_t B1_tile
      i64,                     /// uint64_t B2_tile
      memref<*xi8>             /// int8_t *B_buffer_is_ready
    ) -> ()
    async.yield
  }

  scf.for %ii = %c0 to %A1 step %A1_tile {
    %A1_minus_ii = arith.subi %A1, %ii : index
    %A_block_rows = arith.minsi %A1_tile, %A1_minus_ii : index
    scf.for %kk = %c0 to %A2 step %A2_tile {
      %A2_minus_kk = arith.subi %A2, %kk : index
      %A_block_cols = arith.minsi %A2_tile, %A2_minus_kk : index
      %B_block_rows = arith.addi %A_block_cols, %c0 : index
      /// Sync A_buffer
      %A_flag_initial = memref.load %A_buffer_is_ready[%c0] : memref<?xi8>
      %res0 = scf.while (%A_flag = %A_flag_initial) : (i8) -> i8 {
        %condition = arith.cmpi eq, %A_flag, %char0 : i8  /// while A_buffer is NOT ready
        scf.condition(%condition) %A_flag : i8
      } do {
      ^bb0(%A_flag_arg: i8):
        /// Spin
        %loaded = func.call @comet_atomic_load_n_i8(%A_buffer_is_ready_cast) : (memref<*xi8>) -> i8
        scf.yield %loaded : i8
      }
      scf.for %jj = %c0 to %B2 step %B2_tile {
        %B2_minus_jj = arith.subi %B2, %jj : index
        %B_block_cols = arith.minsi %B2_tile, %B2_minus_jj : index
        /// Sync B_buffer
        %B_flag_initial = memref.load %B_buffer_is_ready[%c0] : memref<?xi8>
        %res1 = scf.while (%B_flag = %B_flag_initial) : (i8) -> i8 {
          %condition = arith.cmpi eq, %B_flag, %char0 : i8 /// while B_buffer is NOT ready
          scf.condition(%condition) %B_flag : i8
        } do {
        ^bb0(%B_flag_arg: i8):
          /// Spin
          %loaded = func.call @comet_atomic_load_n_i8(%B_buffer_is_ready_cast) : (memref<*xi8>) -> i8
          scf.yield %loaded : i8
        }

        /// Compute
        %A_buffer_active = memref.load %A_buffer1_mm[%c0] : memref<1xmemref<*xf64>>
        %A_buffer = memref.cast %A_buffer_active : memref<*xf64> to memref<?xf64>
        %B_buffer_active = memref.load %B_buffer1_mm[%c0] : memref<1xmemref<*xf64>>
        %B_buffer = memref.cast %B_buffer_active : memref<*xf64> to memref<?xf64>
        scf.for %i = %c0 to %A_block_rows step %c1 {
          %c_i = arith.addi %ii, %i : index
          scf.for %k = %c0 to %A_block_cols step %c1 {
            %offset_A = arith.muli %i, %A2_tile : index
            %loc_A = arith.addi %offset_A, %k : index
            %A_val = memref.load %A_buffer[%loc_A] : memref<?xf64>
            scf.for %j = %c0 to %B_block_cols step %c1 {
              %offset_B = arith.muli %k, %B2_tile : index
              %loc_B = arith.addi %offset_B, %j : index
              %B_val = memref.load %B_buffer[%loc_B] : memref<?xf64>
              %mul_res = arith.mulf %A_val, %B_val : f64

              %c_j = arith.addi %jj, %j : index
              %offset_C = arith.muli %c_i, %B2 : index
              %loc_C = arith.addi %offset_C, %c_j : index
              // %old_val = memref.load %C[%loc_C] : memref<?xf64>
              %old_val = memref.load %C_matrix[%c_i, %c_j] : memref<5x5xf64>
              %new_val = arith.addf %old_val, %mul_res : f64
              // memref.store %new_val, %C[%loc_C] : memref<?xf64>
              memref.store %new_val, %C_matrix[%c_i, %c_j] : memref<5x5xf64>

              // /// test
              // func.call @pp_index(%loc_C) : (index) -> ()
              // func.call @printNewline() : () -> ()
              // /// End test
            }
          }
        }

        func.call @comet_atomic_store_n_i8(%B_buffer_is_ready_cast, %char0) : (memref<*xi8>, i8) -> ()

      }

      func.call @comet_atomic_store_n_i8(%A_buffer_is_ready_cast, %char0) : (memref<*xi8>, i8) -> ()
    }
  }

  async.await %token : !async.token

  // %C_cast = memref.cast %C : memref<?xf64> to memref<*xf64>
  %C_cast = memref.cast %C_matrix : memref<5x5xf64> to memref<*xf64>
  func.call @comet_print_matrix_f64(%C_cast, %A1, %B2) : (memref<*xf64>, index, index) -> ()

  %1 = call @getTime() : () -> f64
  call @printElapsedTime(%0, %1) : (f64, f64) -> ()

  // memref.dealloc %A : memref<?xf64>
  // memref.dealloc %B : memref<?xf64>
  // memref.dealloc %C : memref<?xf64>
  memref.dealloc %A_matrix : memref<5x5xf64>
  memref.dealloc %B_matrix : memref<5x5xf64>
  memref.dealloc %C_matrix : memref<5x5xf64>
  memref.dealloc %A_buffer1_memref : memref<?xf64>
  memref.dealloc %A_buffer1_mm : memref<1xmemref<*xf64>>
  memref.dealloc %A_buffer2_memref : memref<?xf64>
  memref.dealloc %A_buffer2_mm : memref<1xmemref<*xf64>>
  memref.dealloc %B_buffer1_memref : memref<?xf64>
  memref.dealloc %B_buffer1_mm : memref<1xmemref<*xf64>>
  memref.dealloc %B_buffer2_memref : memref<?xf64>
  memref.dealloc %B_buffer2_mm : memref<1xmemref<*xf64>>
  memref.dealloc %A_buffer_is_ready : memref<?xi8>
  memref.dealloc %B_buffer_is_ready : memref<?xi8>

  return
}

func.func private @comet_print_memref_to_memref_f64(memref<*xmemref<*xf64>>)
func.func private @comet_print_matrix_f64(memref<*xf64>, index, index)
func.func private @comet_atomic_load_n_i8(memref<*xi8>) -> i8
func.func private @comet_atomic_store_n_i8(memref<*xi8>, i8)
func.func private @comet_swap_buffers(memref<*xmemref<*xf64>>, memref<*xmemref<*xf64>>)
func.func private @comet_initialize_double_buffer_thread(
    memref<*xf64>,           /// double *A
    i64,                     /// uint64_t A1
    i64,                     /// uint64_t A2
    memref<*xmemref<*xf64>>, /// double **A_buffer1
    memref<*xmemref<*xf64>>, /// double **A_buffer2
    i64,                     /// uint64_t A1_tile
    i64,                     /// uint64_t A2_tile
    memref<*xi8>,            /// int8_t *A_buffer_is_ready
    memref<*xf64>,           /// double *B
    i64,                     /// uint64_t B1
    i64,                     /// uint64_t B2
    memref<*xmemref<*xf64>>, /// double **B_buffer1
    memref<*xmemref<*xf64>>, /// double **B_buffer2
    i64,                     /// uint64_t B1_tile
    i64,                     /// uint64_t B2_tile
    memref<*xi8>             /// int8_t *B_buffer_is_ready
    )
func.func private @getTime() -> f64
func.func private @printElapsedTime(f64, f64)
func.func private @printI64(i64)
func.func private @printF64(f64)
func.func private @printComma()
func.func private @printNewline()
}
