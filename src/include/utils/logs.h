/***
 * Copyrights by Lihao
 * The log to write the log files in Transformer.
 * We can incorprate the log4cxx or other logger to impl.
 */

#ifdef __LOG_H__
#define __LOG_H__

//the encapsulated types in common.h
#include "../common/common.h" 
#include "../../3rd_party/log/include"

namespace Transformer
{
namespace Utils
{

//typedef Logger* TransLogger; 

class Logger 
{
  public:
     Logger();
     Logger(TChar* path, TUInt32 length);
     virtual ~Logger() final;
     
     //writing the log message into a log file.
     virtual TUInt32 write (const TChar* buffer, TUInt32 length);
  private:
    static TChar path_[MAX_LENGTH_PATH]={'0'};
    //static TransLogger log_;    
};


}	
}

#endif 
