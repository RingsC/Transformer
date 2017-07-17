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

#lex Header files -> lex
set(lex_header_files
	../include/query/parser/lex/scannerGramm.h
	../include/query/parser/lex/lexical.h
	#../include/query/parser/lex/scanner_lex.h
)
#lex Source files -> lex
set(lex_source_files
	parser/lex/scanner.cpp
	parser/lex/lexical.cpp
)

#set the parser source/header files.
set(parser
	${parser}
	${parser_source_files}
	${parser_header_files}
	${lex_source_files}
	${lex_header_files}
)


#set the source group.
source_group("parser"				FILES ${parser_base})	
source_group("parser\\include"		FILES ${parser_header_files})
source_group("parser\\soruce"		FILES ${parser_source_files})			

source_group("lex"					FILES ${lex_base})
source_group("lex\\include"			FILES ${lex_header_files})
source_group("lex\\source"			FILES ${lex_source_files})

