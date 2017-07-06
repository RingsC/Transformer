#the group name
set(memory_dir
)

#Header files- > Memory mainipulation functions Header files.
set(Memory_header_files
	../include/memory/memory.h
)

#Source files -> Memory mainipulation functions Source files.
set(Memory_source_files
	memory.cpp
)


# the source groups
source_group(""        FILES ${memory})
source_group("include" FILES ${Memory_header_files})
source_group("source"  FILES ${Memory_source_files})

# append all files to the Server
set (memory_dir
	${memory_dir}
	${Memory_header_files}
	${Memory_source_files}
)
