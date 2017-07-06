#set the group name, Keywords.
set(keywords_dir
)

#Header files -> KeyWords
set(KeyWords_header_files
	../include/keywords/keywords.hpp

)

#Source files -> KeyWords
set(KeyWords_source_files
	keywords.cpp

)

# the source groups
source_group(""        FILES ${keywords_dir})
source_group("include" FILES ${KeyWords_header_files})
source_group("source"  FILES ${KeyWords_source_files})


# append all files to the Server
set (keywords_dir
	${keywords_dir}
	${KeyWords_header_files}
	${KeyWords_source_files}
)
