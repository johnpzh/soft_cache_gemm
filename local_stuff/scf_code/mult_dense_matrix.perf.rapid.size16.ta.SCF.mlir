module {
  func.func @main() {
    %c16 = arith.constant 16 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f64
    %cst_0 = arith.constant 3.400000e+00 : f64
    %cst_1 = arith.constant 2.200000e+00 : f64
    %idx16 = index.constant 16
    %alloc = memref.alloc() {alignment = 32 : i64, allocator = "rapid"} : memref<16x16xf64>
    scf.for %arg0 = %c0 to %c16 step %c1 {
      scf.for %arg1 = %c0 to %c16 step %c1 {
        memref.store %cst_1, %alloc[%arg0, %arg1] : memref<16x16xf64>
      }
    }
    %alloc_2 = memref.alloc() {alignment = 32 : i64, allocator = "rapid"} : memref<16x16xf64>
    scf.for %arg0 = %c0 to %c16 step %c1 {
      scf.for %arg1 = %c0 to %c16 step %c1 {
        memref.store %cst_0, %alloc_2[%arg0, %arg1] : memref<16x16xf64>
      }
    }
    %alloc_3 = memref.alloc() {alignment = 32 : i64, allocator = "rapid"} : memref<16x16xf64>
    scf.for %arg0 = %c0 to %c16 step %c1 {
      scf.for %arg1 = %c0 to %c16 step %c1 {
        memref.store %cst, %alloc_3[%arg0, %arg1] : memref<16x16xf64>
      }
    }
    %0 = call @getTime() : () -> f64
    scf.parallel (%arg0) = (%c0) to (%c16) step (%c1) {
      scf.for %arg1 = %c0 to %idx16 step %c1 {
        %3 = memref.load %alloc[%arg0, %arg1] : memref<16x16xf64>
        scf.for %arg2 = %c0 to %idx16 step %c1 {
          %4 = memref.load %alloc_2[%arg1, %arg2] : memref<16x16xf64>
          %5 = arith.mulf %3, %4 : f64
          %6 = memref.load %alloc_3[%arg0, %arg2] : memref<16x16xf64>
          %7 = arith.addf %6, %5 : f64
          memref.store %7, %alloc_3[%arg0, %arg2] : memref<16x16xf64>
        }
      }
      scf.reduce 
    }
    %1 = call @getTime() : () -> f64
    %alloc_4 = memref.alloc() : memref<1xf64>
    memref.store %cst, %alloc_4[%c0] : memref<1xf64>
    scf.for %arg0 = %c0 to %c16 step %c1 {
      scf.for %arg1 = %c0 to %c16 step %c1 {
        %3 = memref.load %alloc_3[%arg0, %arg1] : memref<16x16xf64>
        %4 = memref.load %alloc_4[%c0] : memref<1xf64>
        %5 = arith.addf %3, %4 : f64
        memref.store %5, %alloc_4[%c0] : memref<1xf64>
      }
    }
    %2 = memref.load %alloc_4[%c0] : memref<1xf64>
    call @printF64(%2) : (f64) -> ()
    call @printNewline() : () -> ()
    call @printElapsedTime(%0, %1) : (f64, f64) -> ()
    return
  }
  func.func private @getTime() -> f64
  func.func private @printElapsedTime(f64, f64)
  func.func private @printF64(f64)
  func.func private @printNewline()
}
