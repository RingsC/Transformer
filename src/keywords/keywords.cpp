/**
* the keywords.
*/

#include "keywords.h"

namespace Transformer {
namespace Keywords{

KeyWord::scanKeyWordsList_[] ={
	TRANS_KEYWORD("abort",ABORT_P, UNRESERVED_KEYWORD),
	TRANS_KEYWORD("absolute",ABSOLUTE_P,UNRESERVED_KEYWORD)
}

ScanKeyWord
KeyWord::KeyWordLookup (const char* keyword, const ScanKeyWord kewords_list, int number_keywords )
{
	ScanKeyWord key ;
	return key;

}


}//Keywords.
}//Transformer 
