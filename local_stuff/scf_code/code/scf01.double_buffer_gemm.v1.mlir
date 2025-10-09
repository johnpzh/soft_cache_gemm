
module {
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

  %A = memref.alloc(%A_size) : memref<?xf64>
  %B = memref.alloc(%B_size) : memref<?xf64>
  %C = memref.alloc(%C_size) : memref<?xf64>
  scf.for %arg0 = %c0 to %A_size step %c1 {
    memref.store %cst1, %A[%arg0] : memref<?xf64>
  }
  scf.for %arg0 = %c0 to %B_size step %c1 {
    memref.store %cst2, %B[%arg0] : memref<?xf64>
  }
  scf.for %arg0 = %c0 to %C_size step %c1 {
    memref.store %cst0, %C[%arg0] : memref<?xf64>
  }
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

  %A_cast = memref.cast %A : memref<?xf64> to memref<*xf64>
  %A1_cast = arith.index_cast %A1 : index to i64
  %A2_cast = arith.index_cast %A2 : index to i64
  %A_buffer1_mm_cast = memref.cast %A_buffer1_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %A_buffer2_mm_cast = memref.cast %A_buffer2_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %A1_tile_cast = arith.index_cast %A1_tile : index to i64
  %A2_tile_cast = arith.index_cast %A2_tile : index to i64
  %A_buffer_is_ready_cast = memref.cast %A_buffer_is_ready : memref<?xi8> to memref<*xi8>

  %B_cast = memref.cast %B : memref<?xf64> to memref<*xf64>
  %B1_cast = arith.index_cast %B1 : index to i64
  %B2_cast = arith.index_cast %B2 : index to i64
  %B_buffer1_mm_cast = memref.cast %B_buffer1_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %B_buffer2_mm_cast = memref.cast %B_buffer2_mm : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %B1_tile_cast = arith.index_cast %B1_tile : index to i64
  %B2_tile_cast = arith.index_cast %B2_tile : index to i64
  %B_buffer_is_ready_cast = memref.cast %B_buffer_is_ready : memref<?xi8> to memref<*xi8>


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

  // scf.for %ii = %c0 to %A1 step %A1_tile {
  //   %A1_minus_ii = arith.subi %A1, %ii : index
  //   %A_block_rows = arith.maxsi %A1_tile, %A1_minus_ii : index
  //   scf.for %kk = %c0 to %A2 step %A2_tile {
  //     %A2_minus_kk = arith.subi %A2, %kk : index
  //     %A_block_cols = arith.maxsi %A2_tile, %A2_minus_kk : index
  //     %B_block_rows = arith.addi %A_block_cols, %c0 : index
  //     // /// Sync A_buffer
  //     // %A_flag_initial = memref.load %A_buffer_is_ready[%c0] : memref<?xi8>
  //     // %res0 = scf.while (%A_flag = %A_flag_initial) : (i8) -> i8 {
  //     //   %condition = arith.cmpi eq, %A_flag, %char0 : i8  /// while A_buffer is NOT ready
  //     //   scf.condition(%condition) %A_flag : i8
  //     // } do {
  //     // ^bb0(%A_flag_arg: i8):
  //     //   %loaded = func.call @comet_atomic_load_n_i8(%A_buffer_is_ready_cast) : (memref<*xi8>) -> i8
  //     //   /// test
  //     //   %loaded_extui = arith.extui %loaded : i8 to i64
  //     //   func.call @printI64(%loaded_extui) : (i64) -> ()
  //     //   func.call @printNewline() : () -> ()
  //     //   /// end test
  //     //   scf.yield %loaded : i8
  //     // }

  //     // /// test
  //     // %res0_extui = arith.extui %res0 : i8 to i64
  //     // func.call @printI64(%res0_extui) : (i64) -> ()
  //     // func.call @printComma() : () -> ()
  //     // func.call @printNewline() : () -> ()
  //     // /// end test

  //     // func.call @comet_atomic_store_n_i8(%A_buffer_is_ready_cast, %char0) : (memref<*xi8>, i8) -> ()
  //   }
  // }

  memref.dealloc %A : memref<?xf64>
  memref.dealloc %B : memref<?xf64>
  memref.dealloc %C : memref<?xf64>
  memref.dealloc %A_buffer1_memref : memref<?xf64>
  memref.dealloc %A_buffer1_mm : memref<1xmemref<*xf64>>
  memref.dealloc %A_buffer2_memref : memref<?xf64>
  memref.dealloc %A_buffer2_mm : memref<1xmemref<*xf64>>
  memref.dealloc %B_buffer1_memref : memref<?xf64>
  memref.dealloc %B_buffer1_mm : memref<1xmemref<*xf64>>
  memref.dealloc %A_buffer_is_ready : memref<?xi8>
  memref.dealloc %B_buffer_is_ready : memref<?xi8>
  %hello = arith.index_cast %c17 : index to i64
  func.call @printI64(%hello) : (i64) -> ()
  func.call @printNewline() : () -> ()
  return
}

func.func private @comet_print_memref_to_memref_f64(memref<*xmemref<*xf64>>)
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
func.func private @printI64(i64)
func.func private @printF64(f64)
func.func private @printComma()
func.func private @printNewline()
}
