#Adding the subdirectory into top, and including all the source files and header files into, then setting the source group.

set(storage_interface
)

#set the execution head files
set(storage_interface_header_files
    ../include/storage_interface/storage_interface.h
)
set(storage_interface_source_files
	storage_interface.cpp
)

#set the storage interface source files.
set(storage_interface_dir
	${storage_interface_dir}
	${storage_interface_header_files}
	${storage_interface_source_files}
)
set(storageinterface
	${storage_interface_dir}
)

source_group(""             FILES ${execution_dir})
source_group("include"  	FILES ${storage_interface_header_files})
source_group("source"  		FILES ${storage_interface_source_files})

#compiling the library of storage interface.
add_library(StorageInterface SHARED ${storageinterface})
#set(Executor_DEPENDENCY utils common)
#add_dependencies(Executor utils common)
#target_link_libraries(Executor ${Executor_DEPENDENCY})

install(TARGETS StorageInterface 
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION bin
	COMPONENT core
)
