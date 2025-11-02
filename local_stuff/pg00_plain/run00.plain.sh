set -eu

PREV_DIR=$(readlink -f .)
#BUILD_DIR="${PREV_DIR}/../../cmake-build-debug"
BUILD_DIR="${PREV_DIR}/../../build"

OUTPUT_DIR="output.$(date +%FT%T)"
mkdir -p ${OUTPUT_DIR}

cd ${OUTPUT_DIR}

gemm_dram_app="${BUILD_DIR}/gemm.plain.dram"
gemm_fam_app="${BUILD_DIR}/gemm.plain.fam"

# Run
${gemm_dram_app}
${gemm_fam_app}

