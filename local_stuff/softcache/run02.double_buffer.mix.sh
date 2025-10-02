
PREV_DIR=$(readlink -f .)
#BUILD_DIR="${PREV_DIR}/../../cmake-build-debug"
BUILD_DIR="${PREV_DIR}/../../build"

OUTPUT_DIR="output.$(date +%FT%T)"
mkdir -p ${OUTPUT_DIR}

cd ${OUTPUT_DIR}


# Run

# FAM, DoubleBuffer, BufferSize, Seq
"${BUILD_DIR}/gemm_rapid.buffer_size.seq"

# FAM, DoubleBuffer, BufferSize, NumThreads
# Matrix-size-4096
# Matrix-size-8192
#"${BUILD_DIR}/gemm_rapid.buffer_size.omp"
