%option noyywrap

%x MULTISTRING
%x COMMENT
%x ENDORNOT
%x SINGLECOMMENT

%{
#include <bits/stdc++.h>
#include "1905062.h"

int line_count=1;
int errorcount=0;
FILE *logout;
FILE *tokenout;
SymbolTable *table;
string  line="";
string line2=" ";
int stringstart;
string multicomment="";
string singlecomment="";
int multicommentstart;
int singlecommentstart;
char makechar(const char* lookahead) {
	if(lookahead[1] != '\\') {
		return lookahead[1];
	}
	
	if(lookahead[1] == '\\') {
		if(lookahead[2] == 'n') {
			return (char) 10;
		} else if(lookahead[2] == 't') {
			return (char) 9;
		} else if(lookahead[2] == 'v') {
			return (char) 11;
		} else if(lookahead[2] == 'f') {
			return (char) 12;
		} else if(lookahead[2] == 'r') {
			return (char) 13;
		} else if(lookahead[2] == 'a') {
			return (char) 7;
		} else if(lookahead[2] == 'b') {
			return (char) 8;
		} else if(lookahead[2] == '0') {
			return (char) 0;
		} else if(lookahead[2] == '\\') {
			return (char) 92;
		} else if(lookahead[2] == '\"') {
			return (char) 34;
		} else if(lookahead[2] == '\'') {
			return (char) 39;
		}  else {
			/* most unlikely case */
             return (char) 0;
		}
	}
	else
	{
     return (char) 0;

	}
}
string makestring(const char* lookahead)
{    string string1="";
	for(int i=1;i<strlen(lookahead)-1;)
	{
		if(lookahead[i]!='\\')
		{
          string1+=lookahead[i];
		  i++;
		}
		else
		{
			if(lookahead[i+1] == 'n') {
			string1+=(char) 10;
		} else if(lookahead[i+1] == 't') {
			string1+=(char) 9;
		} else if(lookahead[i+1] == 'v') {
			string1+=(char) 11;
		} else if(lookahead[i+1] == 'f') {
			string1+=(char) 12;
		} else if(lookahead[i+1] == 'r') {
			string1+=" ";
		} else if(lookahead[i+1] == 'a') {
			string1+=(char) 7;
		} else if(lookahead[i+1] == 'b') {
			string1+=(char) 8;
		} else if(lookahead[i+1] == '0') {
			string1+=(char) 0;
		} else if(lookahead[i+1] == '\\') {
			string1+=(char) 92;
		} else if(lookahead[i+1] == '\"') {
			string1+=(char) 34;
		} else if(lookahead[i+1] == '\'') {
			string1+=(char) 39;
		} 
	     i+=2;
		}
	}
	return string1;
}

%}

WHITESPACE [ \t\f\r\v]+ 
SPACE [ ]
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE [\r]?\n
ESCAPE \\[nt'a"f\\rbv0]
CHAR  [ !-~]{-}['\\]|{ESCAPE}
CONSTCHAR ('({CHAR})')
CONSTINT {DIGIT}+
ILL_FORMED  {DIGIT}+(\.{DIGIT}+)?([Ee][+-]?{DIGIT}*)(\.{DIGIT}+)+|(\.{DIGIT}+)([Ee][+-]?{DIGIT}*)(\.{DIGIT}+)+
FLOATINGPOINT {DIGIT}+(\.{DIGIT}+)?([Ee][+-]?{DIGIT}+)?|(\.{DIGIT}+)([Ee][+-]?{DIGIT}+)?

UNFINISHEDCHAR ('({CHAR}))|(\')
MULTICHAR ('({CHAR}{CHAR}+)')
REDUNDANT {DIGIT}+(\.{DIGIT}+)(\.{DIGIT}+)+([Ee][+-]?{DIGIT}+)?|(\.{DIGIT}+)(\.{DIGIT}+)+([Ee][+-]?{DIGIT}+)?

/* identifiers*/
ID [A-Z_a-z][A-Z_a-z0-9]*
SUFFIX_PREFIX {DIGIT}+{ID}
EMPTY_CONST_CHAR ('')


%%





"if"	{
			fprintf(tokenout,"<IF, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <IF> Lexeme %s found\n",line_count,yytext);
		}
		
"else"	{
			fprintf(tokenout,"<ELSE, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <ELSE> Lexeme %s found\n",line_count,yytext);
		}

"for"	{
			fprintf(tokenout,"<FOR, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <FOR> Lexeme %s found\n",line_count,yytext);
		}

"do"	{
			fprintf(tokenout,"<DO, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <DO> Lexeme %s found\n",line_count,yytext);
		}

"int"	{
			fprintf(tokenout,"<INT, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <INT> Lexeme %s found\n",line_count,yytext);
		}

"float"	{
			fprintf(tokenout,"<FLOAT, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <FLOAT> Lexeme %s found\n",line_count,yytext);
		}

"void"	{
			fprintf(tokenout,"<VOID, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <VOID> Lexeme %s found\n",line_count,yytext);
		}

"switch" {
			fprintf(tokenout,"<SWITCH, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <SWITCH> Lexeme %s found\n",line_count,yytext);
		}

"default" {
			fprintf(tokenout,"<DEFAULT, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <DEFAULT> Lexeme %s found\n",line_count,yytext);
		}

"while"	{
			fprintf(tokenout,"<WHILE, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <WHILE> Lexeme %s found\n",line_count,yytext);
		}

"break"	{
			fprintf(tokenout,"<BREAK, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <BREAK> Lexeme %s found\n",line_count,yytext);
		}

"char"	{
			fprintf(tokenout,"<CHAR, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <CHAR> Lexeme %s found\n",line_count,yytext);
		}

"double" {
			fprintf(tokenout,"<DOUBLE, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <DOUBLE> Lexeme %s found\n",line_count,yytext);
		}

"return" {
			fprintf(tokenout,"<RETURN, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <RETURN> Lexeme %s found\n",line_count,yytext);
		}

"case"	{
			fprintf(tokenout,"<CASE, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <CASE> Lexeme %s found\n",line_count,yytext);
		}

"continue"	{
			fprintf(tokenout,"<CONTINUE, %s>\n",yytext);
			fprintf(logout,"Line# %d: Token <CONTINUE> Lexeme %s found\n",line_count,yytext);
		}	
	/*OPERATORS*/
"++"|"--" {
		fprintf(tokenout,"<INCOP, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <INCOP> Lexeme %s found\n",line_count,yytext);
		}		

"+"|"-" {
		fprintf(tokenout,"<ADDOP, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <ADDOP> Lexeme %s found\n",line_count,yytext);
		}
"*"|"/"|"%" {
		fprintf(tokenout,"<MULOP, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <MULOP> Lexeme %s found\n",line_count,yytext);
		}	


"<="|">=" {
		fprintf(tokenout,"<RELOP, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <RELOP> Lexeme %s found\n",line_count,yytext);
		}

"<"|">"|"=="|"!=" {
		fprintf(tokenout,"<RELOP, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <RELOP> Lexeme %s found\n",line_count,yytext);
		}

"=" {
		fprintf(tokenout,"<ASSIGNOP, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
		}

"&&"|"||" {
		fprintf(tokenout,"<LOGICOP, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <LOGICOP> Lexeme %s found\n",line_count,yytext);
		}

"&"|"|"|"^"|"<<"|">>" {
		fprintf(tokenout,"<BITOP, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <BITOP> Lexeme %s found\n",line_count,yytext);
		}

"!" {
		fprintf(tokenout,"<NOT, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <NOT> Lexeme %s found\n",line_count,yytext);
	  }

"(" {
		fprintf(tokenout,"<LPAREN, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <LPAREN> Lexeme %s found\n",line_count,yytext);
		}

")" {
		fprintf(tokenout,"<RPAREN, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <RPAREN> Lexeme %s found\n",line_count,yytext);
		}

"{" {
		fprintf(tokenout,"<LCURL, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <LCURL> Lexeme %s found\n",line_count,yytext);
		table->Enter_Scope();
		}
		
"}" {
		fprintf(tokenout,"<RCURL, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <RCURL> Lexeme %s found\n",line_count,yytext);
		 table->Exit_Scope();
		}

"[" {
		fprintf(tokenout,"<LSQUARE, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <LSQUARE> Lexeme %s found\n",line_count,yytext);
		}

"]" {
		fprintf(tokenout,"<RSQUARE, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <RSQUARE> Lexeme %s found\n",line_count,yytext);
		}

"," {
		fprintf(tokenout,"<COMMA, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <COMMA> Lexeme %s found\n",line_count,yytext);
		}

";" {
		fprintf(tokenout,"<SEMICOLON, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <SEMICOLON> Lexeme %s found\n",line_count,yytext);
		}

    /* Constants*/
{CONSTINT} {
	   fprintf(tokenout,"<CONST_INT, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <CONST_INT> Lexeme %s found\n",line_count,yytext);
     }  

{FLOATINGPOINT} {
            fprintf(tokenout,"<CONST_FLOAT, %s>\n",yytext);
		fprintf(logout,"Line# %d: Token <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
        }

{CONSTCHAR} {
         fprintf(tokenout,"<CONST_CHAR, %c>\n",makechar(yytext));
		fprintf(logout,"Line# %d: Token <CONST_CHAR> Lexeme %c found\n",line_count,makechar(yytext));
   } 

 /*identifiers*/


{ID} {
	     fprintf(tokenout,"<ID, %s>\n",yytext);
		 fprintf(logout,"Line# %d: Token <ID> Lexeme %s found\n",line_count,yytext);
		 bool result=table->Insert(yytext,"ID");
         if(result)
		 table->printAll();
 }
  /*Strings*/
  /*SINGLE LINE*/

\"({CHAR}+)\"  {
          fprintf(tokenout,"<SINGLE LINE STRING, %s>\n",makestring(yytext).c_str());
		 fprintf(logout,"Line# %d: Token <SINGLE LINE STRING> Lexeme %s found\n",line_count,yytext);
 
  }
   
   /*MULTI LINE*/

\" {
	  stringstart=line_count;
	  line=yytext;
	  line2=yytext;
	  cout<<"string0\n";
	  BEGIN MULTISTRING;
   } 
<MULTISTRING>{SPACE}  {
	cout<<"string1\n";
	line+=yytext;
	line2+=yytext;
}
<MULTISTRING>{WHITESPACE}  {
	cout<<"string1\n";
	line+=yytext;
	line2+=yytext;
}
<MULTISTRING>\\{NEWLINE} {
	cout<<"string2\n";
     line+=yytext;
	 line_count++;
   }
<MULTISTRING>(\\["ntbvfra0\\"]) {
	cout<<"string3\n";
  line+=yytext;	
  line2+=yytext;
}
<MULTISTRING>([\t\n !-~]{-}[\"]) {
	cout<<"string4\n";
     line+=yytext;
	 line2+=yytext;
   }


<MULTISTRING>\" {
	  line+=yytext;
	  line2+=yytext;
	  cout<<line<<endl;
	  fprintf(tokenout,"<MULTI LINE STRING, %s>\n",makestring(line2.c_str()).c_str());
	  fprintf(logout,"Line# %d: Token <MULTI LINE STRING> Lexeme %s found\n",stringstart,line.c_str());
	  line="";
	  BEGIN INITIAL;
}
<MULTISTRING>[^\\]{NEWLINE} {
	line_count++;
	line+=yytext[0];
	fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_count-1,line.c_str());
     line="";
	 errorcount++;
	  BEGIN INITIAL;
}
<MULTISTRING><<EOF>> {
	  
      fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_count,line.c_str());
	  errorcount++;
	  BEGIN INITIAL;
	  

}
  /*comment start*/

\/\*	{    cout<<"its working0\n";
           multicommentstart=line_count;
            multicomment=yytext;
			BEGIN COMMENT;  // another state starts 
		}
<COMMENT>([\t !-~]{-}[\*])* {
	          cout<<multicomment<<endl;
	          cout<<"its working\n";
			  multicomment+=yytext;
				}
<COMMENT>\* {
	         cout<<"its working2\n";
			multicomment+=yytext;
			BEGIN ENDORNOT;
		}
<ENDORNOT>\/ {
	         cout<<"its working3\n";
			/* comment finished */
			multicomment+=yytext;
			cout<<multicomment<<endl;
			fprintf(logout,"Line# %d: Token <MULTI LINE COMMENT> Lexeme %s found\n",multicommentstart,multicomment.c_str());
			multicomment ="";
			cout<<" Line count:"<<line_count<<endl;
			BEGIN INITIAL; // another state ends
		}
<ENDORNOT>\* {
	     cout<<"its working4\n";
		multicomment+=yytext;	
		}

<COMMENT>{NEWLINE} {
	       multicomment+=yytext;	
           line_count++;
          }
<ENDORNOT>([\t !-~]{-}[\/\*]) {
	         cout<<"its working5\n";
			multicomment+=yytext;
			BEGIN COMMENT;
		}
<ENDORNOT>{NEWLINE} {
	       multicomment+=yytext;	
           line_count++;
          }
<COMMENT><<EOF>>  {
	fprintf(logout,"Error at line# %d: UNFINISHED_COMMENT %s\n",line_count,multicomment.c_str());
	errorcount++;
	BEGIN INITIAL;

          }
<ENDORNOT><<EOF>> {
  fprintf(logout,"Error at line# %d: UNFINISHED_COMMENT %s\n",line_count,multicomment.c_str());
  errorcount++;
  BEGIN INITIAL;
           }

\/\/ { 
	   singlecommentstart=line_count;
       singlecomment=yytext;
	   BEGIN SINGLECOMMENT;
        cout<<"Begin"<<endl;
}
<SINGLECOMMENT>. {
	singlecomment+=yytext;
	cout<<"Begin2"<<endl;
}
<SINGLECOMMENT>([\\]{NEWLINE}) {
  singlecomment+=yytext;
  line_count++;
  cout<<"Begin3"<<endl;
}
<SINGLECOMMENT>([^\\]{NEWLINE}) {
        singlecomment+=yytext[0];
        line_count++;
		fprintf(logout,"Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n",singlecommentstart,singlecomment.c_str());
        singlecomment="";
	cout<<"end"<<endl;
		BEGIN INITIAL;
}
 /*errors*/
{EMPTY_CONST_CHAR} {
	fprintf(logout,"Error at line# %d: EMPTY_CONST_CHAR %s\n",line_count,yytext);
	errorcount++;

      }
{UNFINISHEDCHAR} {
      fprintf(logout,"Error at line# %d: UNFINISHED_CONST_CHAR %s\n",line_count,yytext);
	  errorcount++;
     }
{MULTICHAR}  {
     fprintf(logout,"Error at line# %d: MULTICHAR_CONST_CHAR %s\n",line_count,yytext);
	 errorcount++;
     }
{REDUNDANT} {
	  fprintf(logout,"Error at line# %d: TOO_MANY_DECIMAL_POINTS %s\n",line_count,yytext);
	  errorcount++;
     }



{SUFFIX_PREFIX} {
	fprintf(logout,"Error at line# %d: INVALID_ID_SUFFIX_NUM_PREFIX %s\n",line_count,yytext);
	errorcount++;

       }
{ILL_FORMED} {
      fprintf(logout,"Error at line# %d: ILLFORMED_NUMBER %s\n",line_count,yytext);
	  errorcount++;
       }
{WHITESPACE} {
	  /*MALUM NEHI*/
        }
{NEWLINE} {
	line_count++;
	}



. {
	fprintf(logout,"Error at line# %d: UNRECOGNIZED_CHAR %s\n",line_count,yytext);
	errorcount++;
  }

<<EOF>> {
	table->printAll();
	fprintf(logout,"Total lines: %d\n",line_count);
	fprintf(logout,"Total errors: %d\n",errorcount);
	table->Exit_Scope();
		 
	return 0;
}
 



%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("1905062_log.txt","w");
	tokenout= fopen("1905062_token.txt","w");
    table=new SymbolTable(10,logout);
	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
