/*****************
the type definition here 
path:include/types/types.h
*******************/

#ifndef __TYPES_H__
#define __TYPES_H__

namespace Transformer {
namespace Types {

class  NonCopyable {
public:
	NonCopyable ();
	~NonCopyable ();
protected:
    NonCopyable (const NonCopyable& ) ;
    NonCopyable& operator = (const NonCopyable& ) ;
};


} //Types;
} //namespace transf

#endif //__TYPES_H__
