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

  %ptr_to_ptr = memref.alloc() : memref<1xmemref<*xf64>>
  %ptr = memref.alloc(%c17) : memref<?xf64>
  %ptr_cast = memref.cast %ptr : memref<?xf64> to memref<*xf64>
  memref.store %ptr_cast, %ptr_to_ptr[%c0] : memref<1xmemref<*xf64>>
  %result3 = scf.for %arg0 = %c0 to %c17 step %c1 iter_args(%arg1 = %cst17) -> (f64) {
    memref.store %arg1, %ptr[%arg0] : memref<?xf64>
    scf.yield %arg1 : f64
  }
  %cast = memref.cast %ptr_to_ptr : memref<1xmemref<*xf64>> to memref<*xmemref<*xf64>>
  func.call @comet_sanity_check(%cast) : (memref<*xmemref<*xf64>>) -> ()

  %ptr2 = memref.alloc(%c17) : memref<?xf64>
  %ptr2_cast = memref.cast %ptr2 : memref<?xf64> to memref<*xf64>
  memref.store %ptr2_cast, %ptr_to_ptr[%c0] : memref<1xmemref<*xf64>>
  %result4 = scf.for %arg0 = %c0 to %c17 step %c1 iter_args(%arg1 = %cst2) -> (f64) {
    memref.store %arg1, %ptr2[%arg0] : memref<?xf64>
    scf.yield %arg1 : f64
  }
  func.call @comet_sanity_check(%cast) : (memref<*xmemref<*xf64>>) -> ()

  return
}

// func.func private @comet_sanity_check(memref<*xf64>, memref<*xf64>, i64, i64)
func.func private @comet_sanity_check(memref<*xmemref<*xf64>>)
}