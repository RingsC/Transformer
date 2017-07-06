/*
*  A new query engines for Transformer.
*  Author :
*  Date:
*/

#ifndef __PARSER_H__
#define __PARSER_H__

#include "types/types.h"
#include "system/system.h"

namespace Transformer{
namespace Parser{

using namespace Types ;
class ASTNode;

class TRANS_EXPORT Parser : public NonCopyable {
public:
	Parser () {}
	~Parser() {}
	virtual ASTNode* raw_parser(const char* str); 	
} ;


}//namespace Parser. 
}//namespace Transformer.
#endif   /* PARSER_H */
