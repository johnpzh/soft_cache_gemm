module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @main() {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(2 : index) : i64
    %3 = llvm.mlir.constant(17 : index) : i64
    %4 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %5 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %6 = llvm.mlir.constant(1.700000e+01 : f64) : f64
    %7 = llvm.mlir.constant(2 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.zero : !llvm.ptr
    %10 = llvm.getelementptr %9[%7] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %11 = llvm.ptrtoint %10 : !llvm.ptr to i64
    %12 = llvm.mlir.zero : !llvm.ptr
    %13 = llvm.getelementptr %12[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %14 = llvm.ptrtoint %13 : !llvm.ptr to i64
    %15 = llvm.add %11, %14 : i64
    %16 = llvm.call @malloc(%15) : (i64) -> !llvm.ptr
    %17 = llvm.ptrtoint %16 : !llvm.ptr to i64
    %18 = llvm.mlir.constant(1 : index) : i64
    %19 = llvm.sub %14, %18 : i64
    %20 = llvm.add %17, %19 : i64
    %21 = llvm.urem %20, %14  : i64
    %22 = llvm.sub %20, %21 : i64
    %23 = llvm.inttoptr %22 : i64 to !llvm.ptr
    %24 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %25 = llvm.insertvalue %16, %24[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.insertvalue %23, %25[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.mlir.constant(0 : index) : i64
    %28 = llvm.insertvalue %27, %26[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %29 = llvm.insertvalue %7, %28[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.insertvalue %8, %29[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb1(%0 : i64)
  ^bb1(%31: i64):  // 2 preds: ^bb0, ^bb2
    %32 = llvm.icmp "slt" %31, %2 : i64
    llvm.cond_br %32, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %33 = llvm.mlir.constant(17 : index) : i64
    %34 = llvm.mlir.constant(1 : index) : i64
    %35 = llvm.mlir.zero : !llvm.ptr
    %36 = llvm.getelementptr %35[%33] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %37 = llvm.ptrtoint %36 : !llvm.ptr to i64
    %38 = llvm.call @malloc(%37) : (i64) -> !llvm.ptr
    %39 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %40 = llvm.insertvalue %38, %39[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.insertvalue %38, %40[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %42 = llvm.mlir.constant(0 : index) : i64
    %43 = llvm.insertvalue %42, %41[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %44 = llvm.insertvalue %33, %43[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %45 = llvm.insertvalue %34, %44[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %46 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %47 = llvm.getelementptr %46[%31] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    llvm.store %45, %47 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %48 = llvm.add %31, %1 : i64
    llvm.br ^bb1(%48 : i64)
  ^bb3:  // pred: ^bb1
    %49 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %50 = llvm.getelementptr %49[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %51 = llvm.load %50 : !llvm.ptr -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %52 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %53 = llvm.getelementptr %52[%1] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %54 = llvm.load %53 : !llvm.ptr -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    llvm.br ^bb4(%0 : i64)
  ^bb4(%55: i64):  // 2 preds: ^bb3, ^bb5
    %56 = llvm.icmp "slt" %55, %3 : i64
    llvm.cond_br %56, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %57 = llvm.extractvalue %51[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %58 = llvm.getelementptr %57[%55] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %4, %58 : f64, !llvm.ptr
    %59 = llvm.add %55, %1 : i64
    llvm.br ^bb4(%59 : i64)
  ^bb6:  // pred: ^bb4
    llvm.br ^bb7(%0 : i64)
  ^bb7(%60: i64):  // 2 preds: ^bb6, ^bb8
    %61 = llvm.icmp "slt" %60, %3 : i64
    llvm.cond_br %61, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    %62 = llvm.extractvalue %54[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %63 = llvm.getelementptr %62[%60] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %63 : f64, !llvm.ptr
    %64 = llvm.add %60, %1 : i64
    llvm.br ^bb7(%64 : i64)
  ^bb9:  // pred: ^bb7
    %65 = llvm.mlir.constant(1 : index) : i64
    %66 = llvm.mlir.constant(1 : index) : i64
    %67 = llvm.mlir.zero : !llvm.ptr
    %68 = llvm.getelementptr %67[%65] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %69 = llvm.ptrtoint %68 : !llvm.ptr to i64
    %70 = llvm.mlir.zero : !llvm.ptr
    %71 = llvm.getelementptr %70[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %72 = llvm.ptrtoint %71 : !llvm.ptr to i64
    %73 = llvm.add %69, %72 : i64
    %74 = llvm.call @malloc(%73) : (i64) -> !llvm.ptr
    %75 = llvm.ptrtoint %74 : !llvm.ptr to i64
    %76 = llvm.mlir.constant(1 : index) : i64
    %77 = llvm.sub %72, %76 : i64
    %78 = llvm.add %75, %77 : i64
    %79 = llvm.urem %78, %72  : i64
    %80 = llvm.sub %78, %79 : i64
    %81 = llvm.inttoptr %80 : i64 to !llvm.ptr
    %82 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %83 = llvm.insertvalue %74, %82[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %84 = llvm.insertvalue %81, %83[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %85 = llvm.mlir.constant(0 : index) : i64
    %86 = llvm.insertvalue %85, %84[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %87 = llvm.insertvalue %65, %86[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %88 = llvm.insertvalue %66, %87[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %89 = llvm.mlir.constant(17 : index) : i64
    %90 = llvm.mlir.constant(1 : index) : i64
    %91 = llvm.mlir.zero : !llvm.ptr
    %92 = llvm.getelementptr %91[%89] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %93 = llvm.ptrtoint %92 : !llvm.ptr to i64
    %94 = llvm.call @malloc(%93) : (i64) -> !llvm.ptr
    %95 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %96 = llvm.insertvalue %94, %95[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %97 = llvm.insertvalue %94, %96[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %98 = llvm.mlir.constant(0 : index) : i64
    %99 = llvm.insertvalue %98, %97[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %100 = llvm.insertvalue %89, %99[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %101 = llvm.insertvalue %90, %100[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %102 = llvm.mlir.constant(1 : index) : i64
    %103 = llvm.alloca %102 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %101, %103 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %104 = llvm.mlir.constant(1 : index) : i64
    %105 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %106 = llvm.insertvalue %104, %105[0] : !llvm.struct<(i64, ptr)> 
    %107 = llvm.insertvalue %103, %106[1] : !llvm.struct<(i64, ptr)> 
    %108 = llvm.extractvalue %88[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %109 = llvm.getelementptr %108[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %107, %109 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    llvm.br ^bb10(%0 : i64)
  ^bb10(%110: i64):  // 2 preds: ^bb9, ^bb11
    %111 = llvm.icmp "slt" %110, %3 : i64
    llvm.cond_br %111, ^bb11, ^bb12
  ^bb11:  // pred: ^bb10
    %112 = llvm.extractvalue %101[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %113 = llvm.getelementptr %112[%110] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %113 : f64, !llvm.ptr
    %114 = llvm.add %110, %1 : i64
    llvm.br ^bb10(%114 : i64)
  ^bb12:  // pred: ^bb10
    %115 = llvm.mlir.constant(1 : index) : i64
    %116 = llvm.alloca %115 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %88, %116 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %117 = llvm.mlir.constant(1 : index) : i64
    %118 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %119 = llvm.insertvalue %117, %118[0] : !llvm.struct<(i64, ptr)> 
    %120 = llvm.insertvalue %116, %119[1] : !llvm.struct<(i64, ptr)> 
    %121 = llvm.extractvalue %120[0] : !llvm.struct<(i64, ptr)> 
    %122 = llvm.extractvalue %120[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_sanity_check(%121, %122) : (i64, !llvm.ptr) -> ()
    %123 = llvm.mlir.constant(17 : index) : i64
    %124 = llvm.mlir.constant(1 : index) : i64
    %125 = llvm.mlir.zero : !llvm.ptr
    %126 = llvm.getelementptr %125[%123] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %127 = llvm.ptrtoint %126 : !llvm.ptr to i64
    %128 = llvm.call @malloc(%127) : (i64) -> !llvm.ptr
    %129 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %130 = llvm.insertvalue %128, %129[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %131 = llvm.insertvalue %128, %130[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %132 = llvm.mlir.constant(0 : index) : i64
    %133 = llvm.insertvalue %132, %131[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %134 = llvm.insertvalue %123, %133[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %135 = llvm.insertvalue %124, %134[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %136 = llvm.mlir.constant(1 : index) : i64
    %137 = llvm.alloca %136 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %135, %137 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %138 = llvm.mlir.constant(1 : index) : i64
    %139 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %140 = llvm.insertvalue %138, %139[0] : !llvm.struct<(i64, ptr)> 
    %141 = llvm.insertvalue %137, %140[1] : !llvm.struct<(i64, ptr)> 
    %142 = llvm.extractvalue %88[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %143 = llvm.getelementptr %142[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %141, %143 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    llvm.br ^bb13(%0 : i64)
  ^bb13(%144: i64):  // 2 preds: ^bb12, ^bb14
    %145 = llvm.icmp "slt" %144, %3 : i64
    llvm.cond_br %145, ^bb14, ^bb15
  ^bb14:  // pred: ^bb13
    %146 = llvm.extractvalue %135[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %147 = llvm.getelementptr %146[%144] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %147 : f64, !llvm.ptr
    %148 = llvm.add %144, %1 : i64
    llvm.br ^bb13(%148 : i64)
  ^bb15:  // pred: ^bb13
    %149 = llvm.extractvalue %120[0] : !llvm.struct<(i64, ptr)> 
    %150 = llvm.extractvalue %120[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_sanity_check(%149, %150) : (i64, !llvm.ptr) -> ()
    llvm.return
  }
  llvm.func @comet_sanity_check(i64, !llvm.ptr) attributes {sym_visibility = "private"}
}
