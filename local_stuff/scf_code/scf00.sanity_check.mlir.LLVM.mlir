module {
  llvm.func @abort()
  llvm.func @puts(!llvm.ptr)
  llvm.mlir.global private constant @assert_msg(dense<[65, 119, 97, 105, 116, 101, 100, 32, 97, 115, 121, 110, 99, 32, 111, 112, 101, 114, 97, 110, 100, 32, 105, 115, 32, 105, 110, 32, 101, 114, 114, 111, 114, 32, 115, 116, 97, 116, 101, 0]> : tensor<40xi8>) {addr_space = 0 : i32} : !llvm.array<40 x i8>
  llvm.func @free(!llvm.ptr)
  llvm.func @aligned_alloc(i64, i64) -> !llvm.ptr
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @main() {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.constant(1 : index) : i64
    %2 = llvm.mlir.constant(17 : index) : i64
    %3 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %4 = llvm.mlir.constant(1.700000e+01 : f64) : f64
    %5 = llvm.mlir.constant(0 : i8) : i8
    %6 = llvm.mlir.constant(1 : i8) : i8
    %7 = llvm.mlir.constant(17 : i8) : i8
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.zero : !llvm.ptr
    %11 = llvm.getelementptr %10[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %12 = llvm.ptrtoint %11 : !llvm.ptr to i64
    %13 = llvm.mlir.zero : !llvm.ptr
    %14 = llvm.getelementptr %13[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %15 = llvm.ptrtoint %14 : !llvm.ptr to i64
    %16 = llvm.add %12, %15 : i64
    %17 = llvm.call @malloc(%16) : (i64) -> !llvm.ptr
    %18 = llvm.ptrtoint %17 : !llvm.ptr to i64
    %19 = llvm.mlir.constant(1 : index) : i64
    %20 = llvm.sub %15, %19 : i64
    %21 = llvm.add %18, %20 : i64
    %22 = llvm.urem %21, %15  : i64
    %23 = llvm.sub %21, %22 : i64
    %24 = llvm.inttoptr %23 : i64 to !llvm.ptr
    %25 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %26 = llvm.insertvalue %17, %25[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.insertvalue %24, %26[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %28 = llvm.mlir.constant(0 : index) : i64
    %29 = llvm.insertvalue %28, %27[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.insertvalue %8, %29[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %31 = llvm.insertvalue %9, %30[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %32 = llvm.mlir.constant(17 : index) : i64
    %33 = llvm.mlir.constant(1 : index) : i64
    %34 = llvm.mlir.zero : !llvm.ptr
    %35 = llvm.getelementptr %34[17] : (!llvm.ptr) -> !llvm.ptr, f64
    %36 = llvm.ptrtoint %35 : !llvm.ptr to i64
    %37 = llvm.call @malloc(%36) : (i64) -> !llvm.ptr
    %38 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %39 = llvm.insertvalue %37, %38[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %40 = llvm.insertvalue %37, %39[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.mlir.constant(0 : index) : i64
    %42 = llvm.insertvalue %41, %40[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %43 = llvm.insertvalue %32, %42[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %44 = llvm.insertvalue %33, %43[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %45 = llvm.mlir.constant(1 : index) : i64
    %46 = llvm.alloca %45 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %44, %46 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %47 = llvm.mlir.constant(1 : index) : i64
    %48 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %49 = llvm.insertvalue %47, %48[0] : !llvm.struct<(i64, ptr)> 
    %50 = llvm.insertvalue %46, %49[1] : !llvm.struct<(i64, ptr)> 
    %51 = llvm.getelementptr %24[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %50, %51 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    llvm.br ^bb1(%0 : i64)
  ^bb1(%52: i64):  // 2 preds: ^bb0, ^bb2
    %53 = llvm.icmp "slt" %52, %2 : i64
    llvm.cond_br %53, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %54 = llvm.getelementptr %37[%52] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %4, %54 : f64, !llvm.ptr
    %55 = llvm.add %52, %1 : i64
    llvm.br ^bb1(%55 : i64)
  ^bb3:  // pred: ^bb1
    %56 = llvm.mlir.constant(1 : index) : i64
    %57 = llvm.alloca %56 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %31, %57 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %58 = llvm.mlir.constant(1 : index) : i64
    %59 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %60 = llvm.insertvalue %58, %59[0] : !llvm.struct<(i64, ptr)> 
    %61 = llvm.insertvalue %57, %60[1] : !llvm.struct<(i64, ptr)> 
    %62 = llvm.extractvalue %61[0] : !llvm.struct<(i64, ptr)> 
    %63 = llvm.extractvalue %61[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%62, %63) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %64 = llvm.mlir.constant(17 : index) : i64
    %65 = llvm.mlir.constant(1 : index) : i64
    %66 = llvm.mlir.zero : !llvm.ptr
    %67 = llvm.getelementptr %66[17] : (!llvm.ptr) -> !llvm.ptr, f64
    %68 = llvm.ptrtoint %67 : !llvm.ptr to i64
    %69 = llvm.call @malloc(%68) : (i64) -> !llvm.ptr
    %70 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %71 = llvm.insertvalue %69, %70[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %72 = llvm.insertvalue %69, %71[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %73 = llvm.mlir.constant(0 : index) : i64
    %74 = llvm.insertvalue %73, %72[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %75 = llvm.insertvalue %64, %74[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %76 = llvm.insertvalue %65, %75[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %77 = llvm.mlir.constant(1 : index) : i64
    %78 = llvm.alloca %77 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %76, %78 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %79 = llvm.mlir.constant(1 : index) : i64
    %80 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %81 = llvm.insertvalue %79, %80[0] : !llvm.struct<(i64, ptr)> 
    %82 = llvm.insertvalue %78, %81[1] : !llvm.struct<(i64, ptr)> 
    %83 = llvm.getelementptr %24[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %82, %83 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    llvm.br ^bb4(%0 : i64)
  ^bb4(%84: i64):  // 2 preds: ^bb3, ^bb5
    %85 = llvm.icmp "slt" %84, %2 : i64
    llvm.cond_br %85, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %86 = llvm.getelementptr %69[%84] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %3, %86 : f64, !llvm.ptr
    %87 = llvm.add %84, %1 : i64
    llvm.br ^bb4(%87 : i64)
  ^bb6:  // pred: ^bb4
    %88 = llvm.extractvalue %61[0] : !llvm.struct<(i64, ptr)> 
    %89 = llvm.extractvalue %61[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%88, %89) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %90 = llvm.mlir.constant(1 : index) : i64
    %91 = llvm.mlir.constant(1 : index) : i64
    %92 = llvm.mlir.zero : !llvm.ptr
    %93 = llvm.getelementptr %92[1] : (!llvm.ptr) -> !llvm.ptr, i8
    %94 = llvm.ptrtoint %93 : !llvm.ptr to i64
    %95 = llvm.call @malloc(%94) : (i64) -> !llvm.ptr
    %96 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %97 = llvm.insertvalue %95, %96[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %98 = llvm.insertvalue %95, %97[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %99 = llvm.mlir.constant(0 : index) : i64
    %100 = llvm.insertvalue %99, %98[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %101 = llvm.insertvalue %90, %100[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %102 = llvm.insertvalue %91, %101[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %103 = llvm.getelementptr %95[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    llvm.store %5, %103 : i8, !llvm.ptr
    %104 = llvm.mlir.constant(1 : index) : i64
    %105 = llvm.alloca %104 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %102, %105 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %106 = llvm.mlir.constant(1 : index) : i64
    %107 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %108 = llvm.insertvalue %106, %107[0] : !llvm.struct<(i64, ptr)> 
    %109 = llvm.insertvalue %105, %108[1] : !llvm.struct<(i64, ptr)> 
    %110 = llvm.getelementptr %95[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %111 = llvm.load %110 : !llvm.ptr -> i8
    %112 = llvm.zext %111 : i8 to i64
    llvm.call @printI64(%112) : (i64) -> ()
    llvm.call @printNewline() : () -> ()
    %113 = llvm.extractvalue %109[0] : !llvm.struct<(i64, ptr)> 
    %114 = llvm.extractvalue %109[1] : !llvm.struct<(i64, ptr)> 
    %115 = llvm.call @comet_atomic_load_n_i8(%113, %114) : (i64, !llvm.ptr) -> i8
    %116 = llvm.zext %115 : i8 to i64
    llvm.call @printI64(%116) : (i64) -> ()
    llvm.call @printNewline() : () -> ()
    %117 = llvm.extractvalue %109[0] : !llvm.struct<(i64, ptr)> 
    %118 = llvm.extractvalue %109[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_atomic_store_n_i8(%117, %118, %7) : (i64, !llvm.ptr, i8) -> ()
    %119 = llvm.getelementptr %95[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %120 = llvm.load %119 : !llvm.ptr -> i8
    %121 = llvm.zext %120 : i8 to i64
    llvm.call @printI64(%121) : (i64) -> ()
    llvm.call @printNewline() : () -> ()
    llvm.call @printNewline() : () -> ()
    %122 = llvm.mlir.constant(1 : index) : i64
    %123 = llvm.mlir.constant(1 : index) : i64
    %124 = llvm.mlir.zero : !llvm.ptr
    %125 = llvm.getelementptr %124[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %126 = llvm.ptrtoint %125 : !llvm.ptr to i64
    %127 = llvm.mlir.zero : !llvm.ptr
    %128 = llvm.getelementptr %127[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %129 = llvm.ptrtoint %128 : !llvm.ptr to i64
    %130 = llvm.add %126, %129 : i64
    %131 = llvm.call @malloc(%130) : (i64) -> !llvm.ptr
    %132 = llvm.ptrtoint %131 : !llvm.ptr to i64
    %133 = llvm.mlir.constant(1 : index) : i64
    %134 = llvm.sub %129, %133 : i64
    %135 = llvm.add %132, %134 : i64
    %136 = llvm.urem %135, %129  : i64
    %137 = llvm.sub %135, %136 : i64
    %138 = llvm.inttoptr %137 : i64 to !llvm.ptr
    %139 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %140 = llvm.insertvalue %131, %139[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %141 = llvm.insertvalue %138, %140[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %142 = llvm.mlir.constant(0 : index) : i64
    %143 = llvm.insertvalue %142, %141[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %144 = llvm.insertvalue %122, %143[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %145 = llvm.insertvalue %123, %144[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %146 = llvm.getelementptr %138[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %50, %146 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    %147 = llvm.mlir.constant(1 : index) : i64
    %148 = llvm.mlir.constant(1 : index) : i64
    %149 = llvm.mlir.zero : !llvm.ptr
    %150 = llvm.getelementptr %149[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %151 = llvm.ptrtoint %150 : !llvm.ptr to i64
    %152 = llvm.mlir.zero : !llvm.ptr
    %153 = llvm.getelementptr %152[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %154 = llvm.ptrtoint %153 : !llvm.ptr to i64
    %155 = llvm.add %151, %154 : i64
    %156 = llvm.call @malloc(%155) : (i64) -> !llvm.ptr
    %157 = llvm.ptrtoint %156 : !llvm.ptr to i64
    %158 = llvm.mlir.constant(1 : index) : i64
    %159 = llvm.sub %154, %158 : i64
    %160 = llvm.add %157, %159 : i64
    %161 = llvm.urem %160, %154  : i64
    %162 = llvm.sub %160, %161 : i64
    %163 = llvm.inttoptr %162 : i64 to !llvm.ptr
    %164 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %165 = llvm.insertvalue %156, %164[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %166 = llvm.insertvalue %163, %165[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %167 = llvm.mlir.constant(0 : index) : i64
    %168 = llvm.insertvalue %167, %166[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %169 = llvm.insertvalue %147, %168[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %170 = llvm.insertvalue %148, %169[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %171 = llvm.getelementptr %163[%0] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %82, %171 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    %172 = llvm.mlir.constant(1 : index) : i64
    %173 = llvm.alloca %172 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %145, %173 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %174 = llvm.mlir.constant(1 : index) : i64
    %175 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %176 = llvm.insertvalue %174, %175[0] : !llvm.struct<(i64, ptr)> 
    %177 = llvm.insertvalue %173, %176[1] : !llvm.struct<(i64, ptr)> 
    %178 = llvm.mlir.constant(1 : index) : i64
    %179 = llvm.alloca %178 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %170, %179 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %180 = llvm.mlir.constant(1 : index) : i64
    %181 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %182 = llvm.insertvalue %180, %181[0] : !llvm.struct<(i64, ptr)> 
    %183 = llvm.insertvalue %179, %182[1] : !llvm.struct<(i64, ptr)> 
    %184 = llvm.extractvalue %177[0] : !llvm.struct<(i64, ptr)> 
    %185 = llvm.extractvalue %177[1] : !llvm.struct<(i64, ptr)> 
    %186 = llvm.extractvalue %183[0] : !llvm.struct<(i64, ptr)> 
    %187 = llvm.extractvalue %183[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_swap_buffers(%184, %185, %186, %187) : (i64, !llvm.ptr, i64, !llvm.ptr) -> ()
    %188 = llvm.extractvalue %177[0] : !llvm.struct<(i64, ptr)> 
    %189 = llvm.extractvalue %177[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%188, %189) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %190 = llvm.extractvalue %183[0] : !llvm.struct<(i64, ptr)> 
    %191 = llvm.extractvalue %183[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%190, %191) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %192 = llvm.mlir.constant(1 : index) : i64
    %193 = llvm.mlir.constant(1 : index) : i64
    %194 = llvm.mlir.zero : !llvm.ptr
    %195 = llvm.getelementptr %194[1] : (!llvm.ptr) -> !llvm.ptr, i8
    %196 = llvm.ptrtoint %195 : !llvm.ptr to i64
    %197 = llvm.call @malloc(%196) : (i64) -> !llvm.ptr
    %198 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %199 = llvm.insertvalue %197, %198[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %200 = llvm.insertvalue %197, %199[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %201 = llvm.mlir.constant(0 : index) : i64
    %202 = llvm.insertvalue %201, %200[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %203 = llvm.insertvalue %192, %202[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %204 = llvm.insertvalue %193, %203[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %205 = llvm.getelementptr %197[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    llvm.store %5, %205 : i8, !llvm.ptr
    %206 = llvm.mlir.constant(1 : index) : i64
    %207 = llvm.alloca %206 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %204, %207 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %208 = llvm.mlir.constant(1 : index) : i64
    %209 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %210 = llvm.insertvalue %208, %209[0] : !llvm.struct<(i64, ptr)> 
    %211 = llvm.insertvalue %207, %210[1] : !llvm.struct<(i64, ptr)> 
    %212 = llvm.getelementptr %197[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %213 = llvm.load %212 : !llvm.ptr -> i8
    %214 = llvm.zext %213 : i8 to i64
    llvm.call @printI64(%214) : (i64) -> ()
    llvm.call @printComma() : () -> ()
    llvm.call @printNewline() : () -> ()
    %215 = llvm.extractvalue %177[0] : !llvm.struct<(i64, ptr)> 
    %216 = llvm.extractvalue %177[1] : !llvm.struct<(i64, ptr)> 
    %217 = llvm.extractvalue %211[0] : !llvm.struct<(i64, ptr)> 
    %218 = llvm.extractvalue %211[1] : !llvm.struct<(i64, ptr)> 
    %219 = llvm.call @async_execute_fn(%215, %216, %217, %218) : (i64, !llvm.ptr, i64, !llvm.ptr) -> !llvm.ptr
    %220 = llvm.getelementptr %197[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %221 = llvm.load %220 : !llvm.ptr -> i8
    llvm.br ^bb7(%221 : i8)
  ^bb7(%222: i8):  // 2 preds: ^bb6, ^bb8
    %223 = llvm.icmp "eq" %222, %6 : i8
    llvm.cond_br %223, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    %224 = llvm.extractvalue %211[0] : !llvm.struct<(i64, ptr)> 
    %225 = llvm.extractvalue %211[1] : !llvm.struct<(i64, ptr)> 
    %226 = llvm.call @comet_atomic_load_n_i8(%224, %225) : (i64, !llvm.ptr) -> i8
    llvm.call @printComma() : () -> ()
    llvm.call @printNewline() : () -> ()
    llvm.br ^bb7(%226 : i8)
  ^bb9:  // pred: ^bb7
    %227 = llvm.extractvalue %177[0] : !llvm.struct<(i64, ptr)> 
    %228 = llvm.extractvalue %177[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_memref_to_memref_f64(%227, %228) : (i64, !llvm.ptr) -> ()
    llvm.call @printNewline() : () -> ()
    %229 = llvm.extractvalue %211[0] : !llvm.struct<(i64, ptr)> 
    %230 = llvm.extractvalue %211[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_atomic_store_n_i8(%229, %230, %6) : (i64, !llvm.ptr, i8) -> ()
    %231 = llvm.getelementptr %197[%0] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %232 = llvm.load %231 : !llvm.ptr -> i8
    %233 = llvm.zext %232 : i8 to i64
    llvm.call @printI64(%233) : (i64) -> ()
    llvm.call @printComma() : () -> ()
    llvm.call @printNewline() : () -> ()
    llvm.call @mlirAsyncRuntimeAwaitToken(%219) : (!llvm.ptr) -> ()
    %234 = llvm.call @mlirAsyncRuntimeIsTokenError(%219) : (!llvm.ptr) -> i1
    %235 = llvm.mlir.constant(1 : i64) : i64
    llvm.call @mlirAsyncRuntimeDropRef(%219, %235) : (!llvm.ptr, i64) -> ()
    %236 = llvm.mlir.constant(true) : i1
    %237 = llvm.xor %234, %236  : i1
    llvm.cond_br %237, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    llvm.return
  ^bb11:  // pred: ^bb9
    %238 = llvm.mlir.addressof @assert_msg : !llvm.ptr
    %239 = llvm.getelementptr %238[0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<40 x i8>
    llvm.call @puts(%239) : (!llvm.ptr) -> ()
    llvm.call @abort() : () -> ()
    llvm.unreachable
  }
  llvm.func @comet_print_memref_to_memref_f64(i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @comet_atomic_load_n_i8(i64, !llvm.ptr) -> i8 attributes {sym_visibility = "private"}
  llvm.func @comet_atomic_store_n_i8(i64, !llvm.ptr, i8) attributes {sym_visibility = "private"}
  llvm.func @comet_swap_buffers(i64, !llvm.ptr, i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @comet_initialize_test_thread(i64, !llvm.ptr, i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @comet_async_background_thread_test(i64, !llvm.ptr, i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @printI64(i64) attributes {sym_visibility = "private"}
  llvm.func @printF64(f64) attributes {sym_visibility = "private"}
  llvm.func @printComma() attributes {sym_visibility = "private"}
  llvm.func @printNewline() attributes {sym_visibility = "private"}
  llvm.func @async_execute_fn(%arg0: i64, %arg1: !llvm.ptr, %arg2: i64, %arg3: !llvm.ptr) -> !llvm.ptr attributes {passthrough = ["presplitcoroutine"], sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %1 = llvm.insertvalue %arg2, %0[0] : !llvm.struct<(i64, ptr)> 
    %2 = llvm.insertvalue %arg3, %1[1] : !llvm.struct<(i64, ptr)> 
    %3 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %4 = llvm.insertvalue %arg0, %3[0] : !llvm.struct<(i64, ptr)> 
    %5 = llvm.insertvalue %arg1, %4[1] : !llvm.struct<(i64, ptr)> 
    %6 = llvm.call @mlirAsyncRuntimeCreateToken() : () -> !llvm.ptr
    %7 = llvm.mlir.constant(0 : i32) : i32
    %8 = llvm.mlir.zero : !llvm.ptr
    %9 = llvm.intr.coro.id %7, %8, %8, %8 : (i32, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.token
    %10 = llvm.intr.coro.size : i64
    %11 = llvm.intr.coro.align : i64
    %12 = llvm.add %10, %11 : i64
    %13 = llvm.mlir.constant(1 : i64) : i64
    %14 = llvm.sub %12, %13 : i64
    %15 = llvm.mlir.constant(0 : i64) : i64
    %16 = llvm.sub %15, %11 : i64
    %17 = llvm.and %14, %16  : i64
    %18 = llvm.call @aligned_alloc(%11, %17) : (i64, i64) -> !llvm.ptr
    %19 = llvm.intr.coro.begin %9, %18 : (!llvm.token, !llvm.ptr) -> !llvm.ptr
    %20 = llvm.intr.coro.save %19 : (!llvm.ptr) -> !llvm.token
    %21 = llvm.mlir.addressof @__resume : !llvm.ptr
    llvm.call @mlirAsyncRuntimeExecute(%19, %21) : (!llvm.ptr, !llvm.ptr) -> ()
    %22 = llvm.mlir.constant(false) : i1
    %23 = llvm.intr.coro.suspend %20, %22 : i8
    %24 = llvm.sext %23 : i8 to i32
    llvm.switch %24 : i32, ^bb4 [
      0: ^bb1,
      1: ^bb3
    ]
  ^bb1:  // pred: ^bb0
    %25 = llvm.extractvalue %5[0] : !llvm.struct<(i64, ptr)> 
    %26 = llvm.extractvalue %5[1] : !llvm.struct<(i64, ptr)> 
    %27 = llvm.extractvalue %2[0] : !llvm.struct<(i64, ptr)> 
    %28 = llvm.extractvalue %2[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_async_background_thread_test(%25, %26, %27, %28) : (i64, !llvm.ptr, i64, !llvm.ptr) -> ()
    llvm.call @mlirAsyncRuntimeEmplaceToken(%6) : (!llvm.ptr) -> ()
    llvm.br ^bb2
  ^bb2:  // pred: ^bb1
    %29 = llvm.intr.coro.free %9, %19 : (!llvm.token, !llvm.ptr) -> !llvm.ptr
    llvm.call @free(%29) : (!llvm.ptr) -> ()
    llvm.br ^bb4
  ^bb3:  // pred: ^bb0
    %30 = llvm.intr.coro.free %9, %19 : (!llvm.token, !llvm.ptr) -> !llvm.ptr
    llvm.call @free(%30) : (!llvm.ptr) -> ()
    llvm.br ^bb4
  ^bb4:  // 3 preds: ^bb0, ^bb2, ^bb3
    %31 = llvm.mlir.constant(false) : i1
    %32 = llvm.mlir.none : !llvm.token
    %33 = llvm.intr.coro.end %19, %31, %32 : (!llvm.ptr, i1, !llvm.token) -> i1
    llvm.return %6 : !llvm.ptr
  }
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
  llvm.func @__resume(%arg0: !llvm.ptr) attributes {sym_visibility = "private"} {
    llvm.intr.coro.resume %arg0 : !llvm.ptr
    llvm.return
  }
}
