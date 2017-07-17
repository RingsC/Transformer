#Adding the subdirectory into top, and including all the source files and header files into, then setting the source group.

include(gpu/gpu.cmake)
include(llvm/llvm.cmake)
include(simd/simd.cmake)

set(execution
)

#set the execution head files
set(execution_header_files
	../include/execution/seqscan.hpp
	../include/execution/tidscan.hpp
	../include/execution/indexscan.hpp
)
set(execution_source_files
	execution/seqscan.cpp
	execution/tidscan.cpp
	execution/indexscan.cpp
)

#set gpu files.
set(gpu_dir
)
set(gpu_header_files
	../include/execution/gpu/gpu.hpp
)


#set the execution source files.
set(execution_dir
	${execution_dir}
	${gpu_dir}
	${llvm_dir}
	${simd_dir}
)
set(execution
	${execution_dir}
)

#compiling the library of Query.
add_library(Executor SHARED ${execution})
#set(Executor_DEPENDENCY utils common)
#add_dependencies(Executor utils common)
#target_link_libraries(Executor ${Executor_DEPENDENCY})

install(TARGETS Executor
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION bin
	COMPONENT core
)
