In this folder, it contains the grammatical rules file. if you want to change the rules, you should first adds the keywords in keyworkds.cpp and adds the grammatical ruls in .y. after that using the following command to re-compile the rules. 


bison --yacc --output=grammar.cpp --defines=grammar.h grammar.y 

for more information pls refer to gun.org.

