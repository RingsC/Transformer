#analyze group.

set(analyze
)

#analyze Header files->analyze
set(analyze_header_files
	#$${SOURCE_DIR}/include/query/analyze/xxx.h

)

#analyze Source files->analyze
set(analyze_source_files
	#${SOURCE_DIR}/query/analyze/xxx.cpp

)

# append all files to the QueryEngine
set (analyze_dir
	${analyze_dir}
	${analyze_header_files}
	${analyze_source_files}	
)
set(analyze
	${analyze}
)

# the source groups
source_group("analyze"    				        FILES ${analyze_dir})
source_group("analyze\\include" 				FILES ${analyze_header_files})
source_group("analyze\\source"      			FILES ${analyze_source_files})



