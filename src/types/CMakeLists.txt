#types group 

set(types_dir
)


#types Header files->types
set(Types_Header_files
	../include/types/base_types.h
	../include/types/nodes.h
	../include/types/types_def.h

)

#types Source files->types
set(Types_Source_files
	#{SOURCE_DIR}/types/xxx.cpp

)

source_group(""              FILES ${typdes_dir})
source_group("include" FILES ${Types_Header_files})
source_group("source" FILES ${Types_Source_files})


set (types_dir
	${types_dir}
	${Types_Header_files}
	${Types_Source_files}
)
