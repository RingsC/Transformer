/***********
* memory mainupulation. 
* INDENT: include/system/system.h
************/

#ifndef __MEMORY_H__
#define __MEMORY_H__

#include <new>
#include "system/system.h"

namespace Transformer {
namespace Memory {

class TRANS_EXPORT MemoryContext {
public:
	MemoryContext () ;
	~MemoryContext();
	
	void* operator new (size_t size) ;
	void operator delete(void* addr) ;
	
	void* operator new[] (size_t size) ;
	void operator delete[] (void* addr, size_t size) ;
} ;

}//namespace memory
}//namespace transformer.
#endif
