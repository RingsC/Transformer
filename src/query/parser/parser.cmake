#the parser group. 
set(parser
)

#Parser Head files -> Parser
set(parser_header_files
	../include/query/parser/parser.h
	../include/query/parser/helper.h
	#../include/query/parse/grammar.h	
	../include/query/parser/parserGramm.h
)

#Parser Source files -> Parser
set(parser_source_files
	parser/parser.cpp
	parser/helper.cpp
	parser/grammar.cpp
)

#the lex source/header files.
set(lex_dir
)
#lex Header files -> lex
set(lex_header_files
	../include/query/parser/lex/scanner.h
	
)
#lex Source files -> lex
set(lex_source_files
	parser/lex/scanner.cpp
)

set(lex_dir
	${lex_idr}
	${lex_header_files}
	${lex_source_files}
)

#set the parser source/header files.
set(parser
	${parser}
	${parser_source_files}
	${parser_header_files}
	${lex_dir}
)


#set the source group.
source_group("parser"				FILES ${parser_dir})	
source_group("parser\\include"		FILES ${parser_header_files})
source_group ("parser\\soruce"		FILES ${parser_source_files})			
source_group("lex"					FILES ${lex_dir})
source_group("lex\\include"			FILES ${lex_header_files})
source_group("lex\\source"			FILES ${lex_source_files})

