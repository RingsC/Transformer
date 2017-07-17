#set llvm files.
set(llvm
)

set(llvm_dir
)
set(llvm_header_files
    ../include/execution/llvm/llvm.hpp
)
set(llvm_source_files
    llvm/llvm.cpp
)
set(llvm_dir
    ${llvm_dir}
    ${llvm_header_files}
    ${llvm_source_files}
)

set(llvm
	${llvm}
	${llvm_dir}
)
