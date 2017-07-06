#rewrite group.

set(rewrite
)

#rewrite Header files->rewrite
set(rewrite_header_files
	#$${SOURCE_DIR}/include/query/rewrite/xxx.h

)

#rewrite Source files->rewrite
set(rewrite_source_files
	#${SOURCE_DIR}/query/rewrite/xxx.cpp

)

# append all files to the QueryEngine
set (rewrite_dir
	${rewrite_dir}
	${Rewrite_header_files}
	${Rewrite_source_files}	
)

#set rewrite
set(rewrite
	${rewrite}
)

# the source groups
source_group("rewrite"    				        FILES ${rewrite_dir})
source_group("rewwrite\\include" 				FILES ${rewrite_header_files})
source_group("rewrite\\source"      			FILES ${rewrite_source_files})



