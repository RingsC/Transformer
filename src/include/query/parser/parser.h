/*
*  A new query engines for Transformer.
*  Author :
*  Date:
*/

#ifndef __PARSER_H__
#define __PARSER_H__

#include "types/types.h"
#include "types/nodes.h"
#include "system/system.h"


namespace Transformer{
namespace ParserN{

class TRANS_EXPORT Parser : public Transformer::Types::NonCopyable {
public:
	Parser () ;
	~Parser() ;
	virtual Transformer::Types::ASTNode* raw_parser(const char* str); 	
} ;


}//namespace Parser. 
}//namespace Transformer.


#endif   /* __PARSER_H__ */
