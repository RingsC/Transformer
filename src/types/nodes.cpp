/**
	the definition of nodes types.
	path:src/types/nodes.cpp
**/

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

TargetEntry::TargetEntry()  
{}

TargetEntry::~TargetEntry()
{}

void TargetEntry::optimize()
{}

FromStmt::FromStmt()
{}

FromStmt::~FromStmt()
{}

void FromStmt::optimize()
{}

WhereStmt::WhereStmt()
{}

WhereStmt::~WhereStmt()
{}

void WhereStmt::optimize()
{}

AggregateStmt::AggregateStmt()
{}

AggregateStmt::~AggregateStmt()
{}

void AggregateStmt::optimize()
{}

HavingStmt::HavingStmt()
{}

HavingStmt::~HavingStmt()
{}

void HavingStmt::optimize()
{}

GroupByStmt::GroupByStmt()
{}

GroupByStmt::~GroupByStmt()
{}

void GroupByStmt::optimize()
{}

OrderByStmt::OrderByStmt()
{}
OrderByStmt::~OrderByStmt()
{}
void OrderByStmt::optimize()
{}

Function::Function()
{}

Function::~Function()
{}

void Function::optimize()
{}

Sum::Sum()
{}

Sum::~Sum()
{}

void Sum::optimize()
{}

Avg::Avg()
{
}
Avg::~Avg()
{}
void Avg::optimize()
{}

Expr::Expr()
{
}

Expr::~Expr()
{

}
void Expr::optimize()
{
}


And::And()
{}
And::~And()
{}

void And::optimize()
{}

Expr* And::reverse()
{
	return (Expr*) NULL; 
}

Or::Or()
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
