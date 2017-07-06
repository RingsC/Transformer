
#include <stdio.h>
#include "parser.h"

using Transformer::Parser::Parser;
int main (int argc, char* argv[])
{
	if (argc < 0) return -1;
	
	Parser parse;
	parse.raw_parser( argv[1] );	
	return 0; 
}
