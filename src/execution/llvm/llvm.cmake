#set llvm files.
set(llvm
)

set(llvm_dir
)
set(llvm_header_files
    ../include/execution/llvm/llvm.hpp
)
set(gpu_source_files
    llvm/llvm.cpp
)
set(llvm_dir
    ${llvm_dir}
    ${llvm_header_files}
    ${llvm_source_files}
)

set(llvm_dir
	${llvm_dir}
	${llvm_header_files}
)

set(llvm
	${llvm}
	${llvm_dir}
)

source_group("llvm"                      FILES ${llvm_base})
source_group("llvm//include"             FILES ${llvm_header_files})
source_group("llvm//source"              FILES ${llvm_source_files})

