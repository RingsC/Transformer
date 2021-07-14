/* Copyrights by Lihao 
 * In this file we define a lot of common types used in this project.$
 * Such as, typedefed types, or the others.
 * DO NOT USE THE RAW TYPES DIRECTLY, JUST USING THE ENCAPSULATED TYPES.
 * */
#ifndef __COMMON_H__
#define __COMMON_H__

#include <sys/types.h>

namespace Transformer
{
  typedef void            TVoid;
#if defined(_WIN32) || defined(WIN32)
  typedef char             TChar;
  typedef char*            TPointer;
  typedef unsigned int     TUInt32;
  typedef int              TInt32;
  typedef unsigned long    TULong32;
  typedef long             TLong32;
  typedef bool             TBool;

#else
  typedef char             TChar;
  typedef char*            TPointer;
  typedef u_int32_t         TUInt32;
  typedef int32_t          TInt32;
  typedef bool             TBool;
#endif //defined(_WIN32)
  
  constexpr TUInt32 MAX_LENGTH_PATH = 1024;
  constexpr TInt32 TRANS_SUCESS = 0;
  constexpr TInt32 TRANS_FAILED = -1;  
} //namespace

#endif //__COMMON_H__

