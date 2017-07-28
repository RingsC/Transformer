#miscellaneous part, including debugger, helper functions, etc.

#ifndef __MISC_H__
#define __MISC_H__
#include <system/system.h>
#include <types/types.h>

namespace Trasformer {
namespace parserN{

class Debugger : public NonCopyable {
public:
	Debugger ();
	~Debugger();

public:
	virtual print();	
} ;


} //namespace parserN.
} //namespace Transformer.	
#endif 
