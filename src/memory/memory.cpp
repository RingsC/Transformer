/********************
* the memory mainipulation functions here. 
*/
#include "include/memory/memory.h"

MemoryContext::MemoryContext()
{

}
MemoryContext::~MemoryContext()
{

}

void* MemoryContext::operator new (size_t size) 
{
	//allocate memory for sm.
	return NULL; 
}

void MemoryContext::delete(void* addr)
{
	return ; 
}

void* MemoryContext::operator new[] (size_t size)
{

	return NULL; 
}

void MemoryContext::delete[](void* addr, size_t size)
{
	return ; 
}
