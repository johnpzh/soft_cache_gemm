module {
  func.func @main() {
    %0 = "ta.index_label"() : () -> !ta.index
    %1 = "ta.index_label"() : () -> !ta.index
    %2 = "ta.index_label"() : () -> !ta.index
    %3 = "ta.dense_tensor_decl"() <{allocator = "rapid", format = "Dense"}> : () -> tensor<16x16xf64>
    %4 = "ta.dense_tensor_decl"() <{allocator = "rapid", format = "Dense"}> : () -> tensor<16x16xf64>
    %5 = "ta.dense_tensor_decl"() <{allocator = "rapid", format = "Dense"}> : () -> tensor<16x16xf64>
    "ta.fill"(%3) <{value = 2.200000e+00 : f64}> : (tensor<16x16xf64>) -> ()
    "ta.fill"(%4) <{value = 3.400000e+00 : f64}> : (tensor<16x16xf64>) -> ()
    "ta.fill"(%5) <{value = 0.000000e+00 : f64}> : (tensor<16x16xf64>) -> ()
    %6 = "ta.getTime"() : () -> f64
    %7 = "ta.mul"(%3, %4, %0, %1, %1, %2, %0, %2) <{MaskType = "none", formats = ["Dense", "Dense", "Dense"], indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d1)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d2)>], operandSegmentSizes = array<i32: 1, 1, 6, 0>, semiring = "plusxy_times"}> {__alpha__ = 1.000000e+00 : f64, __beta__ = 0.000000e+00 : f64} : (tensor<16x16xf64>, tensor<16x16xf64>, !ta.index, !ta.index, !ta.index, !ta.index, !ta.index, !ta.index) -> tensor<16x16xf64>
    "ta.set_op"(%7, %5) {__beta__ = 0.000000e+00 : f64} : (tensor<16x16xf64>, tensor<16x16xf64>) -> ()
    %8 = "ta.getTime"() : () -> f64
    %9 = "ta.reduce"(%5) : (tensor<16x16xf64>) -> f64
    "ta.print"(%9) : (f64) -> ()
    "ta.print_elapsed_time"(%6, %8) : (f64, f64) -> ()
    return
  }
}
