# set -euxo pipefail
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: bash $0 <input.ta>"
  exit -1
fi
input_ta=$1

# Number of Threads
export OMP_NUM_THREADS=8
export COMET_ROOT_DIR="/Users/peng599/pppp/comet-amais-memory/COMET-memAnalysis2-dev-new"

# Input sparse matrix
# export SPARSE_FILE_NAME0="../../test/integration/data/test_rank2_small.mtx"
# export SPARSE_FILE_NAME1="../../test/integration/data/test_rank2_small.mtx"
# export SPARSE_FILE_NAME0="../../test/integration/data/test_rank2.mtx"
# export SPARSE_FILE_NAME1="../../test/integration/data/test_rank2.mtx"
# export SPARSE_FILE_NAME0="${COMET_ROOT_DIR}/test/integration/data/tc.mtx"
# export SPARSE_FILE_NAME1="${COMET_ROOT_DIR}/test/integration/data/tc.mtx"
#  export SPARSE_FILE_NAME0="/Users/peng599/Library/CloudStorage/OneDrive-PNNL/Documents/Datasets/bcsstk17/bcsstk17.mtx"
#  export SPARSE_FILE_NAME1="/Users/peng599/Library/CloudStorage/OneDrive-PNNL/Documents/Datasets/bcsstk17/bcsstk17.mtx"
# export SPARSE_FILE_NAME0="/Users/peng599/Library/CloudStorage/OneDrive-PNNL/Documents/Datasets/shipsec1/shipsec1.mtx"
# export SPARSE_FILE_NAME1="/Users/peng599/Library/CloudStorage/OneDrive-PNNL/Documents/Datasets/shipsec1/shipsec1.mtx"
# export SPARSE_FILE_NAME0="data/test_4d_tensor.tns"
# export SPARSE_FILE_NAME1="data/test_4d_tensor.tns"
#export SPARSE_FILE_NAME0="data/test_3d_tensor.tns"
#export SPARSE_FILE_NAME1="data/test_3d_tensor.tns"
# export SPARSE_FILE_NAME0="/Users/peng599/Library/CloudStorage/OneDrive-PNNL/Documents/Datasets/pwtk/pwtk.mtx"
# export SPARSE_FILE_NAME0="/Users/peng599/Library/CloudStorage/OneDrive-PNNL/Documents/Datasets/bcspwr02/bcspwr02.mtx"
# export SPARSE_FILE_NAME0="/Users/peng599/Library/CloudStorage/OneDrive-PNNL/Documents/Datasets/scircuit/scircuit.mtx"
# export SPARSE_FILE_NAME1="/Users/peng599/Library/CloudStorage/OneDrive-PNNL/Documents/Datasets/scircuit/scircuit.mtx"

#
# Test if this machine is running macOS
case "$(uname -s)" in
    Linux*)
        export EXT="so"
        ;;
    Darwin*)
        export EXT="dylib"
        ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        export EXT="dll"
        ;;
    *)
        echo "Unknown OS"
        export EXT="EXT"
        ;;
esac



# Lowering
comet_opt="${COMET_ROOT_DIR}/cmake-build-debug/bin/comet-opt"
#mlir_opt="../../llvm/build/bin/mlir-opt"
# input_ta="mult_dense_matrix.ta"
basename=$(basename ${input_ta})
# comet_opt_options="--convert-ta-to-it --convert-to-loops --convert-to-llvm"
# src_llvm="${basename}.llvm.llvm"
# eval ${comet_opt} ${comet_opt_options} ${input_ta} &> ${src_llvm}

# src_ta="${basename}.TensorAlgebra.mlir"
# tensor_algebra_options="--emit-ta"
# eval ${comet_opt} ${tensor_algebra_options} ${input_ta} &> ${src_ta}

# src_it="${basename}.IndexTree.mlir"
#  index_tree_options="--convert-ta-to-it --emit-it --opt-comp-workspace"
# #index_tree_options="--convert-ta-to-it --opt-comp-workspace"
# #index_tree_options="--convert-ta-to-it --emit-it"
# # index_tree_options="--convert-ta-to-it --emit-it --mlir-print-ir-after-all"
# eval ${comet_opt} ${index_tree_options} ${input_ta} &> ${src_it}

# src_scf="${basename}.SCF.mlir"
# scf_options="--convert-ta-to-it --convert-to-loops --opt-comp-workspace --mlir-print-ir-after-all"
# #scf_options="--convert-ta-to-it --convert-to-loops --opt-comp-workspace"
# # scf_options="--convert-ta-to-it --convert-to-loops --emit-loops"
# #scf_options="--convert-ta-to-it --convert-to-loops --opt-fusion"
# eval ${comet_opt} ${scf_options} ${input_ta} &> ${src_scf}

# src_llvm="${basename}.LLVM.mlir"
# llvm_options="--convert-ta-to-it --convert-to-loops --convert-to-llvm --opt-comp-workspace"
# # llvm_options="--convert-ta-to-it --convert-to-loops --convert-to-llvm --opt-comp-workspace --mlir-print-ir-after-all"
# # llvm_options="--convert-ta-to-it --convert-to-loops --convert-to-llvm --opt-comp-workspace --mlir-print-ir-after-all --debug"
# eval ${comet_opt} ${llvm_options} ${input_ta} &> ${src_llvm}
# #eval ${mlir_opt} ${llvm_options} ${src_scf} &> ${src_llvm}

src_llvm="${basename}.LLVM.mlir"
llvm_options="--convert-to-llvm"
eval ${comet_opt} ${llvm_options} ${input_ta} &> ${src_llvm}

# Runner
mlir_cpu_runner="${COMET_ROOT_DIR}/llvm/build/bin/mlir-cpu-runner"
mlir_cpu_runner_options="-O3 -e main -entry-point-result=void"
mlir_cpu_runner_shared_libs="${COMET_ROOT_DIR}/cmake-build-debug/lib/libcomet_runner_utils.${EXT},\
${COMET_ROOT_DIR}/llvm/build/lib/libomp.${EXT},\
${COMET_ROOT_DIR}/llvm/build/lib/libmlir_c_runner_utils.${EXT}\
"
eval ${mlir_cpu_runner} ${mlir_cpu_runner_options} -shared-libs="${mlir_cpu_runner_shared_libs}" ${src_llvm}