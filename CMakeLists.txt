cmake_minimum_required(VERSION 3.24)
project(softcache_demo)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_VERBOSE_MAKEFILE ON)

include_directories("include")

# Rapid Library
set(CMAKE_PREFIX_PATH "/share/micron/rapid/install/gcc-release")
find_package(rapid CONFIG REQUIRED)
include_directories("/share/micron/rapid/install/gcc-release/include")
link_directories("/share/micron/rapid/install/gcc-release/lib64")

# OpenMP Library
find_package(OpenMP REQUIRED)

add_library(softcache src/soft_cache.cpp)
add_library(background_thread src/background_thread.cpp)
add_library(simplegemm src/gemm.cpp)
target_link_libraries(simplegemm PUBLIC softcache background_thread rapid::rapid OpenMP::OpenMP_CXX)
#target_link_libraries(simplegemm PUBLIC softcache background_thread rapid::rapid)
#target_link_libraries(simplegemm PUBLIC softcache background_thread)


# GEMM Test correctness
add_executable(gemm_test_correct app/gemm_test_correct.cpp)
target_link_libraries(gemm_test_correct PRIVATE simplegemm)

add_executable(gemm_doublebuffer_demo_v2 app/gemm_doublebuffer_demo_v2.cpp)
target_link_libraries(gemm_doublebuffer_demo_v2 PRIVATE simplegemm)

# GEMM RAPID
#add_executable(gemm_rapid app/gemm_rapid.cpp)
#target_link_libraries(gemm_rapid PRIVATE simplegemm)
#
#add_executable(gemm_rapid.tile-512 app/gemm_rapid.tile-512.cpp)
#target_link_libraries(gemm_rapid.tile-512 PRIVATE simplegemm)
#
#add_executable(gemm_rapid.buffer_size.seq app/gemm_rapid.buffer_size.seq.cpp)
#target_link_libraries(gemm_rapid.buffer_size.seq PRIVATE simplegemm)
#
#add_executable(gemm_rapid.buffer_size.omp app/gemm_rapid.buffer_size.omp.cpp)
#target_link_libraries(gemm_rapid.buffer_size.omp PRIVATE simplegemm)


## GEMM Plain FAM
#add_executable(gemm.plain.fam app/gemm.plain.fam.cpp)
#target_link_libraries(gemm.plain.fam PRIVATE simplegemm)

# GEMM Plain DRAM
add_executable(gemm.plain.dram app/gemm.plain.dram.cpp)
target_link_libraries(gemm.plain.dram PRIVATE simplegemm)

## GEMM Double Buffering Parallel jj
#add_executable(gemm_doublebuffer_parallel_jj_v0 app/gemm_doublebuffer_parallel_jj_v0.cpp)
#target_link_libraries(gemm_doublebuffer_parallel_jj_v0 PRIVATE simplegemm)

## GEMM Double Buffering Parallel ii
#add_executable(gemm_doublebuffer_parallel_ii_v0 app/gemm_doublebuffer_parallel_ii_v0.cpp)
#target_link_libraries(gemm_doublebuffer_parallel_ii_v0 PRIVATE simplegemm)

# GEMM Double Buffering Parallel compute driver
add_executable(gemm_doublebuffer_parallel_compute_drive_v0 app/gemm_doublebuffer_parallel_compute_drive_v0.cpp)
target_link_libraries(gemm_doublebuffer_parallel_compute_drive_v0 PRIVATE simplegemm)

## GEMM Double Buffering Parallel compute driver v1 OpenMP parallel for loop
add_executable(gemm_doublebuffer_parallel_compute_drive_v1_omp app/gemm_doublebuffer_parallel_compute_drive_v1_omp.cpp)
target_link_libraries(gemm_doublebuffer_parallel_compute_drive_v1_omp PRIVATE simplegemm OpenMP::OpenMP_CXX)