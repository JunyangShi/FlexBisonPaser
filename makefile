calc : calc.tab.c lex.yy.c
	gcc -o calc calc.tab.c lex.yy.c -lfl
calc.tab.c : 
	bison -dv calc.y
lex.yy.c :
	flex -l calc.l

clean:
	rm calc.output calc.tab.h calc.tab.c lex.yy.c calc

