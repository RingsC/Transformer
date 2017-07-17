#Adding the subdirectory into top, and including all the source files and header files into, then setting the source group.

set(execution
)
include(gpu/gpu.cmake)
include(llvm/llvm.cmake)
include(simd/simd.cmake)


#set the execution head files
set(execution_header_files
	../include/execution/seqscan.hpp
	../include/execution/tidscan.hpp
	../include/execution/indexscan.hpp
)
set(execution_source_files
	seqscan.cpp
	tidscan.cpp
	indexscan.cpp
)

#set the execution source files.
set(execution_dir
	${execution_dir}
	${execution_header_files}
	${execution_source_files}
	${gpu_dir}
	${llvm_dir}
	${simd_dir}
)
set(execution
	${execution_dir}
)

source_group(""			FILES ${execution_dir})

source_group("\\gpu"  			FILES ${gpu_base})
source_group("\\gpu\\include"  	FILES ${gpu_header_files})
source_group("\\gpu\\source"  	FILES ${gpu_source_files})

source_group("\\llvm" 				FILES ${llmv_base})
source_group("\\llvm\\include"  	FILES ${llvm_header_files})
source_group("\\llvm\\source"  		FILES ${llvm_source_files})

source_group("\\simd" 				FILES ${simd_base})
source_group("\\simd\\include"  	FILES ${simd_header_files})
source_group("\\simd\\source"  		FILES ${simd_source_files})


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
