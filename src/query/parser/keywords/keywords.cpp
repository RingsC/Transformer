/**
* the keywords definition.
* path: query/parser/keywords/keywords.cpp
*/

#include <keywords/keywords.h>
#include <parser/parserGramm.h>

namespace Transformer {
namespace ParserN{

scan_keyword_t KeyWord::scanKeyWordsList_[] ={
	TRANS_KEYWORD("abort",ABORT_P, UNRESERVED_KEYWORD),
	TRANS_KEYWORD("absolute",ABSOLUTE_P,UNRESERVED_KEYWORD)
};

ScanKeyWord
KeyWord::KeyWordLookup (const char* keyword, const ScanKeyWord kewords_list, int number_keywords )
{
	ScanKeyWord key(NULL) ;
	return key;

}


}//ParserN.
}//Transformer 
