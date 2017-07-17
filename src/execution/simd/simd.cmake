#set simd.
set(simd
)
set(simd_dir
)
set(simd_header_files
    ../include/execution/simd/simd.hpp
)
set(simd_source_files
   simd/simd.cpp
)
set(simd_dir
    ${simd_dir}
    ${simd_header_files}
    ${simd_source_files}
)

set(simd
	${simd}
	${simd_dir}
)



