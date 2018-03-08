%{
#include <stdio.h>
#include "calc.tab.h"
extern int yylineno;
void find_error();
char temper[25];
int ii=0;
int errorline;
int length;
%}

digit	([0-9])

%%

"print"       		{return(TOK_PRINTLN);}



{digit}+\.{digit}+	{
				sscanf(yytext, "%f", &(yylval.float_val));
				return TOK_NUM;
			}


";"					{
						if(ii!=0){
							find_error();
							exit(0);
						}
						return(TOK_SEMICOLON);}

"-"					{return(TOK_SUB);}
"*"					{return(TOK_MUL);}

[ \n]				{
						if(ii!=0){
							find_error();
							exit(0);
						}
					}
[ \t]				{
						if(ii!=0){
							find_error();
							exit(0);
						}
					}

"main()"			{return(TOK_MAIN);}
"{"					{return(LB);}
"}"					{return(RB);}

"("					{return(LL);}
")"					{return(RL);}

"float"				{return(FLOAT);}

[a-z]([0-9]*[a-zA-Z]*)*		{	
								if(ii!=0){
									length = strlen(yytext);
									int itter = 0;
									for(itter=0;itter<length;itter++){
										temper[ii+itter] = yytext[itter];
									}
									ii = ii + length;
								}
								else{
									sscanf(yytext, "%s", yylval.char_val);
									return TOK_VAR;
								}
							}

"="					{return TOK_EQUAL;}


. 					{
						temper[ii] = yytext[0];
						ii++;
						errorline = yylineno;
					}

%%


void find_error(){
	temper[ii]='\0';
	printf("Line %d: Lexical analysis error: %s\n",errorline,temper);
}
