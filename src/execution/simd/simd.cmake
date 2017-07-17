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

source_group("simd"					FILES ${simd_base})
source_group("simd/include"			FILES ${simd_header_files})
source_group("simd/source"			FILES ${simd_source_files})


