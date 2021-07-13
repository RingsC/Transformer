/* Copyrights by Lihao
 * Writing the logs into a file;
 */

#include "../include/utils/logs.h"

namespace Transformer
{
namespace Utils
{ //do initialzation
  //Logger::TransLogger = NULL; 

Logger::Logger()
{
}

virtual Logger::~Logger()
{
}

TUInt32 Logger::write(const TChar* buffer, TInt32 length)
{
   TUint32 ret= TRANS_SUCESS;
   return ret;
}

}
}
