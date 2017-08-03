/**
	the definition of nodes types.
	path:src/types/nodes.cpp
**/

#include <stdlib.h>
#include <string.h>
#include <types/nodes.h>

namespace Transformer{
namespace Types{


SelectStmt::SelectStmt() : SqlStmt()
{

}

SelectStmt::SelectStmt(ASTNode* parent) : SqlStmt(parent)
{
}
SelectStmt::SelectStmt(SelectStmt* parent) : SqlStmt(parent)
{

}

SelectStmt::~SelectStmt()
{
}

void SelectStmt::optimize ()
{
}

const char*  SelectStmt::toString()
{
	return NULL; 	
}

TargetEntry::TargetEntry() : SqlStmt (NODE_TYPE_TARGETENTRY)
{}

TargetEntry::~TargetEntry()
{}
TargetEntry::TargetEntry(const char* targetName):SqlStmt (NODE_TYPE_TARGETENTRY)
{
	strncpy(targetName_, targetName, strlen(targetName));
}

void TargetEntry::optimize()
{}

const char* TargetEntry::toString()
{
	return NULL;
}

TargetList::TargetList():SqlStmt (NODE_TYPE_TARGETENTRY_LIST)
{}
TargetList::~TargetList()
{}
void TargetList::optimize()
{}
void TargetList::addEntry (TargetEntry* entry) 
{
}
void TargetList::addEntry (ASTNode* entry)
{
}
void TargetList::mergeEntries (TargetList* targetList) 
{
}
void TargetList::mergeEntries (ASTNode* target)
{
}
const char* TargetList::toString()
{
	return NULL;
}

TableEntry::TableEntry():SqlStmt (NODE_TYPE_TABLEENTRY)
{
}
TableEntry::TableEntry(const char* name):SqlStmt (NODE_TYPE_TABLEENTRY)
{
	strncpy(name_, name, strlen(name)) ;
}
TableEntry::~TableEntry()
{
}
void TableEntry::optimize()
{
}
const char* TableEntry::toString()
{
	return NULL;
}
TableEntryList::TableEntryList():SqlStmt (NODE_TYPE_TABLEENTRY_LIST)
{
}
TableEntryList::~TableEntryList()
{
}
void TableEntryList::addTableEntry (TableEntry* table) 
{
}
void TableEntryList::addTableEntry (ASTNode* table) 
{
}
void TableEntryList::mergeTableList (TableEntryList* table_list)
{
}
void TableEntryList::mergeTableList (ASTNode* table_list)
{
}
void TableEntryList::optimize()
{
}
const char* TableEntryList::toString()
{
	return NULL;
}
FromStmt::FromStmt():SqlStmt (NODE_TYPE_FROM_STMT)
{
}

FromStmt::~FromStmt()
{
}

void FromStmt::optimize()
{
}

void FromStmt::setTableEntryList (TableEntryList* tables)
{
}
void FromStmt::setTableEntryList (ASTNode* tables)
{}

const char* FromStmt::toString()
{
	return NULL;
}

WhereStmt::WhereStmt(): SqlStmt (NODE_TYPE_WHERE_STMT)
{}

WhereStmt::~WhereStmt()
{}

void WhereStmt::optimize()
{}
const char* WhereStmt::toString()
{
	return NULL;
}
AggregateStmt::AggregateStmt() : SqlStmt (NODE_TYPE_AGGREGATE_STMT)
{}
AggregateStmt::AggregateStmt(NodeType type) : SqlStmt (type)
{}
AggregateStmt::~AggregateStmt()
{}

void AggregateStmt::optimize()
{}
const char* AggregateStmt::toString()
{
	return NULL;
}
HavingStmt::HavingStmt() : AggregateStmt(NODE_TYPE_HAVING_STMT)
{}

HavingStmt::~HavingStmt()
{}

void HavingStmt::optimize()
{}
const char* HavingStmt::toString()
{
	return NULL;
}

GroupByStmt::GroupByStmt() : AggregateStmt(NODE_TYPE_GROUPBY_STMT)
{}

GroupByStmt::~GroupByStmt()
{}

void GroupByStmt::optimize()
{}
const char* GroupByStmt::toString()
{
	return NULL;
}

OrderByStmt::OrderByStmt() : AggregateStmt (NODE_TYPE_ORDERBY_STMT)
{}
OrderByStmt::~OrderByStmt()
{}
void OrderByStmt::optimize()
{}
const char* OrderByStmt::toString()
{
	return NULL;
}

Function::Function() : SqlStmt(NODE_TYPE_FUNCTION)
{
}
Function::Function(NodeType type) : SqlStmt(type)
{
}
Function::~Function()
{
}
void Function::optimize()
{
}
const char* Function::toString()
{
	return NULL;
}
Sum::Sum() : Function (NODE_TYPE_FUNCTION_SUM) 
{}

Sum::~Sum()
{}

void Sum::optimize()
{}
const char* Sum::toString()
{
	return NULL;
}

Avg::Avg() : Function(NODE_TYPE_FUNCTION_AVG)
{
}
Avg::~Avg()
{}
void Avg::optimize()
{}
const char* Avg::toString()
{
	return NULL;
}
Expr::Expr() : SqlStmt(NODE_TYPE_EXPR)
{
}
Expr::Expr(NodeType type) : SqlStmt(type)
{
}
Expr::~Expr()
{

}
void Expr::optimize()
{
}
const char* Expr::toString()
{
	return NULL;
}

And::And() : Expr(NODE_TYPE_EXPR_AND)
{}
And::~And()
{}

void And::optimize()
{}

Expr* And::reverse()
{
	return (Expr*) NULL; 
}
const char* And::toString()
{
	return NULL;
}

Or::Or() : Expr(NODE_TYPE_EXPR_OR)
{}

Or::~Or()
{}
void Or::optimize ()
{}

Expr* Or::reverse()
{
	return (Expr*)NULL;
}
const char* Or::toString()
{
	return NULL;
}


}//namespace Types
}//namespace Tranformer.
