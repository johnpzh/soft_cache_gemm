cmake_minimum_required(VERSION 3.24)
project(softcache_demo)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_VERBOSE_MAKEFILE ON)

## Rapid Library
#set(CMAKE_PREFIX_PATH "/share/micron/rapid/install/gcc-debug")
#find_package(rapid CONFIG REQUIRED)
#include_directories("/share/micron/rapid/install/gcc-release/include")
#link_directories("/share/micron/rapid/install/gcc-release/lib64")

include_directories("include")

add_library(softcache src/soft_cache.cpp)
add_library(simplegemm src/gemm.cpp)
target_link_libraries(simplegemm PUBLIC softcache)


#add_executable(softcache_demo main.cpp)

# GEMM Test correctness
add_executable(gemm_test_correct app/gemm_test_correct.cpp)
target_link_libraries(gemm_test_correct PRIVATE simplegemm)

## GEMM RAPID
add_executable(gemm_rapid app/gemm_rapid.cpp)
target_link_libraries(gemm_rapid PRIVATE simplegemm)
