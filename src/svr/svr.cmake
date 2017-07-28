# top-level files
set (Server
)

# include files
set (Server_include
)

# source files
set (Server_source
	main.cpp
)
if (MSVC)
set (Server_source
	${Server_source}
)
endif (MSVC)

# the source groups
source_group(""        FILES ${Server})
source_group("include" FILES ${Server_include})
source_group("source"  FILES ${Server_source})

# append all files to the Server
set (Server
	${Server}
	${Server_include}
	${Server_source}
)
if(MSVC)
	add_executable(Transformer ${Server})
	add_dependencies(Transformer Query Executor )
	target_link_libraries(Transformer Query Executor)
else(MSVC)
	add_executable(Transformer ${Server})
	add_dependencies(Transformer Query Executor)
	target_link_libraries(Transformer Query Executor)
endif(MSVC)
install(TARGETS Transformer 
	RUNTIME DESTINATION server/bin
	COMPONENT core)
