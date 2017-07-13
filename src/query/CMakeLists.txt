#add the directory to top

#includes the sub-directory cmake files in.
include(parser/parser.cmake)
include(analyze/analyze.cmake)
include(rewrite/rewrite.cmake)
include(optimizer/optimizer.cmake)

#lex.cmake included.
include(${CMAKE_MODULE_PATH}/lex.cmake)
RUN_LEX(${CMAKE_CURRENT_SOURCE_DIR}/parser/lex/scanner.l ${CMAKE_CURRENT_SOURCE_DIR}/parser/lex/scanner.cpp)
message(STATUS "The Lex file has been processed.")

#bison.cmake included.
include(${CMAKE_MODULE_PATH}/bison.cmake)
RUN_BISON(${CMAKE_CURRENT_SOURCE_DIR}/parser/grammar.y ${CMAKE_CURRENT_SOURCE_DIR}/parser/grammar.cpp ${CMAKE_CURRENT_SOURCE_DIR}/parser/grammar.h)
message(STATUS "The BISON file has been processed. ${CMAKE_CURRENT_SOURCE_DIR}/../include/query/parser/grammar.h")



#set the query files
set(query
	${query}
	${optimize}
	${parser}
	${rewrite}
	${analyze}
)

#the libs which is neeed by Query when we built Query dynamic library.
#set(query_DEPENDENCY
#)

add_library(Query SHARED ${query})
#add_dependencies(Query ${query_DEPENDENCY})
#target_link_libraries(Query ${Query_DEPENDENCY})

install(TARGETS Query
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION bin
	COMPONENT core
)
