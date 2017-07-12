/*****************
the type here 
*******************/

#ifndef __TYPES_H__
#define __TYPES_H__

#include "system/system.h"

namespace Transformer {
namespace Types {

class  NonCopyable{
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
