module {
  llvm.func @abort()
  llvm.func @puts(!llvm.ptr)
  llvm.mlir.global private constant @assert_msg(dense<[65, 119, 97, 105, 116, 101, 100, 32, 97, 115, 121, 110, 99, 32, 111, 112, 101, 114, 97, 110, 100, 32, 105, 115, 32, 105, 110, 32, 101, 114, 114, 111, 114, 32, 115, 116, 97, 116, 101, 0]> : tensor<40xi8>) {addr_space = 0 : i32} : !llvm.array<40 x i8>
  llvm.func @aligned_alloc(i64, i64) -> !llvm.ptr
  llvm.func @free(!llvm.ptr)
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @pp_index(%arg0: i64) {
    llvm.call @printI64(%arg0) : (i64) -> ()
    llvm.call @printComma() : () -> ()
    llvm.return
  }
  llvm.func @main() {
    %0 = llvm.mlir.constant(2 : i64) : i64
    %1 = llvm.mlir.constant(5 : i64) : i64
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.constant(2 : index) : i64
    %5 = llvm.mlir.constant(0.000000e+00 : f64) : f64
    %6 = llvm.mlir.constant(1.100000e+00 : f64) : f64
    %7 = llvm.mlir.constant(2.200000e+00 : f64) : f64
    %8 = llvm.mlir.constant(0 : i8) : i8
    %9 = llvm.mlir.constant(5 : index) : i64
    %10 = llvm.mlir.constant(25 : index) : i64
    %11 = llvm.call @getTime() : () -> f64
    %12 = llvm.mlir.constant(25 : index) : i64
    %13 = llvm.mlir.constant(1 : index) : i64
    %14 = llvm.mlir.zero : !llvm.ptr
    %15 = llvm.getelementptr %14[25] : (!llvm.ptr) -> !llvm.ptr, f64
    %16 = llvm.ptrtoint %15 : !llvm.ptr to i64
    %17 = llvm.call @malloc(%16) : (i64) -> !llvm.ptr
    %18 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %19 = llvm.insertvalue %17, %18[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.insertvalue %17, %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %21 = llvm.mlir.constant(0 : index) : i64
    %22 = llvm.insertvalue %21, %20[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.insertvalue %12, %22[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.insertvalue %13, %23[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %25 = llvm.mlir.constant(25 : index) : i64
    %26 = llvm.mlir.constant(1 : index) : i64
    %27 = llvm.mlir.zero : !llvm.ptr
    %28 = llvm.getelementptr %27[25] : (!llvm.ptr) -> !llvm.ptr, f64
    %29 = llvm.ptrtoint %28 : !llvm.ptr to i64
    %30 = llvm.call @malloc(%29) : (i64) -> !llvm.ptr
    %31 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %32 = llvm.insertvalue %30, %31[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %33 = llvm.insertvalue %30, %32[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %34 = llvm.mlir.constant(0 : index) : i64
    %35 = llvm.insertvalue %34, %33[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %36 = llvm.insertvalue %25, %35[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %37 = llvm.insertvalue %26, %36[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.mlir.constant(25 : index) : i64
    %39 = llvm.mlir.constant(1 : index) : i64
    %40 = llvm.mlir.zero : !llvm.ptr
    %41 = llvm.getelementptr %40[25] : (!llvm.ptr) -> !llvm.ptr, f64
    %42 = llvm.ptrtoint %41 : !llvm.ptr to i64
    %43 = llvm.call @malloc(%42) : (i64) -> !llvm.ptr
    %44 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %45 = llvm.insertvalue %43, %44[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %46 = llvm.insertvalue %43, %45[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %47 = llvm.mlir.constant(0 : index) : i64
    %48 = llvm.insertvalue %47, %46[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %49 = llvm.insertvalue %38, %48[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %50 = llvm.insertvalue %39, %49[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb1(%2 : i64)
  ^bb1(%51: i64):  // 2 preds: ^bb0, ^bb2
    %52 = llvm.icmp "slt" %51, %10 : i64
    llvm.cond_br %52, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %53 = llvm.getelementptr %17[%51] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %6, %53 : f64, !llvm.ptr
    %54 = llvm.add %51, %3 : i64
    llvm.br ^bb1(%54 : i64)
  ^bb3:  // pred: ^bb1
    llvm.br ^bb4(%2 : i64)
  ^bb4(%55: i64):  // 2 preds: ^bb3, ^bb5
    %56 = llvm.icmp "slt" %55, %10 : i64
    llvm.cond_br %56, ^bb5, ^bb6
  ^bb5:  // pred: ^bb4
    %57 = llvm.getelementptr %30[%55] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %7, %57 : f64, !llvm.ptr
    %58 = llvm.add %55, %3 : i64
    llvm.br ^bb4(%58 : i64)
  ^bb6:  // pred: ^bb4
    llvm.br ^bb7(%2 : i64)
  ^bb7(%59: i64):  // 2 preds: ^bb6, ^bb8
    %60 = llvm.icmp "slt" %59, %10 : i64
    llvm.cond_br %60, ^bb8, ^bb9
  ^bb8:  // pred: ^bb7
    %61 = llvm.getelementptr %43[%59] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %5, %61 : f64, !llvm.ptr
    %62 = llvm.add %59, %3 : i64
    llvm.br ^bb7(%62 : i64)
  ^bb9:  // pred: ^bb7
    %63 = llvm.mlir.constant(1 : index) : i64
    %64 = llvm.mlir.constant(1 : index) : i64
    %65 = llvm.mlir.zero : !llvm.ptr
    %66 = llvm.getelementptr %65[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %67 = llvm.ptrtoint %66 : !llvm.ptr to i64
    %68 = llvm.mlir.zero : !llvm.ptr
    %69 = llvm.getelementptr %68[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %70 = llvm.ptrtoint %69 : !llvm.ptr to i64
    %71 = llvm.add %67, %70 : i64
    %72 = llvm.call @malloc(%71) : (i64) -> !llvm.ptr
    %73 = llvm.ptrtoint %72 : !llvm.ptr to i64
    %74 = llvm.mlir.constant(1 : index) : i64
    %75 = llvm.sub %70, %74 : i64
    %76 = llvm.add %73, %75 : i64
    %77 = llvm.urem %76, %70  : i64
    %78 = llvm.sub %76, %77 : i64
    %79 = llvm.inttoptr %78 : i64 to !llvm.ptr
    %80 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %81 = llvm.insertvalue %72, %80[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %82 = llvm.insertvalue %79, %81[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %83 = llvm.mlir.constant(0 : index) : i64
    %84 = llvm.insertvalue %83, %82[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %85 = llvm.insertvalue %63, %84[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %86 = llvm.insertvalue %64, %85[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %87 = llvm.mlir.constant(4 : index) : i64
    %88 = llvm.mlir.constant(1 : index) : i64
    %89 = llvm.mlir.zero : !llvm.ptr
    %90 = llvm.getelementptr %89[4] : (!llvm.ptr) -> !llvm.ptr, f64
    %91 = llvm.ptrtoint %90 : !llvm.ptr to i64
    %92 = llvm.call @malloc(%91) : (i64) -> !llvm.ptr
    %93 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %94 = llvm.insertvalue %92, %93[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %95 = llvm.insertvalue %92, %94[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %96 = llvm.mlir.constant(0 : index) : i64
    %97 = llvm.insertvalue %96, %95[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %98 = llvm.insertvalue %87, %97[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %99 = llvm.insertvalue %88, %98[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %100 = llvm.mlir.constant(1 : index) : i64
    %101 = llvm.alloca %100 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %99, %101 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %102 = llvm.mlir.constant(1 : index) : i64
    %103 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %104 = llvm.insertvalue %102, %103[0] : !llvm.struct<(i64, ptr)> 
    %105 = llvm.insertvalue %101, %104[1] : !llvm.struct<(i64, ptr)> 
    %106 = llvm.getelementptr %79[%2] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %105, %106 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    %107 = llvm.mlir.constant(1 : index) : i64
    %108 = llvm.mlir.constant(1 : index) : i64
    %109 = llvm.mlir.zero : !llvm.ptr
    %110 = llvm.getelementptr %109[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %111 = llvm.ptrtoint %110 : !llvm.ptr to i64
    %112 = llvm.mlir.zero : !llvm.ptr
    %113 = llvm.getelementptr %112[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %114 = llvm.ptrtoint %113 : !llvm.ptr to i64
    %115 = llvm.add %111, %114 : i64
    %116 = llvm.call @malloc(%115) : (i64) -> !llvm.ptr
    %117 = llvm.ptrtoint %116 : !llvm.ptr to i64
    %118 = llvm.mlir.constant(1 : index) : i64
    %119 = llvm.sub %114, %118 : i64
    %120 = llvm.add %117, %119 : i64
    %121 = llvm.urem %120, %114  : i64
    %122 = llvm.sub %120, %121 : i64
    %123 = llvm.inttoptr %122 : i64 to !llvm.ptr
    %124 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %125 = llvm.insertvalue %116, %124[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %126 = llvm.insertvalue %123, %125[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %127 = llvm.mlir.constant(0 : index) : i64
    %128 = llvm.insertvalue %127, %126[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %129 = llvm.insertvalue %107, %128[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %130 = llvm.insertvalue %108, %129[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %131 = llvm.mlir.constant(4 : index) : i64
    %132 = llvm.mlir.constant(1 : index) : i64
    %133 = llvm.mlir.zero : !llvm.ptr
    %134 = llvm.getelementptr %133[4] : (!llvm.ptr) -> !llvm.ptr, f64
    %135 = llvm.ptrtoint %134 : !llvm.ptr to i64
    %136 = llvm.call @malloc(%135) : (i64) -> !llvm.ptr
    %137 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %138 = llvm.insertvalue %136, %137[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %139 = llvm.insertvalue %136, %138[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %140 = llvm.mlir.constant(0 : index) : i64
    %141 = llvm.insertvalue %140, %139[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %142 = llvm.insertvalue %131, %141[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %143 = llvm.insertvalue %132, %142[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %144 = llvm.mlir.constant(1 : index) : i64
    %145 = llvm.alloca %144 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %143, %145 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %146 = llvm.mlir.constant(1 : index) : i64
    %147 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %148 = llvm.insertvalue %146, %147[0] : !llvm.struct<(i64, ptr)> 
    %149 = llvm.insertvalue %145, %148[1] : !llvm.struct<(i64, ptr)> 
    %150 = llvm.getelementptr %123[%2] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %149, %150 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    %151 = llvm.mlir.constant(1 : index) : i64
    %152 = llvm.mlir.constant(1 : index) : i64
    %153 = llvm.mlir.zero : !llvm.ptr
    %154 = llvm.getelementptr %153[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %155 = llvm.ptrtoint %154 : !llvm.ptr to i64
    %156 = llvm.mlir.zero : !llvm.ptr
    %157 = llvm.getelementptr %156[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %158 = llvm.ptrtoint %157 : !llvm.ptr to i64
    %159 = llvm.add %155, %158 : i64
    %160 = llvm.call @malloc(%159) : (i64) -> !llvm.ptr
    %161 = llvm.ptrtoint %160 : !llvm.ptr to i64
    %162 = llvm.mlir.constant(1 : index) : i64
    %163 = llvm.sub %158, %162 : i64
    %164 = llvm.add %161, %163 : i64
    %165 = llvm.urem %164, %158  : i64
    %166 = llvm.sub %164, %165 : i64
    %167 = llvm.inttoptr %166 : i64 to !llvm.ptr
    %168 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %169 = llvm.insertvalue %160, %168[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %170 = llvm.insertvalue %167, %169[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %171 = llvm.mlir.constant(0 : index) : i64
    %172 = llvm.insertvalue %171, %170[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %173 = llvm.insertvalue %151, %172[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %174 = llvm.insertvalue %152, %173[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %175 = llvm.mlir.constant(4 : index) : i64
    %176 = llvm.mlir.constant(1 : index) : i64
    %177 = llvm.mlir.zero : !llvm.ptr
    %178 = llvm.getelementptr %177[4] : (!llvm.ptr) -> !llvm.ptr, f64
    %179 = llvm.ptrtoint %178 : !llvm.ptr to i64
    %180 = llvm.call @malloc(%179) : (i64) -> !llvm.ptr
    %181 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %182 = llvm.insertvalue %180, %181[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %183 = llvm.insertvalue %180, %182[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %184 = llvm.mlir.constant(0 : index) : i64
    %185 = llvm.insertvalue %184, %183[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %186 = llvm.insertvalue %175, %185[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %187 = llvm.insertvalue %176, %186[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %188 = llvm.mlir.constant(1 : index) : i64
    %189 = llvm.alloca %188 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %187, %189 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %190 = llvm.mlir.constant(1 : index) : i64
    %191 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %192 = llvm.insertvalue %190, %191[0] : !llvm.struct<(i64, ptr)> 
    %193 = llvm.insertvalue %189, %192[1] : !llvm.struct<(i64, ptr)> 
    %194 = llvm.getelementptr %167[%2] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %193, %194 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    %195 = llvm.mlir.constant(1 : index) : i64
    %196 = llvm.mlir.constant(1 : index) : i64
    %197 = llvm.mlir.zero : !llvm.ptr
    %198 = llvm.getelementptr %197[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %199 = llvm.ptrtoint %198 : !llvm.ptr to i64
    %200 = llvm.mlir.zero : !llvm.ptr
    %201 = llvm.getelementptr %200[1] : (!llvm.ptr) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %202 = llvm.ptrtoint %201 : !llvm.ptr to i64
    %203 = llvm.add %199, %202 : i64
    %204 = llvm.call @malloc(%203) : (i64) -> !llvm.ptr
    %205 = llvm.ptrtoint %204 : !llvm.ptr to i64
    %206 = llvm.mlir.constant(1 : index) : i64
    %207 = llvm.sub %202, %206 : i64
    %208 = llvm.add %205, %207 : i64
    %209 = llvm.urem %208, %202  : i64
    %210 = llvm.sub %208, %209 : i64
    %211 = llvm.inttoptr %210 : i64 to !llvm.ptr
    %212 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %213 = llvm.insertvalue %204, %212[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %214 = llvm.insertvalue %211, %213[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %215 = llvm.mlir.constant(0 : index) : i64
    %216 = llvm.insertvalue %215, %214[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %217 = llvm.insertvalue %195, %216[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %218 = llvm.insertvalue %196, %217[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %219 = llvm.mlir.constant(4 : index) : i64
    %220 = llvm.mlir.constant(1 : index) : i64
    %221 = llvm.mlir.zero : !llvm.ptr
    %222 = llvm.getelementptr %221[4] : (!llvm.ptr) -> !llvm.ptr, f64
    %223 = llvm.ptrtoint %222 : !llvm.ptr to i64
    %224 = llvm.call @malloc(%223) : (i64) -> !llvm.ptr
    %225 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %226 = llvm.insertvalue %224, %225[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %227 = llvm.insertvalue %224, %226[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %228 = llvm.mlir.constant(0 : index) : i64
    %229 = llvm.insertvalue %228, %227[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %230 = llvm.insertvalue %219, %229[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %231 = llvm.insertvalue %220, %230[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %232 = llvm.mlir.constant(1 : index) : i64
    %233 = llvm.alloca %232 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %231, %233 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %234 = llvm.mlir.constant(1 : index) : i64
    %235 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %236 = llvm.insertvalue %234, %235[0] : !llvm.struct<(i64, ptr)> 
    %237 = llvm.insertvalue %233, %236[1] : !llvm.struct<(i64, ptr)> 
    %238 = llvm.getelementptr %211[%2] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    llvm.store %237, %238 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    %239 = llvm.mlir.constant(1 : index) : i64
    %240 = llvm.mlir.constant(1 : index) : i64
    %241 = llvm.mlir.zero : !llvm.ptr
    %242 = llvm.getelementptr %241[1] : (!llvm.ptr) -> !llvm.ptr, i8
    %243 = llvm.ptrtoint %242 : !llvm.ptr to i64
    %244 = llvm.call @malloc(%243) : (i64) -> !llvm.ptr
    %245 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %246 = llvm.insertvalue %244, %245[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %247 = llvm.insertvalue %244, %246[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %248 = llvm.mlir.constant(0 : index) : i64
    %249 = llvm.insertvalue %248, %247[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %250 = llvm.insertvalue %239, %249[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %251 = llvm.insertvalue %240, %250[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %252 = llvm.getelementptr %244[%2] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    llvm.store %8, %252 : i8, !llvm.ptr
    %253 = llvm.mlir.constant(1 : index) : i64
    %254 = llvm.mlir.constant(1 : index) : i64
    %255 = llvm.mlir.zero : !llvm.ptr
    %256 = llvm.getelementptr %255[1] : (!llvm.ptr) -> !llvm.ptr, i8
    %257 = llvm.ptrtoint %256 : !llvm.ptr to i64
    %258 = llvm.call @malloc(%257) : (i64) -> !llvm.ptr
    %259 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %260 = llvm.insertvalue %258, %259[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %261 = llvm.insertvalue %258, %260[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %262 = llvm.mlir.constant(0 : index) : i64
    %263 = llvm.insertvalue %262, %261[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %264 = llvm.insertvalue %253, %263[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %265 = llvm.insertvalue %254, %264[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %266 = llvm.getelementptr %258[%2] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    llvm.store %8, %266 : i8, !llvm.ptr
    %267 = llvm.mlir.constant(1 : index) : i64
    %268 = llvm.alloca %267 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %24, %268 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %269 = llvm.mlir.constant(1 : index) : i64
    %270 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %271 = llvm.insertvalue %269, %270[0] : !llvm.struct<(i64, ptr)> 
    %272 = llvm.insertvalue %268, %271[1] : !llvm.struct<(i64, ptr)> 
    %273 = llvm.mlir.constant(1 : index) : i64
    %274 = llvm.alloca %273 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %86, %274 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %275 = llvm.mlir.constant(1 : index) : i64
    %276 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %277 = llvm.insertvalue %275, %276[0] : !llvm.struct<(i64, ptr)> 
    %278 = llvm.insertvalue %274, %277[1] : !llvm.struct<(i64, ptr)> 
    %279 = llvm.mlir.constant(1 : index) : i64
    %280 = llvm.alloca %279 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %130, %280 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %281 = llvm.mlir.constant(1 : index) : i64
    %282 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %283 = llvm.insertvalue %281, %282[0] : !llvm.struct<(i64, ptr)> 
    %284 = llvm.insertvalue %280, %283[1] : !llvm.struct<(i64, ptr)> 
    %285 = llvm.mlir.constant(1 : index) : i64
    %286 = llvm.alloca %285 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %251, %286 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %287 = llvm.mlir.constant(1 : index) : i64
    %288 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %289 = llvm.insertvalue %287, %288[0] : !llvm.struct<(i64, ptr)> 
    %290 = llvm.insertvalue %286, %289[1] : !llvm.struct<(i64, ptr)> 
    %291 = llvm.mlir.constant(1 : index) : i64
    %292 = llvm.alloca %291 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %37, %292 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %293 = llvm.mlir.constant(1 : index) : i64
    %294 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %295 = llvm.insertvalue %293, %294[0] : !llvm.struct<(i64, ptr)> 
    %296 = llvm.insertvalue %292, %295[1] : !llvm.struct<(i64, ptr)> 
    %297 = llvm.mlir.constant(1 : index) : i64
    %298 = llvm.alloca %297 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %174, %298 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %299 = llvm.mlir.constant(1 : index) : i64
    %300 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %301 = llvm.insertvalue %299, %300[0] : !llvm.struct<(i64, ptr)> 
    %302 = llvm.insertvalue %298, %301[1] : !llvm.struct<(i64, ptr)> 
    %303 = llvm.mlir.constant(1 : index) : i64
    %304 = llvm.alloca %303 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %218, %304 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %305 = llvm.mlir.constant(1 : index) : i64
    %306 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %307 = llvm.insertvalue %305, %306[0] : !llvm.struct<(i64, ptr)> 
    %308 = llvm.insertvalue %304, %307[1] : !llvm.struct<(i64, ptr)> 
    %309 = llvm.mlir.constant(1 : index) : i64
    %310 = llvm.alloca %309 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %265, %310 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %311 = llvm.mlir.constant(1 : index) : i64
    %312 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %313 = llvm.insertvalue %311, %312[0] : !llvm.struct<(i64, ptr)> 
    %314 = llvm.insertvalue %310, %313[1] : !llvm.struct<(i64, ptr)> 
    %315 = llvm.extractvalue %272[0] : !llvm.struct<(i64, ptr)> 
    %316 = llvm.extractvalue %272[1] : !llvm.struct<(i64, ptr)> 
    %317 = llvm.extractvalue %278[0] : !llvm.struct<(i64, ptr)> 
    %318 = llvm.extractvalue %278[1] : !llvm.struct<(i64, ptr)> 
    %319 = llvm.extractvalue %284[0] : !llvm.struct<(i64, ptr)> 
    %320 = llvm.extractvalue %284[1] : !llvm.struct<(i64, ptr)> 
    %321 = llvm.extractvalue %290[0] : !llvm.struct<(i64, ptr)> 
    %322 = llvm.extractvalue %290[1] : !llvm.struct<(i64, ptr)> 
    %323 = llvm.extractvalue %296[0] : !llvm.struct<(i64, ptr)> 
    %324 = llvm.extractvalue %296[1] : !llvm.struct<(i64, ptr)> 
    %325 = llvm.extractvalue %302[0] : !llvm.struct<(i64, ptr)> 
    %326 = llvm.extractvalue %302[1] : !llvm.struct<(i64, ptr)> 
    %327 = llvm.extractvalue %308[0] : !llvm.struct<(i64, ptr)> 
    %328 = llvm.extractvalue %308[1] : !llvm.struct<(i64, ptr)> 
    %329 = llvm.extractvalue %314[0] : !llvm.struct<(i64, ptr)> 
    %330 = llvm.extractvalue %314[1] : !llvm.struct<(i64, ptr)> 
    %331 = llvm.call @async_execute_fn(%315, %316, %317, %318, %319, %320, %321, %322, %323, %324, %325, %326, %327, %328, %329, %330) : (i64, !llvm.ptr, i64, !llvm.ptr, i64, !llvm.ptr, i64, !llvm.ptr, i64, !llvm.ptr, i64, !llvm.ptr, i64, !llvm.ptr, i64, !llvm.ptr) -> !llvm.ptr
    llvm.br ^bb10(%2 : i64)
  ^bb10(%332: i64):  // 2 preds: ^bb9, ^bb32
    %333 = llvm.icmp "slt" %332, %9 : i64
    llvm.cond_br %333, ^bb11, ^bb33
  ^bb11:  // pred: ^bb10
    %334 = llvm.sub %9, %332 : i64
    %335 = llvm.intr.smin(%334, %4)  : (i64, i64) -> i64
    llvm.br ^bb12(%2 : i64)
  ^bb12(%336: i64):  // 2 preds: ^bb11, ^bb31
    %337 = llvm.icmp "slt" %336, %9 : i64
    llvm.cond_br %337, ^bb13, ^bb32
  ^bb13:  // pred: ^bb12
    %338 = llvm.sub %9, %336 : i64
    %339 = llvm.intr.smin(%338, %4)  : (i64, i64) -> i64
    %340 = llvm.getelementptr %244[%2] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %341 = llvm.load %340 : !llvm.ptr -> i8
    llvm.br ^bb14(%341 : i8)
  ^bb14(%342: i8):  // 2 preds: ^bb13, ^bb15
    %343 = llvm.icmp "eq" %342, %8 : i8
    llvm.cond_br %343, ^bb15, ^bb16
  ^bb15:  // pred: ^bb14
    %344 = llvm.extractvalue %290[0] : !llvm.struct<(i64, ptr)> 
    %345 = llvm.extractvalue %290[1] : !llvm.struct<(i64, ptr)> 
    %346 = llvm.call @comet_atomic_load_n_i8(%344, %345) : (i64, !llvm.ptr) -> i8
    llvm.br ^bb14(%346 : i8)
  ^bb16:  // pred: ^bb14
    llvm.br ^bb17(%2 : i64)
  ^bb17(%347: i64):  // 2 preds: ^bb16, ^bb30
    %348 = llvm.icmp "slt" %347, %9 : i64
    llvm.cond_br %348, ^bb18, ^bb31
  ^bb18:  // pred: ^bb17
    %349 = llvm.sub %9, %347 : i64
    %350 = llvm.intr.smin(%349, %4)  : (i64, i64) -> i64
    %351 = llvm.getelementptr %258[%2] : (!llvm.ptr, i64) -> !llvm.ptr, i8
    %352 = llvm.load %351 : !llvm.ptr -> i8
    llvm.br ^bb19(%352 : i8)
  ^bb19(%353: i8):  // 2 preds: ^bb18, ^bb20
    %354 = llvm.icmp "eq" %353, %8 : i8
    llvm.cond_br %354, ^bb20, ^bb21
  ^bb20:  // pred: ^bb19
    %355 = llvm.extractvalue %314[0] : !llvm.struct<(i64, ptr)> 
    %356 = llvm.extractvalue %314[1] : !llvm.struct<(i64, ptr)> 
    %357 = llvm.call @comet_atomic_load_n_i8(%355, %356) : (i64, !llvm.ptr) -> i8
    llvm.br ^bb19(%357 : i8)
  ^bb21:  // pred: ^bb19
    %358 = llvm.getelementptr %79[%2] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %359 = llvm.load %358 : !llvm.ptr -> !llvm.struct<(i64, ptr)>
    %360 = llvm.extractvalue %359[1] : !llvm.struct<(i64, ptr)> 
    %361 = llvm.load %360 : !llvm.ptr -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %362 = llvm.getelementptr %167[%2] : (!llvm.ptr, i64) -> !llvm.ptr, !llvm.struct<(i64, ptr)>
    %363 = llvm.load %362 : !llvm.ptr -> !llvm.struct<(i64, ptr)>
    %364 = llvm.extractvalue %363[1] : !llvm.struct<(i64, ptr)> 
    %365 = llvm.load %364 : !llvm.ptr -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    llvm.br ^bb22(%2 : i64)
  ^bb22(%366: i64):  // 2 preds: ^bb21, ^bb29
    %367 = llvm.icmp "slt" %366, %335 : i64
    llvm.cond_br %367, ^bb23, ^bb30
  ^bb23:  // pred: ^bb22
    %368 = llvm.add %332, %366 : i64
    %369 = llvm.mul %366, %4 : i64
    %370 = llvm.mul %368, %9 : i64
    llvm.br ^bb24(%2 : i64)
  ^bb24(%371: i64):  // 2 preds: ^bb23, ^bb28
    %372 = llvm.icmp "slt" %371, %339 : i64
    llvm.cond_br %372, ^bb25, ^bb29
  ^bb25:  // pred: ^bb24
    %373 = llvm.add %369, %371 : i64
    %374 = llvm.extractvalue %361[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %375 = llvm.getelementptr %374[%373] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %376 = llvm.load %375 : !llvm.ptr -> f64
    %377 = llvm.mul %371, %4 : i64
    llvm.br ^bb26(%2 : i64)
  ^bb26(%378: i64):  // 2 preds: ^bb25, ^bb27
    %379 = llvm.icmp "slt" %378, %350 : i64
    llvm.cond_br %379, ^bb27, ^bb28
  ^bb27:  // pred: ^bb26
    %380 = llvm.add %377, %378 : i64
    %381 = llvm.extractvalue %365[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %382 = llvm.getelementptr %381[%380] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %383 = llvm.load %382 : !llvm.ptr -> f64
    %384 = llvm.fmul %376, %383  : f64
    %385 = llvm.add %347, %378 : i64
    %386 = llvm.add %370, %385 : i64
    %387 = llvm.getelementptr %43[%386] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %388 = llvm.load %387 : !llvm.ptr -> f64
    %389 = llvm.fadd %388, %384  : f64
    %390 = llvm.getelementptr %43[%386] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %389, %390 : f64, !llvm.ptr
    %391 = llvm.add %378, %3 : i64
    llvm.br ^bb26(%391 : i64)
  ^bb28:  // pred: ^bb26
    %392 = llvm.add %371, %3 : i64
    llvm.br ^bb24(%392 : i64)
  ^bb29:  // pred: ^bb24
    %393 = llvm.add %366, %3 : i64
    llvm.br ^bb22(%393 : i64)
  ^bb30:  // pred: ^bb22
    %394 = llvm.extractvalue %314[0] : !llvm.struct<(i64, ptr)> 
    %395 = llvm.extractvalue %314[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_atomic_store_n_i8(%394, %395, %8) : (i64, !llvm.ptr, i8) -> ()
    %396 = llvm.add %347, %4 : i64
    llvm.br ^bb17(%396 : i64)
  ^bb31:  // pred: ^bb17
    %397 = llvm.extractvalue %290[0] : !llvm.struct<(i64, ptr)> 
    %398 = llvm.extractvalue %290[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_atomic_store_n_i8(%397, %398, %8) : (i64, !llvm.ptr, i8) -> ()
    %399 = llvm.add %336, %4 : i64
    llvm.br ^bb12(%399 : i64)
  ^bb32:  // pred: ^bb12
    %400 = llvm.add %332, %4 : i64
    llvm.br ^bb10(%400 : i64)
  ^bb33:  // pred: ^bb10
    llvm.call @mlirAsyncRuntimeAwaitToken(%331) : (!llvm.ptr) -> ()
    %401 = llvm.call @mlirAsyncRuntimeIsTokenError(%331) : (!llvm.ptr) -> i1
    %402 = llvm.mlir.constant(1 : i64) : i64
    llvm.call @mlirAsyncRuntimeDropRef(%331, %402) : (!llvm.ptr, i64) -> ()
    %403 = llvm.mlir.constant(true) : i1
    %404 = llvm.xor %401, %403  : i1
    llvm.cond_br %404, ^bb34, ^bb35
  ^bb34:  // pred: ^bb33
    %405 = llvm.mlir.constant(1 : index) : i64
    %406 = llvm.alloca %405 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %50, %406 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %407 = llvm.mlir.constant(1 : index) : i64
    %408 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %409 = llvm.insertvalue %407, %408[0] : !llvm.struct<(i64, ptr)> 
    %410 = llvm.insertvalue %406, %409[1] : !llvm.struct<(i64, ptr)> 
    %411 = llvm.extractvalue %410[0] : !llvm.struct<(i64, ptr)> 
    %412 = llvm.extractvalue %410[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_print_matrix_f64(%411, %412, %9, %9) : (i64, !llvm.ptr, i64, i64) -> ()
    %413 = llvm.call @getTime() : () -> f64
    llvm.call @printElapsedTime(%11, %413) : (f64, f64) -> ()
    llvm.call @free(%17) : (!llvm.ptr) -> ()
    llvm.call @free(%30) : (!llvm.ptr) -> ()
    llvm.call @free(%43) : (!llvm.ptr) -> ()
    llvm.call @free(%92) : (!llvm.ptr) -> ()
    llvm.call @free(%72) : (!llvm.ptr) -> ()
    llvm.call @free(%136) : (!llvm.ptr) -> ()
    llvm.call @free(%116) : (!llvm.ptr) -> ()
    llvm.call @free(%180) : (!llvm.ptr) -> ()
    llvm.call @free(%160) : (!llvm.ptr) -> ()
    llvm.call @free(%224) : (!llvm.ptr) -> ()
    llvm.call @free(%204) : (!llvm.ptr) -> ()
    llvm.call @free(%244) : (!llvm.ptr) -> ()
    llvm.call @free(%258) : (!llvm.ptr) -> ()
    llvm.return
  ^bb35:  // pred: ^bb33
    %414 = llvm.mlir.addressof @assert_msg : !llvm.ptr
    %415 = llvm.getelementptr %414[0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<40 x i8>
    llvm.call @puts(%415) : (!llvm.ptr) -> ()
    llvm.call @abort() : () -> ()
    llvm.unreachable
  }
  llvm.func @comet_print_memref_to_memref_f64(i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @comet_print_matrix_f64(i64, !llvm.ptr, i64, i64) attributes {sym_visibility = "private"}
  llvm.func @comet_atomic_load_n_i8(i64, !llvm.ptr) -> i8 attributes {sym_visibility = "private"}
  llvm.func @comet_atomic_store_n_i8(i64, !llvm.ptr, i8) attributes {sym_visibility = "private"}
  llvm.func @comet_swap_buffers(i64, !llvm.ptr, i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @comet_initialize_double_buffer_thread(i64, !llvm.ptr, i64, i64, i64, !llvm.ptr, i64, !llvm.ptr, i64, i64, i64, !llvm.ptr, i64, !llvm.ptr, i64, i64, i64, !llvm.ptr, i64, !llvm.ptr, i64, i64, i64, !llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func @getTime() -> f64 attributes {sym_visibility = "private"}
  llvm.func @printElapsedTime(f64, f64) attributes {sym_visibility = "private"}
  llvm.func @printI64(i64) attributes {sym_visibility = "private"}
  llvm.func @printF64(f64) attributes {sym_visibility = "private"}
  llvm.func @printComma() attributes {sym_visibility = "private"}
  llvm.func @printNewline() attributes {sym_visibility = "private"}
  llvm.func @async_execute_fn(%arg0: i64, %arg1: !llvm.ptr, %arg2: i64, %arg3: !llvm.ptr, %arg4: i64, %arg5: !llvm.ptr, %arg6: i64, %arg7: !llvm.ptr, %arg8: i64, %arg9: !llvm.ptr, %arg10: i64, %arg11: !llvm.ptr, %arg12: i64, %arg13: !llvm.ptr, %arg14: i64, %arg15: !llvm.ptr) -> !llvm.ptr attributes {passthrough = ["presplitcoroutine"], sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %1 = llvm.insertvalue %arg14, %0[0] : !llvm.struct<(i64, ptr)> 
    %2 = llvm.insertvalue %arg15, %1[1] : !llvm.struct<(i64, ptr)> 
    %3 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %4 = llvm.insertvalue %arg12, %3[0] : !llvm.struct<(i64, ptr)> 
    %5 = llvm.insertvalue %arg13, %4[1] : !llvm.struct<(i64, ptr)> 
    %6 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %7 = llvm.insertvalue %arg10, %6[0] : !llvm.struct<(i64, ptr)> 
    %8 = llvm.insertvalue %arg11, %7[1] : !llvm.struct<(i64, ptr)> 
    %9 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %10 = llvm.insertvalue %arg8, %9[0] : !llvm.struct<(i64, ptr)> 
    %11 = llvm.insertvalue %arg9, %10[1] : !llvm.struct<(i64, ptr)> 
    %12 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %13 = llvm.insertvalue %arg6, %12[0] : !llvm.struct<(i64, ptr)> 
    %14 = llvm.insertvalue %arg7, %13[1] : !llvm.struct<(i64, ptr)> 
    %15 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %16 = llvm.insertvalue %arg4, %15[0] : !llvm.struct<(i64, ptr)> 
    %17 = llvm.insertvalue %arg5, %16[1] : !llvm.struct<(i64, ptr)> 
    %18 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %19 = llvm.insertvalue %arg2, %18[0] : !llvm.struct<(i64, ptr)> 
    %20 = llvm.insertvalue %arg3, %19[1] : !llvm.struct<(i64, ptr)> 
    %21 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %22 = llvm.insertvalue %arg0, %21[0] : !llvm.struct<(i64, ptr)> 
    %23 = llvm.insertvalue %arg1, %22[1] : !llvm.struct<(i64, ptr)> 
    %24 = llvm.call @mlirAsyncRuntimeCreateToken() : () -> !llvm.ptr
    %25 = llvm.mlir.constant(0 : i32) : i32
    %26 = llvm.mlir.zero : !llvm.ptr
    %27 = llvm.intr.coro.id %25, %26, %26, %26 : (i32, !llvm.ptr, !llvm.ptr, !llvm.ptr) -> !llvm.token
    %28 = llvm.intr.coro.size : i64
    %29 = llvm.intr.coro.align : i64
    %30 = llvm.add %28, %29 : i64
    %31 = llvm.mlir.constant(1 : i64) : i64
    %32 = llvm.sub %30, %31 : i64
    %33 = llvm.mlir.constant(0 : i64) : i64
    %34 = llvm.sub %33, %29 : i64
    %35 = llvm.and %32, %34  : i64
    %36 = llvm.call @aligned_alloc(%29, %35) : (i64, i64) -> !llvm.ptr
    %37 = llvm.intr.coro.begin %27, %36 : (!llvm.token, !llvm.ptr) -> !llvm.ptr
    %38 = llvm.intr.coro.save %37 : (!llvm.ptr) -> !llvm.token
    %39 = llvm.mlir.addressof @__resume : !llvm.ptr
    llvm.call @mlirAsyncRuntimeExecute(%37, %39) : (!llvm.ptr, !llvm.ptr) -> ()
    %40 = llvm.mlir.constant(false) : i1
    %41 = llvm.intr.coro.suspend %38, %40 : i8
    %42 = llvm.sext %41 : i8 to i32
    llvm.switch %42 : i32, ^bb4 [
      0: ^bb1,
      1: ^bb3
    ]
  ^bb1:  // pred: ^bb0
    %43 = llvm.mlir.constant(5 : i64) : i64
    %44 = llvm.mlir.constant(2 : i64) : i64
    %45 = llvm.extractvalue %23[0] : !llvm.struct<(i64, ptr)> 
    %46 = llvm.extractvalue %23[1] : !llvm.struct<(i64, ptr)> 
    %47 = llvm.extractvalue %20[0] : !llvm.struct<(i64, ptr)> 
    %48 = llvm.extractvalue %20[1] : !llvm.struct<(i64, ptr)> 
    %49 = llvm.extractvalue %17[0] : !llvm.struct<(i64, ptr)> 
    %50 = llvm.extractvalue %17[1] : !llvm.struct<(i64, ptr)> 
    %51 = llvm.extractvalue %14[0] : !llvm.struct<(i64, ptr)> 
    %52 = llvm.extractvalue %14[1] : !llvm.struct<(i64, ptr)> 
    %53 = llvm.extractvalue %11[0] : !llvm.struct<(i64, ptr)> 
    %54 = llvm.extractvalue %11[1] : !llvm.struct<(i64, ptr)> 
    %55 = llvm.extractvalue %8[0] : !llvm.struct<(i64, ptr)> 
    %56 = llvm.extractvalue %8[1] : !llvm.struct<(i64, ptr)> 
    %57 = llvm.extractvalue %5[0] : !llvm.struct<(i64, ptr)> 
    %58 = llvm.extractvalue %5[1] : !llvm.struct<(i64, ptr)> 
    %59 = llvm.extractvalue %2[0] : !llvm.struct<(i64, ptr)> 
    %60 = llvm.extractvalue %2[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @comet_initialize_double_buffer_thread(%45, %46, %43, %43, %47, %48, %49, %50, %44, %44, %51, %52, %53, %54, %43, %43, %55, %56, %57, %58, %44, %44, %59, %60) : (i64, !llvm.ptr, i64, i64, i64, !llvm.ptr, i64, !llvm.ptr, i64, i64, i64, !llvm.ptr, i64, !llvm.ptr, i64, i64, i64, !llvm.ptr, i64, !llvm.ptr, i64, i64, i64, !llvm.ptr) -> ()
    llvm.call @mlirAsyncRuntimeEmplaceToken(%24) : (!llvm.ptr) -> ()
    llvm.br ^bb2
  ^bb2:  // pred: ^bb1
    %61 = llvm.intr.coro.free %27, %37 : (!llvm.token, !llvm.ptr) -> !llvm.ptr
    llvm.call @free(%61) : (!llvm.ptr) -> ()
    llvm.br ^bb4
  ^bb3:  // pred: ^bb0
    %62 = llvm.intr.coro.free %27, %37 : (!llvm.token, !llvm.ptr) -> !llvm.ptr
    llvm.call @free(%62) : (!llvm.ptr) -> ()
    llvm.br ^bb4
  ^bb4:  // 3 preds: ^bb0, ^bb2, ^bb3
    %63 = llvm.mlir.constant(false) : i1
    %64 = llvm.mlir.none : !llvm.token
    %65 = llvm.intr.coro.end %37, %63, %64 : (!llvm.ptr, i1, !llvm.token) -> i1
    llvm.return %24 : !llvm.ptr
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
