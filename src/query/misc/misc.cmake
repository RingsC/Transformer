#miscellaneous group.

set(misc
)

#misc Header files->rewrite
set(misc_header_files
    #$${SOURCE_DIR}/include/query/misc/debugger.h

)

#misc Source files->misc
set(misc_source_files
    #${SOURCE_DIR}/query/misc/debugger.cpp

)

# append all files to the QueryEngine
set (misc_dir
    ${misc_dir}
    ${misc_header_files}
    ${misc_source_files}
)

#set misc
set(misc
    ${misc}
)

# the source groups
source_group("misc"                          FILES ${misc_dir})
source_group("misc\\include"                FILES ${misc_header_files})
source_group("misc\\source"                  FILES ${misc_source_files})



