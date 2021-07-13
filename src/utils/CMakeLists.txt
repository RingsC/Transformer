#the configure the 'utils', include the source files and header files into, and then creating the source group.
set(utils_dir
)

set(utils_header_files
	../include/utils/logs.h
)

set(utils_source_files
	logs.cpp
)

# the source groups
source_group(""        FILES ${utils_dir})
source_group("include" FILES ${utils_header_files})
source_group("source"  FILES ${utils_source_files})

# append all files to the utils_dir 
set (utils_dir
	${utils_dir}
	${utils_header_files}
	${utils_source_files}
)
