/********************************************************************************
* the raw syntax tree nodes definition. In this file we give the definitions of AST
* elements. SELECT clause, WHERE clause,etc.
*********************************************************************************/
#ifndef __NODES_TYPES_H__
#define __NODES_TYPES_H__

#include <types/types.h>
#include <system/system.h>

namespace Transformer{
namespace Types{

class TRANS_EXPORT  ASTNode : public NonCopyable {
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
	ASTNode() {}
	~ASTNode() {}
} ;


/*USED FOR INDICATES THE PHRASE OF SQL PROCESSING*/
typedef enum SQLPhrase{
	SQLPHRASE_UNTOUCHED = 0,
	/*FOR ANALYZE*/
	SQLPHRASE_BEFORE_ANALYZE ,
	SQLPHRASE_IN_ANALYZE,
	SQLPHRASE_AFTER_ANALYZEA,
		
	/*FOR REWRITEING*/
	SQLPHRASE_BEFORE_REWRITE,
	SQLPHRASE_IN_REWRITE,
	SQLPHRASE_AFTER_REWRITE,

	/*FOR*/
	SQLPHRASE_BEFORE_PLANNING,
	SQLPHRASE_IN_PLANNING,
	SQLPHRASE_AFTER_PLANNING,

	SQLPHRASE_RESERVED	
} SQLPhrase;

typedef enum SQLStmtType {
	STMT_UNKNOWN_TYPE=0,
	STMT_SQL_TYPE,
	STMT_SELECT_TYPE,
	STMT_INSERT_TYPE,
	STMT_UPDATE_TYPE,
	

	STMT_RESERVED_TYPE
} SQLStmtType ;

class TRANS_EXPORT SqlStmt : public ASTNode {
public:
	SqlStmt (): phrase_(SQLPHRASE_UNTOUCHED), type_(STMT_SQL_TYPE), parent_((ASTNode*)NULL){

	}
	explicit SqlStmt (ASTNode* parent):phrase_(SQLPHRASE_UNTOUCHED), type_(STMT_SQL_TYPE),parent_(parent) {}
	virtual ~SqlStmt () {}

	virtual void optimize () = 0;
private:
	SQLPhrase phrase_ ;
	SQLStmtType type_;
	ASTNode* parent_; 
} ;

class TRANS_EXPORT SelectStmt : public SqlStmt { 
public:
	SelectStmt ();
	explicit SelectStmt (const ASTNode*);
	explicit SelectStmt (const SelectStmt* parent);
	~SelectStmt(); 

	virtual void optimize ();
	
private:
	
};

class TRANS_EXPORT TargetEntry : public SqlStmt {
public:
	TargetEntry();
	~TargetEntry ();
	
	virtual void optimize () ;
} ;

class TRANS_EXPORT TargetList : public SqlStmt {
public:
	TargetList ();
	~TargetList ();

	virtual void optimize (); 
} ;

class TRANS_EXPORT FromStmt : public SqlStmt {
public:
	FromStmt ();
	~FromStmt ();
	
	virtual void optimize ();
} ;


class Expr; 
class TRANS_EXPORT WhereStmt : public SqlStmt {
public:
	WhereStmt () ;
	~WhereStmt (); 
	
	virtual void optimize ();
private:
	Expr* expr_ ;
} ;

class TRANS_EXPORT AggregateStmt : public SqlStmt {
public:
	AggregateStmt() ;
	~AggregateStmt ();

	virtual void optimize ();
} ;

class TRANS_EXPORT HavingStmt : public AggregateStmt {
public:
	HavingStmt();
	~HavingStmt();

	virtual void optimize ();	
} ;

class TRANS_EXPORT GroupByStmt : public AggregateStmt {
public:
	GroupByStmt ();
	~GroupByStmt ();

	virtual void optimize (); 
};

class TRANS_EXPORT Function : public SqlStmt {
public:
	Function ();
	~Function ();

	virtual void optimize ();
} ;


class TRANS_EXPORT Sum : public Function {
public:
	Sum(); 
	~Sum ();

	virtual void optimize();
} ;

class TRANS_EXPORT Avg : public Function {
public:
	Avg ();
	~Avg (); 
	
	virtual void optimize();
};

/*
class TRANS_EXPORT Operator : public SqlStmt {
public:
	Operator ();
	~Operator ();

	virtual void optimize ();
};
*/


//The definit of executable experssion clause.
class TRANS_EXPORT Expr : public SqlStmt {
public:
	Expr () ; 
	~Expr() ;

	virtual void optimize () ;
};

class TRANS_EXPORT And : public Expr {
public:
	And () ;
	~And () ;
	virtual Expr* reverse ();

	virtual void optimize ();
} ;

class TRANS_EXPORT Or : public Expr {
public:
	Or();
	~Or();
	
	virtual Expr* reverse ();
	virtual void optimize (); 
} ;






}//Types
}//Tansformer.
#endif //__NODES_TYPES_H__
