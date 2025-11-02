module {
  func.func @main() {
    %0 = "ta.dense_tensor_decl"() <{allocator = "default", format = "Dense"}> : () -> tensor<16x16xf64>
    %1 = "ta.dense_tensor_decl"() <{allocator = "default", format = "Dense"}> : () -> tensor<16x16xf64>
    %2 = "ta.dense_tensor_decl"() <{allocator = "default", format = "Dense"}> : () -> tensor<16x16xf64>
    "ta.fill"(%0) <{value = 2.200000e+00 : f64}> : (tensor<16x16xf64>) -> ()
    "ta.fill"(%1) <{value = 3.400000e+00 : f64}> : (tensor<16x16xf64>) -> ()
    "ta.fill"(%2) <{value = 0.000000e+00 : f64}> : (tensor<16x16xf64>) -> ()
    %3 = "ta.getTime"() : () -> f64
    %4 = "it.itree"(%2) <{operandSegmentSizes = array<i32: 1, 0>}> ({
    ^bb0(%arg0: tensor<16x16xf64>):
      %7 = "it.RootOp"() : () -> !it.index_tree
      %8 = "it.DomainOp"(%0) <{dim = 0 : ui32, format = 0 : i32}> : (tensor<16x16xf64>) -> !it.domain
      %9 = "it.IndexOp"(%7, %8) <{IsParallel = true}> : (!it.index_tree, !it.domain) -> !it.index
      %10 = "it.DomainOp"(%1) <{dim = 0 : ui32, format = 0 : i32}> : (tensor<16x16xf64>) -> !it.domain
      %11 = "it.DomainOp"(%0) <{dim = 1 : ui32, format = 0 : i32}> : (tensor<16x16xf64>) -> !it.domain
      %12 = "it.DomainIntersectionOp"(%11, %10) <{operandSegmentSizes = array<i32: 2, 0>}> : (!it.domain, !it.domain) -> !it.domain
      %13 = "it.IndexOp"(%9, %12) <{IsParallel = false}> : (!it.index, !it.domain) -> !it.index
      %14 = "it.DomainOp"(%1) <{dim = 1 : ui32, format = 0 : i32}> : (tensor<16x16xf64>) -> !it.domain
      %15 = "it.IndexOp"(%13, %14) <{IsParallel = false}> : (!it.index, !it.domain) -> !it.index
      %crd, %pos = "it.IndexToTensorDim"(%arg0, %9) <{dim = 0 : ui32}> : (tensor<16x16xf64>, !it.index) -> (index, index)
      %crd_0, %pos_1 = "it.IndexToTensorDim"(%arg0, %15, %pos) <{dim = 1 : ui32}> : (tensor<16x16xf64>, !it.index, index) -> (index, index)
      %16 = "it.LHSOperandOp"(%arg0, %pos, %pos_1, %crd, %crd_0) : (tensor<16x16xf64>, index, index, index, index) -> !it.operand
      %crd_2, %pos_3 = "it.IndexToTensorDim"(%0, %9) <{dim = 0 : ui32}> : (tensor<16x16xf64>, !it.index) -> (index, index)
      %crd_4, %pos_5 = "it.IndexToTensorDim"(%0, %13, %pos_3) <{dim = 1 : ui32}> : (tensor<16x16xf64>, !it.index, index) -> (index, index)
      %17 = "it.OperandOp"(%0, %pos_3, %pos_5, %crd_2, %crd_4) : (tensor<16x16xf64>, index, index, index, index) -> !it.operand
      %crd_6, %pos_7 = "it.IndexToTensorDim"(%1, %13) <{dim = 0 : ui32}> : (tensor<16x16xf64>, !it.index) -> (index, index)
      %crd_8, %pos_9 = "it.IndexToTensorDim"(%1, %15, %pos_7) <{dim = 1 : ui32}> : (tensor<16x16xf64>, !it.index, index) -> (index, index)
      %18 = "it.OperandOp"(%1, %pos_7, %pos_9, %crd_6, %crd_8) : (tensor<16x16xf64>, index, index, index, index) -> !it.operand
      %19 = "it.ComputeOp"(%15, %16, %17, %18) <{compute_missing = false, operandSegmentSizes = array<i32: 1, 1, 2, 0>, semiring = "plusxy_times"}> : (!it.index, !it.operand, !it.operand, !it.operand) -> tensor<16x16xf64>
      it.yield %19 : tensor<16x16xf64>
    }) : (tensor<16x16xf64>) -> tensor<16x16xf64>
    "ta.set_op"(%4, %2) {__beta__ = 0.000000e+00 : f64} : (tensor<16x16xf64>, tensor<16x16xf64>) -> ()
    %5 = "ta.getTime"() : () -> f64
    %6 = "ta.reduce"(%2) : (tensor<16x16xf64>) -> f64
    "ta.print"(%6) : (f64) -> ()
    "ta.print_elapsed_time"(%3, %5) : (f64, f64) -> ()
    return
  }
}
