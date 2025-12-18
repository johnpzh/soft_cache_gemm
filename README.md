# Dense Matrix Multiplication (GEMM) Testing with Double Buffering Idea

## Requirement
May need the Rapid library to provide CXL memory allocator. Please check the `Rapid Library` part in the `CMakeLists.txt`. Some programs require the library, some don't.

To disable the library, we can 
1. comment out the rapid library in the `CMakeLists.txt`.
2. comment out the header `#include "rapid.h"` in `include/gemm.h`.
3. comment out the function `double *create_matrix_in_fam(rapid_handle fam, uint64_t num_rows, uint64_t num_cols, double val=0)` and `void destroy_matrix_in_fam(rapid_handle fam, double *matrix)` in `include/gemm.h` and `src/gemm.cpp`.

## Build
Run
```bash
mkdir build
cd build
cmake -G Ninja ..
ninja
```

## Run
Execute the built programs in the `build/`.