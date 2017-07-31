#types group 

set(types
)
set(types_dir
)
#types Header files->types
set(Types_Header_files
	../include/types/types.h
	../include/types/nodes.h

)

#This module will be included in diff parts as a common module, such as  be included by query or executor. so 
#here, we use the full path but a relative path. 
#types Source files->types
set(Types_Source_files
	${CMAKE_SOURCE_DIR}/src/types/types.cpp
	${CMAKE_SOURCE_DIR}/src/types/nodes.cpp
)

source_group(""              FILES ${typdes_dir})
source_group("include" FILES ${Types_Header_files})
source_group("source" FILES ${Types_Source_files})


set (types_dir
	${types_dir}
	${Types_Header_files}
	${Types_Source_files}
)
set(types
	${types}
	${types_dir}
)
