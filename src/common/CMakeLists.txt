#the configure the 'common', include the source files and header files into, and then creating the source group.
set(common_dir
)

set(Common_header_files
	../include/common/common.h
)

set(Common_source_files
	common.cpp
)

# the source groups
source_group(""        FILES ${common_dir})
source_group("include" FILES ${Common_header_files})
source_group("source"  FILES ${Common_source_files})

# append all files to the common_dir 
set (common_dir
	${common_dir}
	${Common_header_files}
	${Common_source_files}
)
