/***
THE KEYWORDS.

parser/keywords/keywords.h
*/

#ifndef __KEYWORDS_H__
#define __KEYWORDS_H__

#include "system.h"
#include "types/types.h"

namespace Transformer{
namespace KeyWords {

using namespace Types;

typedef enum {
	UNRESERVED_KEYWORD =0 ,  //
	COL_NAME_KEYWORD ,       //1
	TYPE_FUNC_NAME_KEYWORD,  //2
	RESERVED_KEYWORD
} KeyWordTypes; 

typedef struct scan_keywords_t
{
	const char* key_name; 
	int16 value; 
	KeyWordTypes catalog;
} ScanKeyWord ;


#define TRANS_KEYWORD(a,b,c) {a,b,c}

class TRANS_EXPORT KeyWord  
{
public:
	KeyWord () {}
	~KeyWord () {} 
	static ScanKeyWord KeyWordLookup(const char* keyword, const ScanKeyWord* kewords_list, int number_keywords);
	inline uint16 getKeyWordsNumber () const { return sizeof(KeyWord::scanKeyWordsList_)/sizeof(KeyWord::scanKeyWordsList_[0]) ;}
private:
	static const int32 MAX_KEYWORDS_NUMBER=1024;
	static ScanKeyWord scanKeyWordsList_ [MAX_KEYWORDS_NUMBER]; 
} ;	

} //Keywrods.
} //Transformer
#endif 

