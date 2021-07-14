/* Copyrights by lihao
 *
 * storage engine interface.
 *
 */
#ifndef __STORAGE_ENGINE_INTERFACE_H__
#define __STORAGE_ENGINE_INTERFACE_H__
#include "../../include/common/common.h"
#include "../../include/types/types.h"

using Transformer::Types::NonCopyable;

namespace Transformer
{
namespace StorageInterface
{
  //Scan context is needed here. 
  class StorageContext : public NonCopyable 
  {
    
  };
  //the interface of a storage engine.
  class StorageInterface : public NonCopyable 
  {
     public:
        StorageInterface();
        virtual ~StorageInterface();
     public:
        virtual TBool intialization() =0;
        virtual TBool deintialization() =0;
        virtual TBool seq_scan() =0;
        virtual TBool index_scan() =0;
        virtual TPointer next() =0;
        virtual TPointer forward() =0;
        //.... 
  };
  

  class StorageInterfacePG : public StorageInterface
  {
     public:
        StorageInterfacePG();
        virtual ~StorageInterfacePG();
     public:
        TBool intialization() final;
        TBool deintialization() final; 
        TBool seq_scan() final;
        TBool index_scan() final;
        TPointer next() final;
        TPointer forward() final;
  };

  class StorageInterfaceMySQL : public StorageInterface
  {
    public:
      StorageInterfaceMySQL();
      virtual ~StorageInterfaceMySQL();
    public:
        TBool intialization() final;
        TBool deintialization() final;
        TBool seq_scan() final;
        TBool index_scan() final;
        TPointer next() final;
        TPointer forward() final;        
  };
   
  //the other storage engine interface, here.
}
}

#endif
