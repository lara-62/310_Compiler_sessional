%option noyywrap

%x MULTISTRING
%x COMMENT
%x ENDORNOT
%x SINGLECOMMENT

%{
#include <bits/stdc++.h>
#include "1905062.h"
#include "y.tab.h"


using namespace std;

extern YYSTYPE yylval;
extern SymbolTable *table;
void yyerror(char *);
extern ofstream logfile;
int line_count=1;

extern FILE *logout;
FILE *tokenout;
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



"println" {
	 logfile<<"Line# "<<line_count<<": Token <PRINTLN> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"PRINTLN");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return  PRINTLN;
}

"if"	{   
	        logfile<<"Line# "<<line_count<<": Token <IF> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"IF");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return  IF;
		}
		
"else"	{   
	        logfile<<"Line# "<<line_count<<": Token <ELSE> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"ELSE");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return ELSE;
		}

"for"	{   
	        logfile<<"Line# "<<line_count<<": Token <FOR> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"FOR");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return FOR;
		}

"do"	{
	        logfile<<"Line# "<<line_count<<": Token <DO> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"DO");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return DO;
		}

"int"	{   logfile<<"Line# "<<line_count<<": Token <INT> Lexeme int found"<<endl;
            Symbolinfo *s= new  Symbolinfo(yytext,"INT");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return INT;
		}

"float"	{   logfile<<"Line# "<<line_count<<": Token <FLOAT> Lexeme float found"<<endl;
            Symbolinfo *s= new  Symbolinfo(yytext,"FLOAT");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return FLOAT;
		}

"void"	{   
	        logfile<<"Line# "<<line_count<<": Token <VOID> Lexeme void found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"VOID");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return VOID;
		}

"switch" {
	        logfile<<"Line# "<<line_count<<": Token <SWITCH> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"SWITCH");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return SWITCH;
		}

"default" {
	        logfile<<"Line# "<<line_count<<": Token <DEFAULT> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"DEFAULT");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return DEFAULT;
		}

"while"	{
	        logfile<<"Line# "<<line_count<<": Token <WHILE> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"WHILE");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return WHILE;
		}

"break"	{
	       logfile<<"Line# "<<line_count<<": Token <BREAK> Lexeme "<<yytext<<" found"<<endl;
		   Symbolinfo *s= new  Symbolinfo(yytext,"BREAK");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return BREAK;
		}

"char"	{   
	        logfile<<"Line# "<<line_count<<": Token <CHAR> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"CHAR");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return CHAR;
		}

"double" {
	        logfile<<"Line# "<<line_count<<": Token <DOUBLE> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"DOUBLE");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return DOUBLE;
		}

"return" {
	        logfile<<"Line# "<<line_count<<": Token <RETURN> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"RETURN");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return RETURN;
		}

"case"	{
	        logfile<<"Line# "<<line_count<<": Token <CASE> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"CASE");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return CASE;
		}

"continue"	{
	        logfile<<"Line# "<<line_count<<": Token <CONTINUE> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"CONTINUE");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return CONTINUE;
		}	
	/*OPERATORS*/
"++"  {     logfile<<"Line# "<<line_count<<": Token <INCOP> Lexeme "<<yytext<<" found"<<endl;
		    Symbolinfo *s= new  Symbolinfo(yytext,"INCOP");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return INCOP;
			}		
"--"  {
            logfile<<"Line# "<<line_count<<": Token <DECOP> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"DECOP");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return DECOP;
			}	

"+"|"-" {   
            logfile<<"Line# "<<line_count<<": Token <ADDOP> Lexeme "<<yytext<<" found"<<endl;
			Symbolinfo *s= new  Symbolinfo(yytext,"ADDOP");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
			return ADDOP;
		}
"*"|"/"|"%" {
	     logfile<<"Line# "<<line_count<<": Token <MULOP> Lexeme "<<yytext<<" found"<<endl;
		 Symbolinfo *s= new  Symbolinfo(yytext,"MULOP");
		 	s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		 yylval.symbolinfo=s;
		 return MULOP;
		}	


"<="|">=" {
	    logfile<<"Line# "<<line_count<<": Token <RELOP> Lexeme "<<yytext<<" found"<<endl;
		Symbolinfo *s= new  Symbolinfo(yytext,"RELOP");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
		return RELOP;
		}

"<"|">"|"=="|"!=" {
	    logfile<<"Line# "<<line_count<<": Token <RELOP> Lexeme "<<yytext<<" found"<<endl;
		Symbolinfo *s= new  Symbolinfo(yytext,"RELOP");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
		return RELOP;
		}

"=" {   logfile<<"Line# "<<line_count<<": Token <ASSIGNOP> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"ASSIGNOP");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
		return ASSIGNOP;
	}

"&&"|"||" {
	    logfile<<"Line# "<<line_count<<": Token <LOGICOP> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"LOGICOP");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
		return LOGICOP;
		}

"&"|"|"|"^"|"<<"|">>" {
	    logfile<<"Line# "<<line_count<<": Token <BITOP> Lexeme "<<yytext<<" found"<<endl;
	    Symbolinfo *s= new  Symbolinfo(yytext,"BITOP");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
		return BITOP;
		}

"!" {   logfile<<"Line# "<<line_count<<": Token <NOT> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"NOT");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
	    return NOT;
	  }

"(" {    logfile<<"Line# "<<line_count<<": Token <LPAREN> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"LPAREN");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
		return LPAREN;
		}

")" {    logfile<<"Line# "<<line_count<<": Token <RPAREN> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"RPAREN");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
		return RPAREN;
		}

"{" {   logfile<<"Line# "<<line_count<<": Token <LCURL> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"LCURL");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
		return LCURL;

		}
		
"}" {   logfile<<"Line# "<<line_count<<": Token <RCURL> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"RCURL");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
		 return RCURL;
		}

"[" {   logfile<<"Line# "<<line_count<<": Token <LSQUARE> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"LSQUARE");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
		return LSQUARE;
		}

"]" {   logfile<<"Line# "<<line_count<<": Token <RSQUARE> Lexeme "<<yytext<<" found"<<endl;
        Symbolinfo *s= new  Symbolinfo(yytext,"RSQUARE");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
		return RSQUARE;
		}

"," {    
	     logfile<<"Line# "<<line_count<<": Token <COMMA> Lexeme "<<yytext<<" found"<<endl;
		 Symbolinfo *s= new  Symbolinfo(yytext,"COMMA");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
		return COMMA;
		}

";" {    
	    logfile<<"Line# "<<line_count<<": Token <SEMICOLON> Lexeme "<<yytext<<" found"<<endl;
		Symbolinfo *s= new  Symbolinfo(yytext,"SEMICOLON");
			s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
			yylval.symbolinfo=s;
		return SEMICOLON;
		}

    /* Constants*/
{CONSTINT} {
	    logfile<<"Line# "<<line_count<<": Token <CONST_INT> Lexeme "<<yytext<<" found"<<endl;
		Symbolinfo *s= new  Symbolinfo(yytext,"CONST_INT");
		s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
		return CONST_INT;
     }  

{FLOATINGPOINT} {
	    logfile<<"Line# "<<line_count<<": Token <CONST_FLOAT> Lexeme "<<yytext<<" found"<<endl;
		Symbolinfo *s= new  Symbolinfo(yytext,"CONST_FLOAT");
		s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
		return CONST_FLOAT;
        }

{CONSTCHAR} {
	    logfile<<"Line# "<<line_count<<": Token <CONST_CHAR> Lexeme "<<yytext<<" found"<<endl;
		Symbolinfo *s= new  Symbolinfo(yytext,"CONST_CHAR");
		s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
		return CONST_CHAR;
   } 

 /*identifiers*/


{ID} {  
		Symbolinfo *s= new Symbolinfo(yytext,"ID");
		logfile<<"Line# "<<line_count<<": Token <ID> Lexeme "<<yytext<<" found"<<endl;
		s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		yylval.symbolinfo=s;
					
		return ID;
 }
  /*Strings*/
  /*SINGLE LINE*/

\"({CHAR}+)\"  {
         logfile<<"Line# "<<line_count<<": Token <SINGLE_LINE_STRING> Lexeme "<<makestring(yytext)<<" found"<<endl;
         Symbolinfo *s= new  Symbolinfo(makestring(yytext),"SINGLE_LINE_STRING");
		 s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
		 yylval.symbolinfo=s;
		 return SINGLE_LINE_STRING;
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
	//   fprintf(tokenout,"<MULTI LINE STRING, %s>\n",makestring(line2.c_str()).c_str());
	//   fprintf(logout,"Line# %d: Token <MULTI LINE STRING> Lexeme %s found\n",stringstart,line.c_str());
	   logfile<<"Line# "<<line_count<<": Token <MULTI_LINE_STRING> Lexeme "<<makestring(line2.c_str())<<" found"<<endl;
	  Symbolinfo *s= new  Symbolinfo(makestring(line2.c_str()),"MULTI_LINE_STRING");
	  s->SetStartLine(line_count);
		    s->SetEndLine(line_count);
			s->setisLeaf(true);
	  yylval.symbolinfo=s;
	  return MULTI_LINE_STRING;
	  line="";
	  BEGIN INITIAL;
}
<MULTISTRING>[^\\]{NEWLINE} {
	line_count++;
	line+=yytext[0];
	//
	//fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_count-1,line.c_str());
     line="";
	 //errorcount++;
	  BEGIN INITIAL;
}
<MULTISTRING><<EOF>> {
	  
      //fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_count,line.c_str());
	  //errorcount++;
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
			//fprintf(logout,"Line# %d: Token <MULTI LINE COMMENT> Lexeme %s found\n",multicommentstart,multicomment.c_str());
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
	//fprintf(logout,"Error at line# %d: UNFINISHED_COMMENT %s\n",line_count,multicomment.c_str());
	//errorcount++;
	BEGIN INITIAL;

          }
<ENDORNOT><<EOF>> {
  //fprintf(logout,"Error at line# %d: UNFINISHED_COMMENT %s\n",line_count,multicomment.c_str());
  //errorcount++;
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
		//logfile<<"Line# "<<line_count<<": Token <SINGLE LINE COMMENT> Lexeme "<<yytext<<" found"<<endl;
		//fprintf(logout,"Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n",singlecommentstart,singlecomment.c_str());
        singlecomment="";
	cout<<"end"<<endl;
		BEGIN INITIAL;
}
 /*errors*/
{EMPTY_CONST_CHAR} {
	//fprintf(logout,"Error at line# %d: EMPTY_CONST_CHAR %s\n",line_count,yytext);
	//errorcount++;

      }
{UNFINISHEDCHAR} {
      //fprintf(logout,"Error at line# %d: UNFINISHED_CONST_CHAR %s\n",line_count,yytext);
	  //errorcount++;
     }
{MULTICHAR}  {
     //fprintf(logout,"Error at line# %d: MULTICHAR_CONST_CHAR %s\n",line_count,yytext);
	 //errorcount++;
     }
{REDUNDANT} {
	  //fprintf(logout,"Error at line# %d: TOO_MANY_DECIMAL_POINTS %s\n",line_count,yytext);
	  //errorcount++;
     }



{SUFFIX_PREFIX} {
	//fprintf(logout,"Error at line# %d: INVALID_ID_SUFFIX_NUM_PREFIX %s\n",line_count,yytext);
	//errorcount++;

       }
{ILL_FORMED} {
      //fprintf(logout,"Error at line# %d: ILLFORMED_NUMBER %s\n",line_count,yytext);
	  //errorcount++;
       }
{WHITESPACE} {
	  /*MALUM NEHI*/
        }
{NEWLINE} {
	line_count++;
	}



. {
	//fprintf(logout,"Error at line# %d: UNRECOGNIZED_CHAR %s\n",line_count,yytext);
	//errorcount++;
  }

<<EOF>> {
	
	
		 
	return 0;
}
 



%%
