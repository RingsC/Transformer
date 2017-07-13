/***
THE KEYWORDS.

path:
	parser/keywords/keywords.h
**/

#ifndef __KEYWORDS_H__
#define __KEYWORDS_H__

#include "system/system.h"

namespace Transformer{
namespace KeyWords {

typedef enum {
	UNRESERVED_KEYWORD =0 ,  //
	COL_NAME_KEYWORD ,       //1
	TYPE_FUNC_NAME_KEYWORD,  //2
	RESERVED_KEYWORD
} KeyWordTypes; 

struct scan_keyword_t
{
	const char* key_name_; 
	int16 value_; 
	KeyWordTypes catalog_;
} ;

typedef struct scan_keyword_t* ScanKeyWord; 

#define TRANS_KEYWORD(a,b,c) {a,b,c}

class TRANS_EXPORT KeyWord  
{
public:
	KeyWord () {}
	~KeyWord () {} 
	static ScanKeyWord KeyWordLookup(const char* keyword, const ScanKeyWord kewords_list, int number_keywords);
	static uint16 getKeyWordsNumber () { return sizeof(KeyWord::scanKeyWordsList_)/sizeof(KeyWord::scanKeyWordsList_[0]) ;}
	static ScanKeyWord getScanKeyWord () { return scanKeyWordsList_;} 
private:
	static const int32 MAX_KEYWORDS_NUMBER=1024;
	static scan_keyword_t scanKeyWordsList_ [MAX_KEYWORDS_NUMBER]; 
} ;	

} //Keywrods.
} //Transformer
#endif 

