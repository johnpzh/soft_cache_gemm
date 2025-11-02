set -eu

PREV_DIR=$(readlink -f .)
#BUILD_DIR="${PREV_DIR}/../../cmake-build-debug"
BUILD_DIR="${PREV_DIR}/../../build_clang"

OUTPUT_DIR="output.$(date +%FT%T)"
mkdir -p ${OUTPUT_DIR}

cd ${OUTPUT_DIR}

gemm_fam_app="${BUILD_DIR}/gemm_rapid.buffer_size.seq"

# Run
${gemm_fam_app}


## CMake Command
#cmake -G Ninja .. \
#-DCMAKE_C_COMPILER="/home/peng599/peng599/pppp/amais_project/COMET-memAnalysis2-dev-new/llvm/build/bin/clang" \
#-DCMAKE_CXX_COMPILER="/home/peng599/peng599/pppp/amais_project/COMET-memAnalysis2-dev-new/llvm/build/bin/clang++" \
#-DCMAKE_BUILD_TYPE=Release