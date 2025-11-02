module {
  llvm.func @malloc(i64) -> !llvm.ptr
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
    %16 = llvm.call @malloc(%15) : (i64) -> !llvm.ptr
    %17 = llvm.ptrtoint %16 : !llvm.ptr to i64
    %18 = llvm.mlir.constant(1 : index) : i64
    %19 = llvm.sub %14, %18 : i64
    %20 = llvm.add %17, %19 : i64
    %21 = llvm.urem %20, %14  : i64
    %22 = llvm.sub %20, %21 : i64
    %23 = llvm.inttoptr %22 : i64 to !llvm.ptr
    %24 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %25 = llvm.insertvalue %16, %24[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.insertvalue %23, %25[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.mlir.constant(0 : index) : i64
    %28 = llvm.insertvalue %27, %26[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %29 = llvm.insertvalue %7, %28[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %30 = llvm.insertvalue %8, %29[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %31 = llvm.insertvalue %8, %30[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %32 = llvm.insertvalue %9, %31[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb1(%2 : i64)
  ^bb1(%33: i64):  // 2 preds: ^bb0, ^bb5
    %34 = llvm.icmp "slt" %33, %0 : i64
    llvm.cond_br %34, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%2 : i64)
  ^bb3(%35: i64):  // 2 preds: ^bb2, ^bb4
    %36 = llvm.icmp "slt" %35, %0 : i64
    llvm.cond_br %36, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %37 = llvm.mlir.constant(16 : index) : i64
    %38 = llvm.mul %33, %37 : i64
    %39 = llvm.add %38, %35 : i64
    %40 = llvm.getelementptr %23[%39] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %40 : f64, !llvm.ptr
    %41 = llvm.add %35, %1 : i64
    llvm.br ^bb3(%41 : i64)
  ^bb5:  // pred: ^bb3
    %42 = llvm.add %33, %1 : i64
    llvm.br ^bb1(%42 : i64)
  ^bb6:  // pred: ^bb1
    %43 = llvm.mlir.constant(16 : index) : i64
    %44 = llvm.mlir.constant(16 : index) : i64
    %45 = llvm.mlir.constant(1 : index) : i64
    %46 = llvm.mlir.constant(256 : index) : i64
    %47 = llvm.mlir.zero : !llvm.ptr
    %48 = llvm.getelementptr %47[256] : (!llvm.ptr) -> !llvm.ptr, f64
    %49 = llvm.ptrtoint %48 : !llvm.ptr to i64
    %50 = llvm.mlir.constant(32 : index) : i64
    %51 = llvm.add %49, %50 : i64
    %52 = llvm.call @malloc(%51) : (i64) -> !llvm.ptr
    %53 = llvm.ptrtoint %52 : !llvm.ptr to i64
    %54 = llvm.mlir.constant(1 : index) : i64
    %55 = llvm.sub %50, %54 : i64
    %56 = llvm.add %53, %55 : i64
    %57 = llvm.urem %56, %50  : i64
    %58 = llvm.sub %56, %57 : i64
    %59 = llvm.inttoptr %58 : i64 to !llvm.ptr
    %60 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %61 = llvm.insertvalue %52, %60[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.insertvalue %59, %61[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %63 = llvm.mlir.constant(0 : index) : i64
    %64 = llvm.insertvalue %63, %62[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %65 = llvm.insertvalue %43, %64[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %66 = llvm.insertvalue %44, %65[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %67 = llvm.insertvalue %44, %66[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.insertvalue %45, %67[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb7(%2 : i64)
  ^bb7(%69: i64):  // 2 preds: ^bb6, ^bb11
    %70 = llvm.icmp "slt" %69, %0 : i64
    llvm.cond_br %70, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    llvm.br ^bb9(%2 : i64)
  ^bb9(%71: i64):  // 2 preds: ^bb8, ^bb10
    %72 = llvm.icmp "slt" %71, %0 : i64
    llvm.cond_br %72, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %73 = llvm.mlir.constant(16 : index) : i64
    %74 = llvm.mul %69, %73 : i64
    %75 = llvm.add %74, %71 : i64
    %76 = llvm.getelementptr %59[%75] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %4, %76 : f64, !llvm.ptr
    %77 = llvm.add %71, %1 : i64
    llvm.br ^bb9(%77 : i64)
  ^bb11:  // pred: ^bb9
    %78 = llvm.add %69, %1 : i64
    llvm.br ^bb7(%78 : i64)
  ^bb12:  // pred: ^bb7
    %79 = llvm.mlir.constant(16 : index) : i64
    %80 = llvm.mlir.constant(16 : index) : i64
    %81 = llvm.mlir.constant(1 : index) : i64
    %82 = llvm.mlir.constant(256 : index) : i64
    %83 = llvm.mlir.zero : !llvm.ptr
    %84 = llvm.getelementptr %83[256] : (!llvm.ptr) -> !llvm.ptr, f64
    %85 = llvm.ptrtoint %84 : !llvm.ptr to i64
    %86 = llvm.mlir.constant(32 : index) : i64
    %87 = llvm.add %85, %86 : i64
    %88 = llvm.call @malloc(%87) : (i64) -> !llvm.ptr
    %89 = llvm.ptrtoint %88 : !llvm.ptr to i64
    %90 = llvm.mlir.constant(1 : index) : i64
    %91 = llvm.sub %86, %90 : i64
    %92 = llvm.add %89, %91 : i64
    %93 = llvm.urem %92, %86  : i64
    %94 = llvm.sub %92, %93 : i64
    %95 = llvm.inttoptr %94 : i64 to !llvm.ptr
    %96 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %97 = llvm.insertvalue %88, %96[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %98 = llvm.insertvalue %95, %97[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %99 = llvm.mlir.constant(0 : index) : i64
    %100 = llvm.insertvalue %99, %98[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %101 = llvm.insertvalue %79, %100[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %102 = llvm.insertvalue %80, %101[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %103 = llvm.insertvalue %80, %102[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %104 = llvm.insertvalue %81, %103[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.br ^bb13(%2 : i64)
  ^bb13(%105: i64):  // 2 preds: ^bb12, ^bb17
    %106 = llvm.icmp "slt" %105, %0 : i64
    llvm.cond_br %106, ^bb14, ^bb18
  ^bb14:  // pred: ^bb13
    llvm.br ^bb15(%2 : i64)
  ^bb15(%107: i64):  // 2 preds: ^bb14, ^bb16
    %108 = llvm.icmp "slt" %107, %0 : i64
    llvm.cond_br %108, ^bb16, ^bb17
  ^bb16:  // pred: ^bb15
    %109 = llvm.mlir.constant(16 : index) : i64
    %110 = llvm.mul %105, %109 : i64
    %111 = llvm.add %110, %107 : i64
    %112 = llvm.getelementptr %95[%111] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %3, %112 : f64, !llvm.ptr
    %113 = llvm.add %107, %1 : i64
    llvm.br ^bb15(%113 : i64)
  ^bb17:  // pred: ^bb15
    %114 = llvm.add %105, %1 : i64
    llvm.br ^bb13(%114 : i64)
  ^bb18:  // pred: ^bb13
    %115 = llvm.call @getTime() : () -> f64
    omp.parallel {
      omp.wsloop {
        omp.loop_nest (%arg0) : i64 = (%2) to (%0) step (%1) {
          llvm.br ^bb1(%2 : i64)
        ^bb1(%148: i64):  // 2 preds: ^bb0, ^bb5
          %149 = llvm.icmp "slt" %148, %6 : i64
          llvm.cond_br %149, ^bb2, ^bb6
        ^bb2:  // pred: ^bb1
          %150 = llvm.mlir.constant(16 : index) : i64
          %151 = llvm.mul %arg0, %150 : i64
          %152 = llvm.add %151, %148 : i64
          %153 = llvm.getelementptr %23[%152] : (!llvm.ptr, i64) -> !llvm.ptr, f64
          %154 = llvm.load %153 : !llvm.ptr -> f64
          llvm.br ^bb3(%2 : i64)
        ^bb3(%155: i64):  // 2 preds: ^bb2, ^bb4
          %156 = llvm.icmp "slt" %155, %6 : i64
          llvm.cond_br %156, ^bb4, ^bb5
        ^bb4:  // pred: ^bb3
          %157 = llvm.mlir.constant(16 : index) : i64
          %158 = llvm.mul %148, %157 : i64
          %159 = llvm.add %158, %155 : i64
          %160 = llvm.getelementptr %59[%159] : (!llvm.ptr, i64) -> !llvm.ptr, f64
          %161 = llvm.load %160 : !llvm.ptr -> f64
          %162 = llvm.fmul %154, %161  : f64
          %163 = llvm.mlir.constant(16 : index) : i64
          %164 = llvm.mul %arg0, %163 : i64
          %165 = llvm.add %164, %155 : i64
          %166 = llvm.getelementptr %95[%165] : (!llvm.ptr, i64) -> !llvm.ptr, f64
          %167 = llvm.load %166 : !llvm.ptr -> f64
          %168 = llvm.fadd %167, %162  : f64
          %169 = llvm.mlir.constant(16 : index) : i64
          %170 = llvm.mul %arg0, %169 : i64
          %171 = llvm.add %170, %155 : i64
          %172 = llvm.getelementptr %95[%171] : (!llvm.ptr, i64) -> !llvm.ptr, f64
          llvm.store %168, %172 : f64, !llvm.ptr
          %173 = llvm.add %155, %1 : i64
          llvm.br ^bb3(%173 : i64)
        ^bb5:  // pred: ^bb3
          %174 = llvm.add %148, %1 : i64
          llvm.br ^bb1(%174 : i64)
        ^bb6:  // pred: ^bb1
          omp.yield
        }
        omp.terminator
      }
      omp.terminator
    }
    %116 = llvm.call @getTime() : () -> f64
    %117 = llvm.mlir.constant(1 : index) : i64
    %118 = llvm.mlir.constant(1 : index) : i64
    %119 = llvm.mlir.zero : !llvm.ptr
    %120 = llvm.getelementptr %119[1] : (!llvm.ptr) -> !llvm.ptr, f64
    %121 = llvm.ptrtoint %120 : !llvm.ptr to i64
    %122 = llvm.call @malloc(%121) : (i64) -> !llvm.ptr
    %123 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %124 = llvm.insertvalue %122, %123[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %125 = llvm.insertvalue %122, %124[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %126 = llvm.mlir.constant(0 : index) : i64
    %127 = llvm.insertvalue %126, %125[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %128 = llvm.insertvalue %117, %127[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %129 = llvm.insertvalue %118, %128[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %130 = llvm.getelementptr %122[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %3, %130 : f64, !llvm.ptr
    llvm.br ^bb19(%2 : i64)
  ^bb19(%131: i64):  // 2 preds: ^bb18, ^bb23
    %132 = llvm.icmp "slt" %131, %0 : i64
    llvm.cond_br %132, ^bb20, ^bb24
  ^bb20:  // pred: ^bb19
    llvm.br ^bb21(%2 : i64)
  ^bb21(%133: i64):  // 2 preds: ^bb20, ^bb22
    %134 = llvm.icmp "slt" %133, %0 : i64
    llvm.cond_br %134, ^bb22, ^bb23
  ^bb22:  // pred: ^bb21
    %135 = llvm.mlir.constant(16 : index) : i64
    %136 = llvm.mul %131, %135 : i64
    %137 = llvm.add %136, %133 : i64
    %138 = llvm.getelementptr %95[%137] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %139 = llvm.load %138 : !llvm.ptr -> f64
    %140 = llvm.getelementptr %122[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %141 = llvm.load %140 : !llvm.ptr -> f64
    %142 = llvm.fadd %139, %141  : f64
    %143 = llvm.getelementptr %122[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %142, %143 : f64, !llvm.ptr
    %144 = llvm.add %133, %1 : i64
    llvm.br ^bb21(%144 : i64)
  ^bb23:  // pred: ^bb21
    %145 = llvm.add %131, %1 : i64
    llvm.br ^bb19(%145 : i64)
  ^bb24:  // pred: ^bb19
    %146 = llvm.getelementptr %122[%2] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %147 = llvm.load %146 : !llvm.ptr -> f64
    llvm.call @printF64(%147) : (f64) -> ()
    llvm.call @printNewline() : () -> ()
    llvm.call @printElapsedTime(%115, %116) : (f64, f64) -> ()
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
