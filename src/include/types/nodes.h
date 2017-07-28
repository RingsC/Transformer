/********************************************************************************
* the raw syntax tree nodes definition. In this file we give the definitions of AST
* elements. SELECT clause, WHERE clause,etc.
*********************************************************************************/
#ifndef __NODES_H__
#define __NODES_H__

#include "types/types.h"

namespace Transformer{
namespace Types{

class TRANS_EXPORT ASTNode :public NonCopyable {
public:
	typedef enum node_type_t {
		NODE_TYPE_NONE =0,
		NODE_TYPE_SQL,
		NODE_TYPE_SELECT_STMT, 
		NODE_TYPE_TARGETLIST_STMT,
		NODE_TYPE_FROM_STMT, 
		NODE_TYPE_WHERE_STMT, 
		NODE_TYPE_HAVING_STMT,
		NODE_TYPE_GROUPBY_STMT, 
		NODE_TYPE_JOIN_STMT,

		NODE_TYPE_PLAN,
		NODE_TYPE_RESULT_PLAN,
		NODE_TYPE_PROJECTSET_PLAN,
		NODE_TYPE_MODIFYTABLE_PLAN,
		NODE_TYPE_APPEND_PLAN,
		NODE_TYPE_MERGEAPPEND_PLAN,
		NODE_TYPE_RECURSIVEUNION_PLAN,
		NODE_TYPE_BITMAPAND_PLAN, 
		NODE_TYPE_BITMAPOR_PLAN,

		NODE_TYPE_SCAN_PLAN,
		NODE_TYPE_SEQSCAN_PLAN,
		NODE_TYPE_SAMPLESCAN_PLAN,
		NODE_TYPE_INDEXSCAN_PLAN,		
	
		NODE_TYPE_EXECUTOR,	
		NODE_TYPE_RESERVED_1,
		NODE_TYPE_RESERVED_2,
		NODE_TYPE_RESERVED_N
	} NodeType;

	NodeType nodeType_;
public:
	ASTNode() ;
	~ASTNode(); 
	virtual void optimize ()=0;
} ;


/*USED FOR INDICATES THE PHRASE OF SQL PROCESSING*/
typedef enum SQLPhrase{
	UNTOUCHED = 0,
	/*FOR ANALYZE*/
	BEFORE_ANALYZE ,
	IN_ANALYZE,
	AFTER_ANALYZEA,
		
	/*FOR REWRITEING*/
	BEFORE_REWRITE,
	IN_REWRITE,
	AFTER_REWRITE,

	/*FOR*/
	BEFORE_PLANNING,
	IN_PLANNING,
	AFTER_PLANNING,

	RESERVED	
} SQLPhrase;

class TRANS_EXPORT SqlStmt : public ASTNode {
public:
	SqlStmt ();
	explicit SqlStmt (ASTNode* parent) ;
	~SqlStmt () ;
private:
	SQLPhrase phrase_ ;
	ASTNode* parent_; 
} ;

class TRANS_EXPORT SelectStmt : public SqlStmt { 
public:
	SelectStmt ();
	explicit SelectStmt (ASTNode*) ;
	~SelectStmt(); 
private:
	
};


//The definit of executable experssion clause.
class TRANS_EXPORT Expr : public ASTNode {
public:
	Expr ()  {}
	~Expr() {}
};

}//Types
}//Tansformer.
#endif //__NODES_H__
