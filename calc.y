%{
#include <stdio.h>
#include <string.h>

extern int yylineno;

struct variable {
	char name[50];
	float value;
	int stack_record;
} table[20];

int bound=0;
int i=0;
int record=0;
int temp=0;

int error = 1;

int yyerror(char *);

%}

%token TOK_SEMICOLON TOK_SUB TOK_MUL TOK_NUM TOK_PRINTLN TOK_MAIN LB RB FLOAT TOK_VAR TOK_EQUAL LL RL

%union{
	float float_val;
	char char_val[50];
}

/*%type <int_val> expr TOK_NUM*/
%type <float_val> expr TOK_NUM
%type <char_val> TOK_VAR

%left TOK_SUB
%left TOK_MUL

%%

prog:	TOK_MAIN LB stmt RB
;

stmt: 
	| expr_stmt TOK_SEMICOLON stmt
;

expr_stmt:	FLOAT TOK_VAR
				{
					sscanf($2, "%s", table[bound].name);
					for(i=0;i<bound;i++){
						if(strcmp($2,table[i].name)==0 && table[i].stack_record == record){
							printf("Line %d: Wrong! %s was already declared\n",yylineno, $2);
							return 0;
						}
					}

					table[bound].value = 0.0;
					table[bound].stack_record = record;
					bound++;
					//printf("bound %d\n",bound);
				}
	|	TOK_VAR TOK_EQUAL expr
				{
					for(i=bound-1;i>=0;i--){
						if(strcmp($1,table[i].name)==0){
							table[i].value = $3;
							error = 0;
							break;
						}
					}

					if(error == 1){
						printf("Line %d: Wrong! No such variable %s declared!\n",yylineno,$1);
						return 0;
					}
					error = 1;
				}
	|	{	
			record++;
		}
		LB stmt RB
		{
			for(i=0;i<bound;i++){
				if(table[i].stack_record == record){
					temp++;
				}
			}
			bound = bound - temp;
			record--;
			temp = 0;
		}

	|	TOK_PRINTLN TOK_VAR
				{	
					for(i=bound-1;i>=0;i--){
						if(strcmp($2,table[i].name)==0){
							printf("The value is %.1f\n",table[i].value);
							error = 0;
							break;
							//return 0;
						}
					}

					if(error == 1){
						printf("Line %d: Wrong! No such variable %s declared!\n",yylineno,$2);
						return 0;
					}
					error = 1;
				}
	
;



expr:	TOK_NUM
		{
			$$ = $1;
		}
	|	TOK_VAR
		{
			for(i=bound-1;i>=0;i--){
				if(strcmp($1,table[i].name)==0){
					$$ = table[i].value;
					break;
				}
			}
		}
	|	expr TOK_SUB expr
		{
			$$ = $1 - $3;
		}
	|	expr TOK_MUL expr
		{
			$$ = $1 * $3;
		}
	|	LL TOK_SUB TOK_NUM RL
		{
			$$ = -$3;
		}

;

%%

int yyerror(char *s)
{	

	printf("Parsing error: line %d\n",yylineno);
	
	return 0;
}

int main()
{
	
   	yyparse();
   	return 0;
}
