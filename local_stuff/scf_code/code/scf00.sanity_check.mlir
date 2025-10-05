// module {
//   func.func @main() {
//     func.call @intialize_thread() : () -> ()

//     return
//   }

//   func.func private @intialize_thread()
// }

module {
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c17 = arith.constant 17 : index
  %cst1 = arith.constant 1.0 : f64
  %cst2 = arith.constant 2.0 : f64
  %cst17 = arith.constant 17.0 : f64
  %char0 = arith.constant 0 : i8
  %char1 = arith.constant 1 : i8
  %char17 = arith.constant 17 : i8

  // /// Allocate the buffer to hold 2 blocks
  // %A_buffer = memref.alloc(%c2): memref<?xmemref<?xf64>>
  // scf.for %arg0 = %c0 to %c2 step %c1 {
  //   %array = memref.alloc(%c17): memref<?xf64>
  //   memref.store %array, %A_buffer[%arg0] : memref<?xmemref<?xf64>>
  // }

  // // %array1 = memref.alloc(%c17): memref<?xf64>
  // %array1 = memref.load %A_buffer[%c0] : memref<?xmemref<?xf64>>
  // %cast1 = memref.cast %array1 : memref<?xf64> to memref<*xf64>
  // // %array2 = memref.alloc(%c17): memref<?xf64>
  // %array2 = memref.load %A_buffer[%c1] : memref<?xmemref<?xf64>>
  // %cast2 = memref.cast %array2 : memref<?xf64> to memref<*xf64>

  // %result1 = scf.for %arg0 = %c0 to %c17 step %c1 iter_args(%arg1 = %cst1) -> (f64) {
  //   memref.store %arg1, %array1[%arg0] : memref<?xf64>
  //   // %plus_one = arith.addf %arg1, %cst1 : f64
  //   // scf.yield %plus_one : f64
  //   scf.yield %arg1 : f64
  // }

  // %result2 = scf.for %arg0 = %c0 to %c17 step %c1 iter_args(%arg1 = %cst2) -> (f64) {
  //   memref.store %arg1, %array2[%arg0] : memref<?xf64>
  //   scf.yield %arg1 : f64
  // }

  // %pointer1 = memref.extract_aligned_pointer_as_index %array1 : memref<?xf64> -> index
  // %pointer1_i64 = arith.index_cast %pointer1 : index to i64
  // %pointer2 = memref.extract_aligned_pointer_as_index %array2 : memref<?xf64> -> index
  // %pointer2_i64 = arith.index_cast %pointer2 : index to i64
  // func.call @comet_sanity_check(%cast1, %cast2, %pointer1_i64, %pointer2_i64) : (memref<*xf64>, memref<*xf64>, i64, i64) -> ()

  /// -----------------
  /// Allocate memref
  /// -----------------
  %memref_to_memref = memref.alloc() : memref<1xmemref<*xf64>>
  %memref = memref.alloc(%c17) : memref<?xf64>
  %memref_cast = memref.cast %memref : memref<?xf64> to memref<*xf64>
  memref.store %memref_cast, %memref_to_memref[%c0] : memref<1xmemref<*xf64>>
  %result3 = scf.for %arg0 = %c0 to %c17 step %c1 iter_args(%arg1 = %cst17) -> (f64) {
    memref.store %arg1, %memref[%arg0] : memref<?xf64>
    scf.yield %arg1 : f64
  }
  %cast = memref.cast %memref_to_memref : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  func.call @comet_print_memref_to_memref_f64(%cast) : (memref<*xmemref<*xf64>>) -> ()
  func.call @printNewline() : () -> ()

  /// -----------------
  /// Allocate memref2, change memref_to_memref to memref2
  /// -----------------
  %memref2 = memref.alloc(%c17) : memref<?xf64>
  %memref2_cast = memref.cast %memref2 : memref<?xf64> to memref<*xf64>
  memref.store %memref2_cast, %memref_to_memref[%c0] : memref<1xmemref<*xf64>>
  %result4 = scf.for %arg0 = %c0 to %c17 step %c1 iter_args(%arg1 = %cst2) -> (f64) {
    memref.store %arg1, %memref2[%arg0] : memref<?xf64>
    scf.yield %arg1 : f64
  }
  func.call @comet_print_memref_to_memref_f64(%cast) : (memref<*xmemref<*xf64>>) -> ()
  func.call @printNewline() : () -> ()

  /// -----------------
  /// Allocate flag
  /// -----------------
  %flag = memref.alloc() : memref<1xi8>
  memref.store %char0, %flag[%c0] : memref<1xi8>
  %flag_cast = memref.cast %flag : memref<1xi8> to memref<*xi8>

  %loaded1 = memref.load %flag[%c0] : memref<1xi8>
  %loaded1_extui = arith.extui %loaded1 : i8 to i64
  func.call @printI64(%loaded1_extui) : (i64) -> ()
  func.call @printNewline() : () -> ()

  /// Test atomic load
  %result1 = func.call @comet_atomic_load_n_i8(%flag_cast) : (memref<*xi8>) -> i8
  %result1_extui = arith.extui %result1 : i8 to i64
  func.call @printI64(%result1_extui) : (i64) -> ()
  func.call @printNewline() : () -> ()

  /// Test atomic store
  func.call @comet_atomic_store_n_i8(%flag_cast, %char17) : (memref<*xi8>, i8) -> ()
  %loaded3 = memref.load %flag[%c0] : memref<1xi8>
  %loaded3_extui = arith.extui %loaded3 : i8 to i64
  func.call @printI64(%loaded3_extui) : (i64) -> ()
  func.call @printNewline() : () -> ()
  func.call @printNewline() : () -> ()

  /// -----------------
  /// Swap memrefs
  /// -----------------
  %memref_to_memref1 = memref.alloc() : memref<1xmemref<*xf64>>
  memref.store %memref_cast, %memref_to_memref1[%c0] : memref<1xmemref<*xf64>>
  %memref_to_memref2 = memref.alloc() : memref<1xmemref<*xf64>>
  memref.store %memref2_cast, %memref_to_memref2[%c0] : memref<1xmemref<*xf64>>
  %cast1 = memref.cast %memref_to_memref1 : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  %cast2 = memref.cast %memref_to_memref2 : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  func.call @comet_swap_buffers(%cast1, %cast2) : (memref<*xmemref<*xf64>>, memref<*xmemref<*xf64>>) -> ()
  func.call @comet_print_memref_to_memref_f64(%cast1) : (memref<*xmemref<*xf64>>) -> ()
  func.call @printNewline() : () -> ()
  func.call @comet_print_memref_to_memref_f64(%cast2) : (memref<*xmemref<*xf64>>) -> ()
  func.call @printNewline() : () -> ()

  /// -----------------
  /// Thread
  /// -----------------
  func.call @comet_initialize_double_buffer_thread(%cast1) : (memref<*xmemref<*xf64>>) -> ()
  func.call @comet_print_memref_to_memref_f64(%cast1) : (memref<*xmemref<*xf64>>) -> ()
  func.call @printNewline() : () -> ()

  return
}

// func.func private @comet_sanity_check(memref<*xf64>, memref<*xf64>, i64, i64)
// func.func private @comet_sanity_check(memref<*xmemref<*xf64>>, memref<*xi8>)
func.func private @comet_print_memref_to_memref_f64(memref<*xmemref<*xf64>>)
func.func private @comet_atomic_load_n_i8(memref<*xi8>) -> i8
func.func private @comet_atomic_store_n_i8(memref<*xi8>, i8)
func.func private @comet_swap_buffers(memref<*xmemref<*xf64>>, memref<*xmemref<*xf64>>)
func.func private @comet_initialize_double_buffer_thread(memref<*xmemref<*xf64>>)
func.func private @printI64(i64)
func.func private @printF64(f64)
func.func private @printNewline()
}