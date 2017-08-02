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

TableEntry::TableEntry():SqlStmt (NODE_TYPE_TABLEENTRY)
{}
TableEntry::TableEntry(const char* name):SqlStmt (NODE_TYPE_TABLEENTRY)
{
	strncpy(name_, name, strlen(name)) ;
}
TableEntry::~TableEntry()
{
}
void TableEntry::optimize()
{}

TableEntryList::TableEntryList():SqlStmt (NODE_TYPE_TABLEENTRY_LIST)
{}
TableEntryList::~TableEntryList()
{}
void TableEntryList::addTableEntry (TableEntry* table) 
{}
void TableEntryList::addTableEntry (ASTNode* table) 
{}
void TableEntryList::mergeTableList (TableEntryList* table_list)
{
}
void TableEntryList::mergeTableList (ASTNode* table_list)
{
}
void TableEntryList::optimize()
{}

FromStmt::FromStmt():SqlStmt (NODE_TYPE_FROM_STMT)
{}

FromStmt::~FromStmt()
{}

void FromStmt::optimize()
{}

void FromStmt::setTableEntryList (TableEntryList* tables)
{
}
void FromStmt::setTableEntryList (ASTNode* tables)
{}

WhereStmt::WhereStmt(): SqlStmt (NODE_TYPE_WHERE_STMT)
{}

WhereStmt::~WhereStmt()
{}

void WhereStmt::optimize()
{}

AggregateStmt::AggregateStmt() : SqlStmt (NODE_TYPE_AGGREGATE_STMT)
{}
AggregateStmt::AggregateStmt(NodeType type) : SqlStmt (type)
{}
AggregateStmt::~AggregateStmt()
{}

void AggregateStmt::optimize()
{}

HavingStmt::HavingStmt() : AggregateStmt(NODE_TYPE_HAVING_STMT)
{}

HavingStmt::~HavingStmt()
{}

void HavingStmt::optimize()
{}

GroupByStmt::GroupByStmt() : AggregateStmt(NODE_TYPE_GROUPBY_STMT)
{}

GroupByStmt::~GroupByStmt()
{}

void GroupByStmt::optimize()
{}

OrderByStmt::OrderByStmt() : AggregateStmt (NODE_TYPE_ORDERBY_STMT)
{}
OrderByStmt::~OrderByStmt()
{}
void OrderByStmt::optimize()
{}

Function::Function() : SqlStmt(NODE_TYPE_FUNCTION)
{}
Function::Function(NodeType type) : SqlStmt(type)
{
}
Function::~Function()
{}

void Function::optimize()
{}

Sum::Sum() : Function (NODE_TYPE_FUNCTION_SUM) 
{}

Sum::~Sum()
{}

void Sum::optimize()
{}

Avg::Avg() : Function(NODE_TYPE_FUNCTION_AVG)
{
}
Avg::~Avg()
{}
void Avg::optimize()
{}

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



}//namespace Types
}//namespace Tranformer.
