/***
THE KEYWORDS definition.

path:
	parser/keywords/keywords.h
**/

#ifndef __KEYWORDS_H__
#define __KEYWORDS_H__

#include <system/system.h>

namespace Transformer{
namespace ParserN {

typedef enum KeyWordTypes {
	UNRESERVED_KEYWORD =0 ,  //
	COL_NAME_KEYWORD ,       //1
	TYPE_FUNC_NAME_KEYWORD,  //2
	RESERVED_KEYWORD
} KeyWordTypes; 

typedef struct scan_keyword_t
{
	const char* key_name_; 
	int16 value_; 
	KeyWordTypes catalog_;
} scan_keyword_t, *scan_keyword_ptr;

typedef struct scan_keyword_t* ScanKeyWord; 

#define TRANS_KEYWORD(a,b,c) {a,b,c}

class TRANS_EXPORT KeyWord  
{
public:
	KeyWord () {}
	~KeyWord () {} 
	static ScanKeyWord KeyWordLookup(const char* keyword, const ScanKeyWord keywords_list, int number_keywords);
	static uint16 getKeyWordsNumber () { return sizeof(KeyWord::scanKeyWordsList_)/sizeof(KeyWord::scanKeyWordsList_[0]) ;}
	static ScanKeyWord getScanKeyWord () { return scanKeyWordsList_;} 
private:
	static const uint32 MAX_KEYWORDS_NUMBER= 512;
	static scan_keyword_t scanKeyWordsList_ [MAX_KEYWORDS_NUMBER]; 
} ;	

} //Keywrods.
} //Transformer
#endif 

