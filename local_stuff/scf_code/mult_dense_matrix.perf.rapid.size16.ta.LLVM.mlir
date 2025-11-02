module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @rapid_malloc(!llvm.ptr, i64) -> !llvm.ptr
  llvm.func @rapid_initialize() -> !llvm.ptr
  llvm.func @main() {
    %0 = llvm.mlir.constant(16 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %4 = llvm.mlir.constant(3.400000e+00 : f64) : f64
    %5 = llvm.mlir.constant(2.200000e+00 : f64) : f64
    %6 = llvm.mlir.constant(16 : i64) : i64
    %7 = llvm.mlir.constant(16 : index) : i64
    %8 = llvm.mlir.constant(16 : index) : i64
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.constant(256 : index) : i64
    %11 = llvm.mlir.zero : !llvm.ptr
    %12 = llvm.getelementptr %11[256] : (!llvm.ptr) -> !llvm.ptr, f64
    %13 = llvm.ptrtoint %12 : !llvm.ptr to i64
    %14 = llvm.mlir.constant(32 : index) : i64
    %15 = llvm.add %13, %14 : i64
    %16 = llvm.call @rapid_initialize() : () -> !llvm.ptr
    %17 = llvm.call @rapid_malloc(%16, %15) : (!llvm.ptr, i64) -> !llvm.ptr
    %18 = llvm.ptrtoint %17 : !llvm.ptr to i64
    %19 = llvm.mlir.constant(1 : index) : i64
    %20 = llvm.sub %14, %19 : i64
    %21 = llvm.add %18, %20 : i64
    %22 = llvm.urem %21, %14  : i64
    %23 = llvm.sub %21, %22 : i64
    %24 = llvm.inttoptr %23 : i64 to !llvm.ptr
    %25 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %26 = llvm.insertvalue %17, %25[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.insertvalue %24, %26[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %28 = llvm.mlir.constant(0 : index) : i64
    %29 = llvm.insertvalue %28, %27[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.insertvalue %7, %29[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = llvm.insertvalue %8, %30[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %32 = llvm.insertvalue %8, %31[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %33 = llvm.insertvalue %9, %32[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%2 : i64)
  ^bb1(%34: i64):  // 2 preds: ^bb0, ^bb5
    %35 = llvm.icmp "slt" %34, %0 : i64
    llvm.cond_br %35, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%2 : i64)
  ^bb3(%36: i64):  // 2 preds: ^bb2, ^bb4
    %37 = llvm.icmp "slt" %36, %0 : i64
    llvm.cond_br %37, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %38 = llvm.mlir.constant(16 : index) : i64
    %39 = llvm.mul %34, %38 : i64
    %40 = llvm.add %39, %36 : i64
    %41 = llvm.getelementptr %24[%40] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %41 : f64, !llvm.ptr
    %42 = llvm.add %36, %1 : i64
    llvm.br ^bb3(%42 : i64)
  ^bb5:  // pred: ^bb3
    %43 = llvm.add %34, %1 : i64
    llvm.br ^bb1(%43 : i64)
  ^bb6:  // pred: ^bb1
    %44 = llvm.mlir.constant(16 : index) : i64
    %45 = llvm.mlir.constant(16 : index) : i64
    %46 = llvm.mlir.constant(1 : index) : i64
    %47 = llvm.mlir.constant(256 : index) : i64
    %48 = llvm.mlir.zero : !llvm.ptr
    %49 = llvm.getelementptr %48[256] : (!llvm.ptr) -> !llvm.ptr, f64
    %50 = llvm.ptrtoint %49 : !llvm.ptr to i64
    %51 = llvm.mlir.constant(32 : index) : i64
    %52 = llvm.add %50, %51 : i64
    %53 = llvm.call @rapid_malloc(%16, %52) : (!llvm.ptr, i64) -> !llvm.ptr
    %54 = llvm.ptrtoint %53 : !llvm.ptr to i64
    %55 = llvm.mlir.constant(1 : index) : i64
    %56 = llvm.sub %51, %55 : i64
    %57 = llvm.add %54, %56 : i64
    %58 = llvm.urem %57, %51  : i64
    %59 = llvm.sub %57, %58 : i64
    %60 = llvm.inttoptr %59 : i64 to !llvm.ptr
    %61 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %62 = llvm.insertvalue %53, %61[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %63 = llvm.insertvalue %60, %62[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %64 = llvm.mlir.constant(0 : index) : i64
    %65 = llvm.insertvalue %64, %63[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %66 = llvm.insertvalue %44, %65[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %67 = llvm.insertvalue %45, %66[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.insertvalue %45, %67[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %69 = llvm.insertvalue %46, %68[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb7(%2 : i64)
  ^bb7(%70: i64):  // 2 preds: ^bb6, ^bb11
    %71 = llvm.icmp "slt" %70, %0 : i64
    llvm.cond_br %71, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%2 : i64)
  ^bb9(%72: i64):  // 2 preds: ^bb8, ^bb10
    %73 = llvm.icmp "slt" %72, %0 : i64
    llvm.cond_br %73, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %74 = llvm.mlir.constant(16 : index) : i64
    %75 = llvm.mul %70, %74 : i64
    %76 = llvm.add %75, %72 : i64
    %77 = llvm.getelementptr %60[%76] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %4, %77 : f64, !llvm.ptr
    %78 = llvm.add %72, %1 : i64
    llvm.br ^bb9(%78 : i64)
  ^bb11:  // pred: ^bb9
    %79 = llvm.add %70, %1 : i64
    llvm.br ^bb7(%79 : i64)
  ^bb12:  // pred: ^bb7
    %80 = llvm.mlir.constant(16 : index) : i64
    %81 = llvm.mlir.constant(16 : index) : i64
    %82 = llvm.mlir.constant(1 : index) : i64
    %83 = llvm.mlir.constant(256 : index) : i64
    %84 = llvm.mlir.zero : !llvm.ptr
    %85 = llvm.getelementptr %84[256] : (!llvm.ptr) -> !llvm.ptr, f64
    %86 = llvm.ptrtoint %85 : !llvm.ptr to i64
    %87 = llvm.mlir.constant(32 : index) : i64
    %88 = llvm.add %86, %87 : i64
    %89 = llvm.call @rapid_malloc(%16, %88) : (!llvm.ptr, i64) -> !llvm.ptr
    %90 = llvm.ptrtoint %89 : !llvm.ptr to i64
    %91 = llvm.mlir.constant(1 : index) : i64
    %92 = llvm.sub %87, %91 : i64
    %93 = llvm.add %90, %92 : i64
    %94 = llvm.urem %93, %87  : i64
    %95 = llvm.sub %93, %94 : i64
    %96 = llvm.inttoptr %95 : i64 to !llvm.ptr
    %97 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %98 = llvm.insertvalue %89, %97[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %99 = llvm.insertvalue %96, %98[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %100 = llvm.mlir.constant(0 : index) : i64
    %101 = llvm.insertvalue %100, %99[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %102 = llvm.insertvalue %80, %101[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %103 = llvm.insertvalue %81, %102[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %104 = llvm.insertvalue %81, %103[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %105 = llvm.insertvalue %82, %104[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb13(%2 : i64)
  ^bb13(%106: i64):  // 2 preds: ^bb12, ^bb17
    %107 = llvm.icmp "slt" %106, %0 : i64
    llvm.cond_br %107, ^bb14, ^bb18
  ^bb14:  // pred: ^bb13
    llvm.br ^bb15(%2 : i64)
  ^bb15(%108: i64):  // 2 preds: ^bb14, ^bb16
    %109 = llvm.icmp "slt" %108, %0 : i64
    llvm.cond_br %109, ^bb16, ^bb17
  ^bb16:  // pred: ^bb15
    %110 = llvm.mlir.constant(16 : index) : i64
    %111 = llvm.mul %106, %110 : i64
    %112 = llvm.add %111, %108 : i64
    %113 = llvm.getelementptr %96[%112] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %3, %113 : f64, !llvm.ptr
    %114 = llvm.add %108, %1 : i64
    llvm.br ^bb15(%114 : i64)
  ^bb17:  // pred: ^bb15
    %115 = llvm.add %106, %1 : i64
    llvm.br ^bb13(%115 : i64)
  ^bb18:  // pred: ^bb13
    %116 = llvm.call @getTime() : () -> f64
    omp.parallel {
      omp.wsloop {
        omp.loop_nest (%arg0) : i64 = (%2) to (%0) step (%1) {
          llvm.br ^bb1(%2 : i64)
        ^bb1(%149: i64):  // 2 preds: ^bb0, ^bb5
          %150 = llvm.icmp "slt" %149, %6 : i64
          llvm.cond_br %150, ^bb2, ^bb6
        ^bb2:  // pred: ^bb1
          %151 = llvm.mlir.constant(16 : index) : i64
          %152 = llvm.mul %arg0, %151 : i64
          %153 = llvm.add %152, %149 : i64
          %154 = llvm.getelementptr %24[%153] : (!llvm.ptr, i64) -> !llvm.ptr, f64
          %155 = llvm.load %154 : !llvm.ptr -> f64
          llvm.br ^bb3(%2 : i64)
        ^bb3(%156: i64):  // 2 preds: ^bb2, ^bb4
          %157 = llvm.icmp "slt" %156, %6 : i64
          llvm.cond_br %157, ^bb4, ^bb5
        ^bb4:  // pred: ^bb3
          %158 = llvm.mlir.constant(16 : index) : i64
          %159 = llvm.mul %149, %158 : i64
          %160 = llvm.add %159, %156 : i64
          %161 = llvm.getelementptr %60[%160] : (!llvm.ptr, i64) -> !llvm.ptr, f64
          %162 = llvm.load %161 : !llvm.ptr -> f64
          %163 = llvm.fmul %155, %162  : f64
          %164 = llvm.mlir.constant(16 : index) : i64
          %165 = llvm.mul %arg0, %164 : i64
          %166 = llvm.add %165, %156 : i64
          %167 = llvm.getelementptr %96[%166] : (!llvm.ptr, i64) -> !llvm.ptr, f64
          %168 = llvm.load %167 : !llvm.ptr -> f64
          %169 = llvm.fadd %168, %163  : f64
          %170 = llvm.mlir.constant(16 : index) : i64
          %171 = llvm.mul %arg0, %170 : i64
          %172 = llvm.add %171, %156 : i64
          %173 = llvm.getelementptr %96[%172] : (!llvm.ptr, i64) -> !llvm.ptr, f64
          llvm.store %169, %173 : f64, !llvm.ptr
          %174 = llvm.add %156, %1 : i64
          llvm.br ^bb3(%174 : i64)
        ^bb5:  // pred: ^bb3
          %175 = llvm.add %149, %1 : i64
          llvm.br ^bb1(%175 : i64)
        ^bb6:  // pred: ^bb1
          omp.yield
        }
        omp.terminator
      }
      omp.terminator
    }
    %117 = llvm.call @getTime() : () -> f64
    %118 = llvm.mlir.constant(1 : index) : i64
    %119 = llvm.mlir.constant(1 : index) : i64
    %120 = llvm.mlir.zero : !llvm.ptr
    %121 = llvm.getelementptr %120[1] : (!llvm.ptr) -> !llvm.ptr, f64
    %122 = llvm.ptrtoint %121 : !llvm.ptr to i64
    %123 = llvm.call @malloc(%122) : (i64) -> !llvm.ptr
    %124 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %125 = llvm.insertvalue %123, %124[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %126 = llvm.insertvalue %123, %125[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %127 = llvm.mlir.constant(0 : index) : i64
    %128 = llvm.insertvalue %127, %126[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %129 = llvm.insertvalue %118, %128[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %130 = llvm.insertvalue %119, %129[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %131 = llvm.getelementptr %123[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %3, %131 : f64, !llvm.ptr
    llvm.br ^bb19(%2 : i64)
  ^bb19(%132: i64):  // 2 preds: ^bb18, ^bb23
    %133 = llvm.icmp "slt" %132, %0 : i64
    llvm.cond_br %133, ^bb20, ^bb24
  ^bb20:  // pred: ^bb19
    llvm.br ^bb21(%2 : i64)
  ^bb21(%134: i64):  // 2 preds: ^bb20, ^bb22
    %135 = llvm.icmp "slt" %134, %0 : i64
    llvm.cond_br %135, ^bb22, ^bb23
  ^bb22:  // pred: ^bb21
    %136 = llvm.mlir.constant(16 : index) : i64
    %137 = llvm.mul %132, %136 : i64
    %138 = llvm.add %137, %134 : i64
    %139 = llvm.getelementptr %96[%138] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %140 = llvm.load %139 : !llvm.ptr -> f64
    %141 = llvm.getelementptr %123[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %142 = llvm.load %141 : !llvm.ptr -> f64
    %143 = llvm.fadd %140, %142  : f64
    %144 = llvm.getelementptr %123[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %143, %144 : f64, !llvm.ptr
    %145 = llvm.add %134, %1 : i64
    llvm.br ^bb21(%145 : i64)
  ^bb23:  // pred: ^bb21
    %146 = llvm.add %132, %1 : i64
    llvm.br ^bb19(%146 : i64)
  ^bb24:  // pred: ^bb19
    %147 = llvm.getelementptr %123[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %148 = llvm.load %147 : !llvm.ptr -> f64
    llvm.call @printF64(%148) : (f64) -> ()
    llvm.call @printNewline() : () -> ()
    llvm.call @printElapsedTime(%116, %117) : (f64, f64) -> ()
    llvm.return
  }
  llvm.func @getTime() -> f64 attributes {sym_visibility = "private"}
  llvm.func @printElapsedTime(f64, f64) attributes {sym_visibility = "private"}
  llvm.func @printF64(f64) attributes {sym_visibility = "private"}
  llvm.func @printNewline() attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeAddRef(!llvm.ptr, i64) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeDropRef(!llvm.ptr, i64) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeCreateToken() -> !llvm.ptr attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeCreateValue(i64) -> !llvm.ptr attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeCreateGroup(i64) -> !llvm.ptr attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeEmplaceToken(!llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeEmplaceValue(!llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeSetTokenError(!llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeSetValueError(!llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeIsTokenError(!llvm.ptr) -> i1 attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeIsValueError(!llvm.ptr) -> i1 attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeIsGroupError(!llvm.ptr) -> i1 attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeAwaitToken(!llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeAwaitValue(!llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeAwaitAllInGroup(!llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeExecute(!llvm.ptr, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeGetValueStorage(!llvm.ptr) -> !llvm.ptr attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeAddTokenToGroup(!llvm.ptr, !llvm.ptr) -> i64 attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeAwaitTokenAndExecute(!llvm.ptr, !llvm.ptr, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeAwaitValueAndExecute(!llvm.ptr, !llvm.ptr, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimeAwaitAllInGroupAndExecute(!llvm.ptr, !llvm.ptr, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @mlirAsyncRuntimGetNumWorkerThreads() -> i64 attributes {sym_visibility = "private"}
}
