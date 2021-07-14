/*  Copyrights by lihao
 *  Storage Engine interface. to support the different storage engine interface. 
 *  
 */

#include "../../include/storage_interface/storage_interface.h"
namespace Transformer
{
namespace StorageInterface
{
  
  //ctor
  StorageInterfacePG::StorageInterfacePG()
  {}
  
  //dctor
  StorageInterfacePG::~StorageInterfacePG()
  {}
  
  //init the storage engine
  TBool StorageInterfacePG::intialization()
  {
    TBool ret(false);
    return ret;
  }

  //deinit the storage engien
  TBool StorageInterfacePG::deintialization()
  {
    TBool ret(false);
    return ret;
  };
  
  TBool StorageInterfacePG::seq_scan()
  {
    TBool ret(false);
    return ret;
  }

  TBool StorageInterfacePG::index_scan()
  {
    TBool ret(false);
    return ret;
  }

  TPointer StorageInterfacePG::next()
  {
    TPointer pt(nullptr);
    return pt;
  }

  TPointer StorageInterfacePG::forward()
  {
    TPointer pt(nullptr);
    return pt;
  }


  //ctor
  StorageInterfaceMySQL::StorageInterfaceMySQL()
  {}
  
  //dctor
  StorageInterfaceMySQL::~StorageInterfaceMySQL()
  {}
  
  //init the storage engine
  TBool StorageInterfaceMySQL::intialization()
  {
    TBool ret(false);
    return ret;
  }

  //deinit the storage engien
  TBool StorageInterfaceMySQL::deintialization()
  {
    TBool ret(false);
    return ret;
  }

  TBool StorageInterfaceMySQL::seq_scan()
  {
    TBool ret(false);
    return ret;
  }

  TBool StorageInterfaceMySQL::index_scan()
  {
    TBool ret(false);
    return ret;
  }

  TPointer StorageInterfaceMySQL::next()
  {
    TPointer pt(nullptr);
    return pt;
  }

  TPointer StorageInterfaceMySQL::forward()
  {
    TPointer pt(nullptr);
    return pt;
  }
} //StorageInterface
} //Transformer

