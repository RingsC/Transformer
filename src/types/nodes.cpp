/**
	the definition of nodes types.
	path:src/types/nodes.cpp
**/

#include <types/nodes.h>

namespace Transformer{
namespace Types{


SelectStmt::SelectStmt()
{

}
SelectStmt::SelectStmt(const SelectStmt* parent)
{

}

SelectStmt::~SelectStmt()
{
}

void SelectStmt::optimize ()
{
}

Expr::Expr()
{
}

Expr::~Expr()
{

}
void Expr::optimize()
{
}




}//namespace Types
}//namespace Tranformer.
