/******************
*
*  system varaibles of Transformer.
*
*********************/

#ifndef __SYSTEM_H__
#define __SYSTEM_H__

#include <assert.h>

#if defined (_WIN32) || defined (__WIN32__)
#define __UNDER_WINDOWS__
#else
#define __UNDER_LINUX__
#endif

#ifdef __GNUC__

#define TRANS_ATTRIBUTE(ATTR) __attribute__((ATTR))
#define TRANS_UNUSED TRANS_ATTRIBUTE(unused)

#define LIKELY(cond) __builtin_expect(!!(cond),1) 
#define UNLIKELY(cond) __builtin_expect(!!(cond),0) 
#elif defined (__IBMC__)

#endif 

/**************TO DEFINE THE EXPORT OR IMPORT OF DLL INTERFACE.*********************************/
#if defined(_MSC_VER)

#if !defined(TRANS_EXPORT)
#if defined(TRANS_CREATE_DLL)

#define TRANS_EXPORT __declspec(dllexport)
#define TRANS_EXPORT_TEMPLATE template class TRANS_EXPORT
#else
#define TRANS_EXPORT __declspec(dllimport)
#define TRANS_EXPORT_TEMPLATE extern template class TRANS_EXPORT
#endif
#endif
#else // !_MSC_VER
// Building on a non-Windows platform.
#define TRANS_EXPORT 
#define	TRANS_EXPORT_TEMPLATE template class
#endif // !_MSC_VER

/**************THE ALIGNMENT MARCO DEFINITIONS ************************************************/
#define ALIGN_TYPE(len,type) ((uintptr_t)((len) + ((type)-1))) &  ~((uintptr_)((type)-1))   
#define ALIGN_TYPE_LOWER(len,type)  ((uintptr_t)(len)) & ~((uintptr_t)((type) -1)) 

/**************THE ASSERTATION DEFINITIONS***************************************************/
#define TRANS_ASSERT(cond) assert(cond)

/**************THe typedef for types.********************************************************/
//the typedef for types
typedef char           uint8;
typedef unsigned short uint16;
typedef unsigned int   uint32;
typedef unsigned long  uint64;
typedef unsigned long long uint128;


typedef short          int16;
typedef int            int32;
typedef long           int64;
typedef long long      int128;
typedef bool		   BOOL;

#ifndef NULL
#define NULL          ((void*) 0)
#endif

/******************************other things.**********************************************/
#define HIGHBIT					(0x80)
#define IS_HIGHBIT_SET(ch)		((unsigned char)(ch) & HIGHBIT)

#define STATUS_OK				(0)
#define STATUS_ERROR			(-1)
#define STATUS_EOF				(-2)
#define STATUS_FOUND			(1)
#define STATUS_WAITING			(2)


#define NAMEDATALEN 64
#endif  //__SYSTEM_H__
