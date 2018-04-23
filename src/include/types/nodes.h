/********************************************************************************
* the raw syntax tree nodes definition. In this file we give the definitions of AST
* elements. SELECT clause, WHERE clause,etc.
*********************************************************************************/
#ifndef __NODES_TYPES_H__
#define __NODES_TYPES_H__

#include <string>
#include <vector>
#include <list>

#include <types/types.h>
#include <system/system.h>

namespace Transformer{
namespace Types{


using std::string; 
using std::vector;
using std::list;

class TRANS_EXPORT  ASTNode : public NonCopyable {
public:
	typedef enum node_type_t {
		NODE_TYPE_NONE =0,
		NODE_TYPE_SQL,

		NODE_TYPE_TARGETENTRY,
		NODE_TYPE_TARGETENTRY_LIST,

		NODE_TYPE_TABLEENTRY,
		NODE_TYPE_TABLEENTRY_LIST,	

		NODE_TYPE_SELECT_STMT, 
		NODE_TYPE_TARGETLIST_STMT,
		NODE_TYPE_FROM_STMT, 
		NODE_TYPE_WHERE_STMT, 

		NODE_TYPE_AGGREGATE_STMT,
		NODE_TYPE_HAVING_STMT,
		NODE_TYPE_GROUPBY_STMT, 
		NODE_TYPE_ORDERBY_STMT,

		NODE_TYPE_JOIN_STMT,
		NODE_TYPE_JOIN_MERGE,
		NODE_TYPE_JOIN_HASH,
		NODE_TYPE_JOIN_NSETLOOP,

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

		NODE_TYPE_FUNCTION,
		NODE_TYPE_FUNCTION_SUM,
		NODE_TYPE_FUNCTION_AVG,
		
		NODE_TYPE_EXPR, 
		NODE_TYPE_EXPR_AND,
		NODE_TYPE_EXPR_OR,
		
			
		NODE_TYPE_EXECUTOR,	
		NODE_TYPE_RESERVED_1,
		NODE_TYPE_RESERVED_2,
		NODE_TYPE_RESERVED_N
	} NodeType;

	ASTNode() {}
	virtual ~ASTNode() {}
	ASTNode(NodeType type) {
		nodeType_ = type; 
	}
	NodeType getNodeType ()const  {return nodeType_;}
private:
	NodeType nodeType_;
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
	SqlStmt ():ASTNode(NODE_TYPE_SQL),  phrase_(SQLPHRASE_UNTOUCHED), type_(STMT_SQL_TYPE), parent_((ASTNode*)NULL){

	}
	explicit SqlStmt (NodeType type) : ASTNode(type),  phrase_(SQLPHRASE_UNTOUCHED), type_(STMT_SQL_TYPE), parent_((ASTNode*)NULL){

	}
	explicit SqlStmt (ASTNode* parent):ASTNode(NODE_TYPE_SQL), phrase_(SQLPHRASE_UNTOUCHED), type_(STMT_SQL_TYPE),parent_(parent) {
	
	}
	
	
	virtual ~SqlStmt () {}

	virtual void optimize () = 0;
	virtual const char* toString() = 0;

	//to release itself.
	virtual void release() =0;

	virtual ASTNode* getParent() const {return parent_;}

	SQLPhrase getSQLPhrase() const { return phrase_;}
	SQLStmtType getSQLStmtType () const { return type_;}
private:
	SQLPhrase phrase_ ;
	SQLStmtType type_;
	ASTNode* parent_; 
} ;


//The placeholder. ?
class TRANS_EXPORT PlaceHolder : public SqlStmt {
public:
	PlaceHolder ();
	PlaceHolder (ASTNode* parent);
	virtual ~PlaceHolder();
	
	virtual void optimize();
	virtual const char* toString();
	virtual void release();	
} ;

class TRANS_EXPORT TargetEntry : public SqlStmt {
public:
	TargetEntry();
	TargetEntry(const char* targetName) ;
	virtual ~TargetEntry ();
	
	virtual void optimize () ;
	virtual const char* getTargetName () const { return targetName_;}
	virtual const char* toString(); 
	virtual void release(); 
private:
	static const uint16 max_targetName_length= 128;
	char targetName_[max_targetName_length];
} ;

class TRANS_EXPORT TargetList : public SqlStmt {
public:
	TargetList ();
	virtual ~TargetList ();

	virtual void optimize (); 
	virtual void addEntry (TargetEntry* entry) ;
	virtual void addEntry (ASTNode* entry) ;
	
	virtual void mergeEntries(ASTNode* target);
	virtual void mergeEntries(TargetList* targetList) ;

	virtual uint32 getEntryNum () const { return entries_.size();};
	virtual const char* toString ();
	virtual void release();
private: //Here, we will use the a vector to store entries.
	vector<TargetList*> entries_;	
} ;

class TRANS_EXPORT TableEntry : public SqlStmt {
public:
	TableEntry ();
	TableEntry (const char* tableName) ;
	virtual ~TableEntry ();
	
	virtual void optimize();	
	virtual const char* getName () const { return name_;}
	virtual const char* toString ();
	virtual void release();
private:
	//The length of table name will be read from conf in future.
	static const uint32 max_length_table_name= 128; 
	char name_[max_length_table_name] ; 	
};

class TRANS_EXPORT TableEntryList : public SqlStmt {
public:
	TableEntryList();
	virtual ~TableEntryList();
	
	virtual void addTableEntry (TableEntry* table) ;
	virtual void addTableEntry (ASTNode* table);
	
	virtual void mergeTableList (TableEntryList* table_list) ;
	virtual void mergeTableList (ASTNode* table_list);
	
	virtual uint32 getTableNum () const { return tables_.size();}	

	virtual void optimize();
	virtual const char* toString();
	virtual void release();
private:
	list<TableEntry*> tables_;
};

class TRANS_EXPORT IntoStmt : public SqlStmt {
public:
	IntoStmt ();
	virtual ~IntoStmt();

	virtual void optimize();
	virtual const char* toString();
	virtual void release();
} ;
class TRANS_EXPORT FromStmt : public SqlStmt {
public:
	FromStmt ();
	virtual ~FromStmt ();
	
	virtual void setTableEntryList (TableEntryList* tables);
	virtual void setTableEntryList (ASTNode* tables);
	virtual void optimize ();
	virtual const char* toString();
	virtual void release();
private:
	TableEntryList* tables__;	
} ;


class Expr; 
class TRANS_EXPORT WhereStmt : public SqlStmt {
public:
	WhereStmt () ;
	WhereStmt (Expr* expr) ;
	virtual ~WhereStmt (); 
		
	virtual void optimize ();
	virtual void setExpr (Expr* expr) { expr_ =  expr;}
	virtual Expr* getExpr () const {return expr_;}

	virtual const char* toString();
	virtual void release();
private:
	Expr* expr_ ;
} ;

class TRANS_EXPORT AggregateStmt : public SqlStmt {
public:
	AggregateStmt() ;
	virtual ~AggregateStmt ();

	virtual void optimize ();
	virtual const char* toString();
	virtual void release();
protected:
	explicit AggregateStmt(NodeType type);
} ;

class TRANS_EXPORT HavingStmt : public AggregateStmt {
public:
	HavingStmt();
	virtual ~HavingStmt();

	virtual void optimize ();	
	virtual const char* toString();
	virtual void release();
} ;

class TRANS_EXPORT GroupByStmt : public AggregateStmt {
public:
	GroupByStmt ();
	virtual ~GroupByStmt ();

	virtual void optimize (); 
	virtual const char* toString();
	virtual void release();
};

class TRANS_EXPORT OrderByStmt : public AggregateStmt {
public:
	OrderByStmt();
	virtual ~OrderByStmt();

	virtual void optimize();
	virtual const char* toString();
	virtual void release();
};
class TRANS_EXPORT LimitStmt : public AggregateStmt {
public:
	LimitStmt ();
	virtual ~LimitStmt ();
	
	virtual void optimize (); 
	virtual const char* toString();
	virtual void release();
} ;

class TRANS_EXPORT Function : public SqlStmt {
public:
	Function ();
	virtual ~Function ();
	
	virtual void optimize ();
	virtual const char* toString();
	virtual void release();
protected:
	explicit Function(NodeType type) ;
} ;


class TRANS_EXPORT Sum : public Function {
public:
	Sum(); 
	virtual ~Sum ();

	virtual void optimize();
	virtual const char* toString();
	virtual void release(); 
} ;

class TRANS_EXPORT Avg : public Function {
public:
	Avg ();
	virtual ~Avg (); 
	
	virtual void optimize();
	virtual const char* toString();
	virtual void release();
};

/*
class TRANS_EXPORT Operator : public SqlStmt {
public:
	Operator ();
	virtual ~Operator ();

	virtual void optimize ();
	virtual const char* toString();
	virtual void release();
};
*/

//The definit of executable experssion clause.
class TRANS_EXPORT Expr : public SqlStmt {
public:
	Expr () ; 
	virtual ~Expr();

	virtual void optimize ();
	virtual const char* toString();
	virtual void release();
protected:
	explicit Expr(NodeType type);
};

class TRANS_EXPORT And : public Expr {
public:
	And () ;
	virtual ~And ();
	
	virtual Expr* reverse ();
	virtual void optimize ();
	virtual const char* toString();
	virtual void release();	
} ;

class TRANS_EXPORT Or : public Expr {
public:
	Or();
	virtual ~Or();
	
	virtual Expr* reverse ();
	virtual void optimize (); 
	virtual const char* toString ();
	virtual void release ();
} ;


class TRANS_EXPORT SelectStmt : public SqlStmt { 
public:
	SelectStmt ();
	explicit SelectStmt (ASTNode* parent);
	explicit SelectStmt (SelectStmt* parent);
	virtual ~SelectStmt (); 

	virtual void optimize();
	virtual void release();
	
	virtual inline BOOL haveGroupByStmt ()const { return (groupByStmt_)? true : false ;} 
	virtual inline BOOL haveHavingStmt () const { return (havingStmt_)? true : false;}
	virtual inline BOOL haveOrderByStmt () const {return (orderByStmt_)? true : false;}	

	virtual inline void setTargetList (TargetList* targetList) { targetList_ = targetList; }
	virtual inline TargetList* getTargetList () const { return targetList_;}

	virtual inline void setIntoStmt(IntoStmt* intoStmt) {intoStmt_ = intoStmt;}
	virtual inline IntoStmt* getIntoStmt() const {return intoStmt_;}
	
	virtual inline void setFromStmt(FromStmt* fromStmt) { fromStmt_= fromStmt; }
	virtual inline FromStmt* getFromStmt () const { return fromStmt_;}

	virtual inline void setWhereStmt (WhereStmt* whereStmt) { whereStmt_ = whereStmt;}
	virtual inline WhereStmt* getWhereStmt () const {return whereStmt_;}

	virtual inline void setGroupByStmt(GroupByStmt* groupByStmt) { groupByStmt_ = groupByStmt;}
	virtual inline GroupByStmt* getGroupByStmt () const {return groupByStmt_ ;}

	virtual inline void setHavingStmt(HavingStmt* havingStmt) { havingStmt_ = havingStmt;}
	virtual inline HavingStmt* getHavingStmt ()	const {return havingStmt_;}

	virtual inline void setOderByStmt(OrderByStmt* orderByStmt) {orderByStmt_ = orderByStmt;}
	virtual inline OrderByStmt* getOrderByStmt () const {return orderByStmt_;}

	virtual const char* toString();
private:
	TargetList*     targetList_;
	IntoStmt* 		intoStmt_;
	FromStmt*       fromStmt_; 
	WhereStmt*      whereStmt_; 
	
	GroupByStmt* 	groupByStmt_;
	HavingStmt*     havingStmt_;
	OrderByStmt*    orderByStmt_;		

	ASTNode* 		parent_;
};

}//Types
}//Tansformer.
#endif //__NODES_TYPES_H__
