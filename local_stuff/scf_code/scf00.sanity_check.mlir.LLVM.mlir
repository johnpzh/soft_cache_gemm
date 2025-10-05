module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @main() {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(17 : index) : i64
    %3 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %4 = llvm.mlir.constant(1.700000e+01 : f64) : f64
    %5 = llvm.mlir.constant(0 : i8) : i8
    %6 = llvm.mlir.constant(17 : i8) : i8
    %7 = llvm.mlir.constant(1 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.zero : !llvm.ptr
    %10 = llvm.getelementptr %9[%7] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %11 = llvm.ptrtoint %10 : !llvm.ptr to i64
    %12 = llvm.mlir.zero : !llvm.ptr
    %13 = llvm.getelementptr %12[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
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
    %31 = llvm.mlir.constant(17 : index) : i64
    %32 = llvm.mlir.constant(1 : index) : i64
    %33 = llvm.mlir.zero : !llvm.ptr
    %34 = llvm.getelementptr %33[%31] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %35 = llvm.ptrtoint %34 : !llvm.ptr to i64
    %36 = llvm.call @malloc(%35) : (i64) -> !llvm.ptr
    %37 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %38 = llvm.insertvalue %36, %37[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %39 = llvm.insertvalue %36, %38[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %40 = llvm.mlir.constant(0 : index) : i64
    %41 = llvm.insertvalue %40, %39[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %42 = llvm.insertvalue %31, %41[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %43 = llvm.insertvalue %32, %42[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %44 = llvm.mlir.constant(1 : index) : i64
    %45 = llvm.alloca %44 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %43, %45 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %46 = llvm.mlir.constant(1 : index) : i64
    %47 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %48 = llvm.insertvalue %46, %47[0] : !llvm.struct<(i64, ptr)> 
    %49 = llvm.insertvalue %45, %48[1] : !llvm.struct<(i64, ptr)> 
    %50 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.getelementptr %50[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %49, %51 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    llvm.br ^bb1(%0 : i64)
  ^bb1(%52: i64):  // 2 preds: ^bb0, ^bb2
    %53 = llvm.icmp "slt" %52, %2 : i64
    llvm.cond_br %53, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %54 = llvm.extractvalue %43[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %55 = llvm.getelementptr %54[%52] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %4, %55 : f64, !llvm.ptr
    %56 = llvm.add %52, %1 : i64
    llvm.br ^bb1(%56 : i64)
  ^bb3:  // pred: ^bb1
    %57 = llvm.mlir.constant(1 : index) : i64
    %58 = llvm.alloca %57 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %30, %58 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %59 = llvm.mlir.constant(1 : index) : i64
    %60 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %61 = llvm.insertvalue %59, %60[0] : !llvm.struct<(i64, ptr)> 
    %62 = llvm.insertvalue %58, %61[1] : !llvm.struct<(i64, ptr)> 
    %63 = llvm.extractvalue %62[0] : !llvm.struct<(i64, ptr)> 
    %64 = llvm.extractvalue %62[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%63, %64) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %65 = llvm.mlir.constant(17 : index) : i64
    %66 = llvm.mlir.constant(1 : index) : i64
    %67 = llvm.mlir.zero : !llvm.ptr
    %68 = llvm.getelementptr %67[%65] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %69 = llvm.ptrtoint %68 : !llvm.ptr to i64
    %70 = llvm.call @malloc(%69) : (i64) -> !llvm.ptr
    %71 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %72 = llvm.insertvalue %70, %71[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %73 = llvm.insertvalue %70, %72[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %74 = llvm.mlir.constant(0 : index) : i64
    %75 = llvm.insertvalue %74, %73[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %76 = llvm.insertvalue %65, %75[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %77 = llvm.insertvalue %66, %76[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %78 = llvm.mlir.constant(1 : index) : i64
    %79 = llvm.alloca %78 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %77, %79 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %80 = llvm.mlir.constant(1 : index) : i64
    %81 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %82 = llvm.insertvalue %80, %81[0] : !llvm.struct<(i64, ptr)> 
    %83 = llvm.insertvalue %79, %82[1] : !llvm.struct<(i64, ptr)> 
    %84 = llvm.extractvalue %30[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %85 = llvm.getelementptr %84[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %83, %85 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    llvm.br ^bb4(%0 : i64)
  ^bb4(%86: i64):  // 2 preds: ^bb3, ^bb5
    %87 = llvm.icmp "slt" %86, %2 : i64
    llvm.cond_br %87, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %88 = llvm.extractvalue %77[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %89 = llvm.getelementptr %88[%86] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %3, %89 : f64, !llvm.ptr
    %90 = llvm.add %86, %1 : i64
    llvm.br ^bb4(%90 : i64)
  ^bb6:  // pred: ^bb4
    %91 = llvm.extractvalue %62[0] : !llvm.struct<(i64, ptr)> 
    %92 = llvm.extractvalue %62[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%91, %92) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %93 = llvm.mlir.constant(1 : index) : i64
    %94 = llvm.mlir.constant(1 : index) : i64
    %95 = llvm.mlir.zero : !llvm.ptr
    %96 = llvm.getelementptr %95[%93] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %97 = llvm.ptrtoint %96 : !llvm.ptr to i64
    %98 = llvm.call @malloc(%97) : (i64) -> !llvm.ptr
    %99 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %100 = llvm.insertvalue %98, %99[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %101 = llvm.insertvalue %98, %100[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %102 = llvm.mlir.constant(0 : index) : i64
    %103 = llvm.insertvalue %102, %101[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %104 = llvm.insertvalue %93, %103[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %105 = llvm.insertvalue %94, %104[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %106 = llvm.extractvalue %105[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %107 = llvm.getelementptr %106[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    llvm.store %5, %107 : i8, !llvm.ptr
    %108 = llvm.mlir.constant(1 : index) : i64
    %109 = llvm.alloca %108 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %105, %109 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %110 = llvm.mlir.constant(1 : index) : i64
    %111 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %112 = llvm.insertvalue %110, %111[0] : !llvm.struct<(i64, ptr)> 
    %113 = llvm.insertvalue %109, %112[1] : !llvm.struct<(i64, ptr)> 
    %114 = llvm.extractvalue %105[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %115 = llvm.getelementptr %114[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %116 = llvm.load %115 : !llvm.ptr -> i8
    %117 = llvm.zext %116 : i8 to i64
    llvm.call @printI64(%117) : (i64) -> ()
    llvm.call @printNewline() : () -> ()
    %118 = llvm.extractvalue %113[0] : !llvm.struct<(i64, ptr)> 
    %119 = llvm.extractvalue %113[1] : !llvm.struct<(i64, ptr)> 
    %120 = llvm.call @comet_atomic_load_n_i8(%118, %119) : (i64, !llvm.ptr) -> i8
    %121 = llvm.zext %120 : i8 to i64
    llvm.call @printI64(%121) : (i64) -> ()
    llvm.call @printNewline() : () -> ()
    %122 = llvm.extractvalue %113[0] : !llvm.struct<(i64, ptr)> 
    %123 = llvm.extractvalue %113[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_atomic_store_n_i8(%122, %123, %6) : (i64, !llvm.ptr, i8) -> ()
    %124 = llvm.extractvalue %105[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %125 = llvm.getelementptr %124[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %126 = llvm.load %125 : !llvm.ptr -> i8
    %127 = llvm.zext %126 : i8 to i64
    llvm.call @printI64(%127) : (i64) -> ()
    llvm.call @printNewline() : () -> ()
    llvm.call @printNewline() : () -> ()
    %128 = llvm.mlir.constant(1 : index) : i64
    %129 = llvm.mlir.constant(1 : index) : i64
    %130 = llvm.mlir.zero : !llvm.ptr
    %131 = llvm.getelementptr %130[%128] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %132 = llvm.ptrtoint %131 : !llvm.ptr to i64
    %133 = llvm.mlir.zero : !llvm.ptr
    %134 = llvm.getelementptr %133[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %135 = llvm.ptrtoint %134 : !llvm.ptr to i64
    %136 = llvm.add %132, %135 : i64
    %137 = llvm.call @malloc(%136) : (i64) -> !llvm.ptr
    %138 = llvm.ptrtoint %137 : !llvm.ptr to i64
    %139 = llvm.mlir.constant(1 : index) : i64
    %140 = llvm.sub %135, %139 : i64
    %141 = llvm.add %138, %140 : i64
    %142 = llvm.urem %141, %135  : i64
    %143 = llvm.sub %141, %142 : i64
    %144 = llvm.inttoptr %143 : i64 to !llvm.ptr
    %145 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %146 = llvm.insertvalue %137, %145[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %147 = llvm.insertvalue %144, %146[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %148 = llvm.mlir.constant(0 : index) : i64
    %149 = llvm.insertvalue %148, %147[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %150 = llvm.insertvalue %128, %149[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %151 = llvm.insertvalue %129, %150[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %152 = llvm.extractvalue %151[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %153 = llvm.getelementptr %152[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %49, %153 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    %154 = llvm.mlir.constant(1 : index) : i64
    %155 = llvm.mlir.constant(1 : index) : i64
    %156 = llvm.mlir.zero : !llvm.ptr
    %157 = llvm.getelementptr %156[%154] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %158 = llvm.ptrtoint %157 : !llvm.ptr to i64
    %159 = llvm.mlir.zero : !llvm.ptr
    %160 = llvm.getelementptr %159[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %161 = llvm.ptrtoint %160 : !llvm.ptr to i64
    %162 = llvm.add %158, %161 : i64
    %163 = llvm.call @malloc(%162) : (i64) -> !llvm.ptr
    %164 = llvm.ptrtoint %163 : !llvm.ptr to i64
    %165 = llvm.mlir.constant(1 : index) : i64
    %166 = llvm.sub %161, %165 : i64
    %167 = llvm.add %164, %166 : i64
    %168 = llvm.urem %167, %161  : i64
    %169 = llvm.sub %167, %168 : i64
    %170 = llvm.inttoptr %169 : i64 to !llvm.ptr
    %171 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %172 = llvm.insertvalue %163, %171[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %173 = llvm.insertvalue %170, %172[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %174 = llvm.mlir.constant(0 : index) : i64
    %175 = llvm.insertvalue %174, %173[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %176 = llvm.insertvalue %154, %175[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %177 = llvm.insertvalue %155, %176[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %178 = llvm.extractvalue %177[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %179 = llvm.getelementptr %178[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %83, %179 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    %180 = llvm.mlir.constant(1 : index) : i64
    %181 = llvm.alloca %180 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %151, %181 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %182 = llvm.mlir.constant(1 : index) : i64
    %183 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %184 = llvm.insertvalue %182, %183[0] : !llvm.struct<(i64, ptr)> 
    %185 = llvm.insertvalue %181, %184[1] : !llvm.struct<(i64, ptr)> 
    %186 = llvm.mlir.constant(1 : index) : i64
    %187 = llvm.alloca %186 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %177, %187 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %188 = llvm.mlir.constant(1 : index) : i64
    %189 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %190 = llvm.insertvalue %188, %189[0] : !llvm.struct<(i64, ptr)> 
    %191 = llvm.insertvalue %187, %190[1] : !llvm.struct<(i64, ptr)> 
    %192 = llvm.extractvalue %185[0] : !llvm.struct<(i64, ptr)> 
    %193 = llvm.extractvalue %185[1] : !llvm.struct<(i64, ptr)> 
    %194 = llvm.extractvalue %191[0] : !llvm.struct<(i64, ptr)> 
    %195 = llvm.extractvalue %191[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_swap_buffers(%192, %193, %194, %195) : (i64, !llvm.ptr, i64, !llvm.ptr) -> ()
    %196 = llvm.extractvalue %185[0] : !llvm.struct<(i64, ptr)> 
    %197 = llvm.extractvalue %185[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%196, %197) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %198 = llvm.extractvalue %191[0] : !llvm.struct<(i64, ptr)> 
    %199 = llvm.extractvalue %191[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%198, %199) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %200 = llvm.extractvalue %185[0] : !llvm.struct<(i64, ptr)> 
    %201 = llvm.extractvalue %185[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_initialize_double_buffer_thread(%200, %201) : (i64, !llvm.ptr) -> ()
    %202 = llvm.extractvalue %185[0] : !llvm.struct<(i64, ptr)> 
    %203 = llvm.extractvalue %185[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%202, %203) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    llvm.return
  }
  llvm.func @comet_print_memref_to_memref_f64(i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @comet_atomic_load_n_i8(i64, !llvm.ptr) -> i8 attributes {sym_visibility = "private"}
  llvm.func @comet_atomic_store_n_i8(i64, !llvm.ptr, i8) attributes {sym_visibility = "private"}
  llvm.func @comet_swap_buffers(i64, !llvm.ptr, i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @comet_initialize_double_buffer_thread(i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @printI64(i64) attributes {sym_visibility = "private"}
  llvm.func @printF64(f64) attributes {sym_visibility = "private"}
  llvm.func @printNewline() attributes {sym_visibility = "private"}
}
