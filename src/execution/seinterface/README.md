In this folder, we want to provide an interfance of storage engines, for example, rocksdb, pg, innodb, etc. 

//to get params of se. 
class SeInforation {
public:
	bool isTxnSupported () =0;
	//kv, rds.	
	SeType getStorageType ()=0 ; 
	...
} ;

class seInterface {
public:
	
	virtual bool initialize () =0;
	virtual void deinitialize () =0;
	virtual void startTransaction () =0;
	virtual void commit () =0;
	virtual void rollback () =0;
	...
private:
	StorageEngine* seHandler_ ;	 
}

class RocksDB : public seInterface {

} ;

class Postgres : public seInterface {

} ;

class InnoDB : public : seInterface {

};

...

