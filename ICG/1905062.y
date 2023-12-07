%{
#include<bits/stdc++.h>
#include "1905062_code.h"

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
ofstream logfile;
ofstream errorfile;
ofstream parsefile;
extern int line_count;
int error_count;
FILE *logout;
extern int yylineno;
string function_return="";
int returnLine=-1;
int yylex_destroy(void);
int arrayindex=-1;
string while_start="";
string while_end="";
string for_start="";
string for_end="";
string for_inc_start="";
string for_inc_end="";
//parameters for including them in the scope
vector<Symbolinfo*>*function_parameter;
vector<Symbolinfo*>*variable_declaration;
vector<Symbolinfo*>*ArgumentList;
vector<Symbolinfo*>*Argument;
bool code_start=false;
int var_prevscope=0;
void DFS(Symbolinfo* StartState,string space)
{    
	 
     if(StartState->getisLeaf())
	    {   
			parsefile<<space<<StartState->getType()<<" : "<<StartState->getName()<<"\t"<<"<Line: "<<StartState->GetStartLine()<<">"<<endl;
			delete StartState;
			return;
		}
	 parsefile<<space<<StartState->getType()<<" : "<<StartState->getName()<<" \t"<<"<Line: "<<StartState->GetStartLine()<<"-"<<StartState->GetEndLine()<<">"<<endl;
	 vector<Symbolinfo*>*temp=StartState->getChildList();
	 for(Symbolinfo *next:*temp)
	 {
		DFS(next,space+" ");
	 }
	    delete StartState;
}

void yyerror(char *s)
{
	//write your code
}

//for icg part

char *newLabel()
{
	char *lb= new char[4];
	strcpy(lb,"L");
	char b[3];
	sprintf(b,"%d", labelCount);
	labelCount++;
	strcat(lb,b);
	return lb;
}


void variable_declare(string type,vector<Symbolinfo*>* variablelist)
{   cout<<"what the"<<endl;
	for(Symbolinfo *symbol:*variablelist)
	{   cout<<"what the2"<<endl;
		if (type=="VOID")
      {  cout<<"bleh1"<<endl;
		errorfile<<"Line# "<<line_count<<": Variable or field '"<<symbol->getName()<<"' declared void"<<endl;
		error_count++;
		return;
	  }
	  else {
		cout<<"bleh2"<<endl;
		if(table->Insert(symbol->getName(),symbol->getType()))
		{  cout<<"bleh3"<<endl;
          Symbolinfo *info=table->LookUp(symbol->getName());
		  info->setDataType(type);
		  if(symbol->getisArray())
		     {
				info->setisArray(true);
				info->setarraysize(symbol->getarraysize());
			 }   
            info->setisglobal(symbol->getisglobal());
			info->setoffset(symbol->getoffset());
		}
		else
		{    cout<<"bleh4"<<endl;
			Symbolinfo *info=table->LookUp(symbol->getName());
			if(info->getDataType()!=symbol->getDataType())
			   {
				errorfile<<"Line# "<<line_count<<": Conflicting types for'"<<symbol->getName()<<"'"<<endl;
                error_count++;
			   }
			else if(info->getisArray()!=symbol->getisArray())
			{
				errorfile<<"Line# "<<line_count<<": Conflicting types for'"<<symbol->getName()<<"'"<<endl;
				error_count++;
			}
			else
			{
				errorfile<<"Line# "<<line_count<<": redeclaration of '"<<symbol->getName()<<"'"<<endl;
				error_count++;
			}
		}
	  }
		
	}
}
void define_function(string returnType,Symbolinfo* function_name,vector<Symbolinfo*>*param)
{
	 if(table->Insert(function_name->getName(),function_name->getType()))
	   {
		Symbolinfo* temp=table->LookUp(function_name->getName());
		temp->setDataType(returnType);
		temp->setisFunctionDefination(true);
		temp->setisFunction(true);
		for(int i=0;i<(*param).size();i++)
			 {  cout<<"testing:"<<(*param)[i]->getDataType()<<" ";
			    Symbolinfo *test=new Symbolinfo((*param)[i]->getName(),(*param)[i]->getType(),(*param)[i]->getDataType());
				temp->add_parameter(test);
			 }
	   }
	   else
	   {
		  Symbolinfo* temp=table->LookUp(function_name->getName());
		  if (temp->getDataType()!=returnType)
		     {
				errorfile<<"Line# "<<function_name->GetStartLine()<<": Conflicting types for '"<<function_name->getName()<<"'"<<endl;
				error_count++;
				return;
				
			 }
		  if(temp->getisFunctionDefination()==true)
		  {
			errorfile<<"Line# "<<function_name->GetStartLine()<<": Redefinition of '"<<function_name->getName()<<"'"<<endl;
			error_count++;
			return;
		  }
		  if(temp->getisFunctionDeclaration()==true)
		  {  
             vector<Symbolinfo*>*list=temp->getParameterList();
			 if((*list).size()!=(*param).size())
			 {
				errorfile<<"Line# "<<function_name->GetStartLine()<<": Conflicting types for '"<<function_name->getName()<<"'"<<endl;
				error_count++;
				return;
				
			 }
			 cout<<"hello"<<endl;
			 	 for(Symbolinfo *y:*list)
		{
			cout<<y->getDataType()<<" ";
		}
			 for(int i=0;i<(*list).size();i++)
			 {
				if((*list)[i]->getDataType()!=(*param)[i]->getDataType())
				{
					errorfile<<"Line# "<<(*param)[i]->GetStartLine()<<": Type mismatch for argument "<<i+1<<" of '"<<function_name->getName()<<"'"<<endl;
					error_count++;
				}
			 }
		  }
		  else
		  {
			errorfile<<"Line# "<<function_name->GetStartLine()<<": '"<<function_name->getName()<<"' redeclared as different kind of symbol"<<endl;
			error_count++;
			return;
		  }
	   }
}
void declare_function(string returnType,Symbolinfo* function_name,vector<Symbolinfo*>*param)
{
       if(table->Insert(function_name->getName(),function_name->getType()))
	   {
		Symbolinfo* temp=table->LookUp(function_name->getName());
		temp->setDataType(returnType);
		temp->setisFunctionDeclaration(true);
		temp->setisFunction(true);
		cout<<"ok2"<<endl;
		if(param!=NULL){
		cout<<(*param).size()<<endl;
		for(Symbolinfo* symbol:*param)
			 {  
				Symbolinfo *test=new Symbolinfo(symbol->getName(),symbol->getType(),symbol->getDataType());
				temp->add_parameter(test);
			 }
			cout<<"ok3"<<endl;
		Symbolinfo *x=table->LookUp(function_name->getName());
		vector<Symbolinfo*>* ok=x->getParameterList();
		for(Symbolinfo *y:*ok)
		{
			cout<<y->getDataType()<<" ";
		}
		cout<<endl;
		}
		cout<<"okay4"<<endl;
	   }
	   else
	   {
		  Symbolinfo* temp=table->LookUp(function_name->getName());
		  if (temp->getDataType()!=returnType)
		     {
				errorfile<<"Line# "<<function_name->GetStartLine()<<": Conflicting types for '"<<function_name->getName()<<"'"<<endl;
				error_count++;
				return;
				
			 }
		  if(temp->getisFunctionDeclaration()==true)
		  {
			errorfile<<"Line# "<<function_name->GetStartLine()<<": Redeclaration of '"<<function_name->getName()<<"'"<<endl;
			error_count++;
			return;
		  }
		  if(temp->getisFunctionDefination()==true)
		  {  
             vector<Symbolinfo*>*list=temp->getParameterList();
			 if((*list).size()!=(*param).size())
			 {
				errorfile<<"Line# "<<function_name->GetStartLine()<<": Conflicting types for '"<<function_name->getName()<<"'"<<endl;
				error_count++;
				return;
				
			 }
		
			 for(int i=0;i<(*list).size();i++)
			 {
				if((*list)[i]->getDataType()!=(*param)[i]->getDataType())
				{
					errorfile<<"Line# "<<(*param)[i]->GetStartLine()<<": Type mismatch for argument "<<i+1<<" of '"<<function_name->getName()<<"'"<<endl;
					error_count++;
				}
			 }
		  }
		  else
		  {
			errorfile<<"Line# "<<function_name->GetStartLine()<<": '"<<function_name->getName()<<"' redeclared as different kind of symbol"<<endl;
			error_count++;
			return;
		  }
	   }
}
void add_parameter_toScopeTable(vector<Symbolinfo*>*param)
{  
	
   if (param !=NULL)
    {  int offset=2+(*param).size()*2;
       for(Symbolinfo* symbol:*param)
	   { 
		if(symbol->getName()!=""){
		 if(table->Insert(symbol->getName(),symbol->getType()))
		 {
			Symbolinfo *temp=table->LookUp(symbol->getName());
			if(symbol->getisArray()){
			  temp->setisArray(symbol->getisArray());
			  temp->setarraysize(symbol->getarraysize());
			}
			temp->setDataType(symbol->getDataType());
			temp->set_is_parameter(true);
			temp->setoffset(offset);
			offset-=2;
		 }
		 else
		 {
			errorfile<<"Line# "<<symbol->GetStartLine()<<": Redefinition of parameter '"<<symbol->getName()<<"'"<<endl;
			error_count++;
			return;
		 }
		}
	   }
    }
	
}
void clear_list(vector<Symbolinfo*>*symbols)
{
       for(Symbolinfo* symbol:*symbols)
	   {
		delete symbol;
	   }
	   delete symbols;
}

//function call;

Symbolinfo* CallFunction(Symbolinfo* function_name,vector<Symbolinfo*>*symbols)
{
     Symbolinfo* temp=table->LookUp(function_name->getName());
	 if(temp==NULL)
	 {  
		errorfile<<"Line# "<<function_name->GetStartLine()<<": Undeclared function '"<<function_name->getName()<<"'"<<endl;
		error_count++;

	 }
	 else
	 {
        if(temp->getisFunction()==false)
		{
			temp=NULL;
			errorfile<<"Line# "<<function_name->GetStartLine()<<": Undeclared function '"<<function_name->getName()<<"'"<<endl;
			error_count++;
		}
		else
		{
			vector<Symbolinfo*>* argu=temp->getParameterList();
			cout<<"SIZE"<<(*argu).size()<<endl;
			if((*argu).size()<(*symbols).size())
			{
				errorfile<<"Line# "<<function_name->GetStartLine()<<": Too many arguments to function '"<<function_name->getName()<<"'"<<endl;
				error_count++;
			}
			else if((*argu).size()>(*symbols).size())
			{
				errorfile<<"Line# "<<function_name->GetStartLine()<<": Too few arguments to function '"<<function_name->getName()<<"'"<<endl;
				error_count++;
			}
			else
			{
                for(int i=0;i<(*argu).size();i++)
				{
					if((*argu)[i]->getDataType()!=(*symbols)[i]->getDataType())
					{
						cout<<(*argu)[i]->getDataType()<<"okay"<<(*symbols)[i]->getDataType()<<"okay"<<endl;
                      errorfile<<"Line# "<<(*symbols)[i]->GetStartLine()<<": Type mismatch for argument "<<i+1<<" of '"<<function_name->getName()<<"'"<<endl;
					  error_count++;
					}
				}
			}

		}
	 }
	return temp;
}

%}


%union{
	Symbolinfo* symbolinfo; 
	
}

	/* TERMINAL SYMBOLS */ 
	
%token <symbolinfo> IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN
%token <symbolinfo> ADDOP MULOP RELOP LOGICOP BITOP
%token <symbolinfo> INCOP DECOP ASSIGNOP NOT
%token <symbolinfo> LPAREN RPAREN LCURL RCURL LSQUARE RSQUARE COMMA SEMICOLON
%token <symbolinfo> CONST_INT CONST_FLOAT CONST_CHAR ID
%token <symbolinfo> MULTI_LINE_STRING SINGLE_LINE_STRING 

	/* NON-TERMINAL SYMBOLS */
%type <symbolinfo> start variable factor term unary_expression simple_expression rel_expression logic_expression expression expression_statement statement statements compound_statement type_specifier var_declaration func_declaration func_definition unit program declaration_list argument_list arguments parameter_list if_part


%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%%

start : { 
	      dataout<<";-------\n;\n;-------\n.MODEL SMALL\n.STACK 1000H\n.Data\n\tCR EQU 0DH\n\tLF EQU 0AH\n\tnumber DB \"00000$\"\n";
		  codeout<<".CODE\n";
} program
	{     logfile<<"start : program"<<endl;
		  $$=new Symbolinfo("program","start");
          $$->add_child($2);
		  $$->SetStartLine($2->GetStartLine());
		  $$->SetEndLine($2->GetEndLine());
		  //DFS($$,"");
          logfile<<"Total Lines: "<<line_count<<endl;
	      logfile<<"Total Errors: "<<error_count<<endl;
		  delete table;
		      //code ending
			print_function();
			print_newline();
		  codeout<<"END main\n";
          code_merge();
		//write your code in this block in all the similar blocks below
          
	}
	;

program : program unit {  $$=new Symbolinfo("program unit","program");
                          $$->add_child($1);
						  $$->add_child($2);
						  $$->SetStartLine($1->GetStartLine());
			              $$->SetEndLine($2->GetEndLine());
	                     logfile<<"program : program unit"<<endl;
                       }
	       |unit {
			  $$=new Symbolinfo("unit","program");
              $$->add_child($1);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($1->GetEndLine());
		      logfile<<"program : unit"<<endl;           
	        }
	;
	
unit : var_declaration{ 
	                     $$=new Symbolinfo("var_declaration","unit");
						 $$->add_child($1);
						 $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
                        logfile<<"unit : var_declaration"<<endl;
					  }
     | func_declaration
	                  {
						 $$=new Symbolinfo("func_declaration","unit");
						 $$->add_child($1);
						 $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
                        logfile<<"unit : func_declaration"<<endl;
					  }
     | func_definition
	                   {
						$$=new Symbolinfo("func_definition","unit");
						$$->add_child($1);
						$$->SetStartLine($1->GetStartLine());
			            $$->SetEndLine($1->GetEndLine());
						logfile<<"unit : func_definition"<<endl;
					   }
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {
	             cout<<"okay"<<endl;
				 Symbolinfo *info=new Symbolinfo($2->getName(),$2->getType());
				 info->SetStartLine($2->GetStartLine());
				 info->SetEndLine($2->GetEndLine());
	             declare_function($1->getDataType(),info,function_parameter);
                logfile<<"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON"<<endl; 
				 //delete $1;
				 //delete $2;
				  $$=new Symbolinfo("type_specifier ID LPAREN parameter_list RPAREN SEMICOLON","func_declaration");
					 $$->add_child($1);
                     $$->add_child($2);
			         $$->add_child($3);
					 $$->add_child($4);
					 $$->add_child($5);
					 $$->add_child($6);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($6->GetEndLine());
				 clear_list(function_parameter);
                     }
		| type_specifier ID LPAREN RPAREN SEMICOLON {
			Symbolinfo *info=new Symbolinfo($2->getName(),$2->getType());
			 info->SetStartLine($2->GetStartLine());
			 info->SetEndLine($2->GetEndLine());
			declare_function($1->getDataType(),info,new vector<Symbolinfo*>());
			 //delete $1;
			 //delete $2;
			 $$=new Symbolinfo("type_specifier ID LPAREN RPAREN SEMICOLON","func_declaration");
					 $$->add_child($1);
                     $$->add_child($2);
			         $$->add_child($3);
					 $$->add_child($4);
					 $$->add_child($5);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($5->GetEndLine());
			logfile<<"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON"<<endl;
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN { Symbolinfo *info=new Symbolinfo($2->getName(),$2->getType());  info->SetStartLine($2->GetStartLine());
				 info->SetEndLine($2->GetEndLine());define_function($1->getDataType(),info,function_parameter); function_start($2);}compound_statement {
                    //clear_list($4);
					//delete $1;
					$$=new Symbolinfo("type_specifier ID LPAREN parameter_list RPAREN compound_statement","func_definition");
					 $$->add_child($1);
                     $$->add_child($2);
			         $$->add_child($3);
					 $$->add_child($4);
					 $$->add_child($5);
					 $$->add_child($7);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($7->GetEndLine());
                    logfile<<"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement"<<endl;
					if(($1->getDataType()=="INT" || $1->getDataType()=="FLOAT")&& function_return=="")
					{
                       errorfile<<"Line# "<<returnLine<<": Not returning any "<<$1->getDataType()<<" type value"<<endl;
					   error_count++;
					}
					else if($1->getDataType()=="VOID" &&(function_return=="INT" ||function_return=="FLOAT"))
					{
						errorfile<<"Line# "<<returnLine<<": Returing "<<function_return<<" in VOID return type function"<<endl;
						error_count++;
					}
					else if($1->getDataType()!=function_return && function_return!="")
					{
                        errorfile<<"Line# "<<returnLine<<": Return type mismatched"<<endl;
						error_count++;
					}
					returnLine=-1;
					function_return="";
					function_end($2,var_prevscope,$7->getlabel());
                }
		        | type_specifier ID LPAREN RPAREN {Symbolinfo *info=new Symbolinfo($2->getName(),$2->getType()); info->SetStartLine($2->GetStartLine());
				 info->SetEndLine($2->GetEndLine());define_function($1->getDataType(),info,new vector<Symbolinfo*>());function_start($2);}compound_statement {
					//delete $1;
					$$=new Symbolinfo("type_specifier ID LPAREN RPAREN compound_statement","func_definition");
					 $$->add_child($1);
                     $$->add_child($2);
			         $$->add_child($3);
					 $$->add_child($4);
					 $$->add_child($6);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($6->GetEndLine());
                    logfile<<"func_definition : type_specifier ID LPAREN RPAREN compound_statement"<<endl;
					if(($1->getDataType()=="INT" || $1->getDataType()=="FLOAT")&& function_return=="")
					{
                       errorfile<<"Line# "<<returnLine<<": Not returning any "<<$1->getDataType()<<" type value"<<endl;
					   error_count++;
					}
					else if($1->getDataType()=="VOID" &&(function_return=="INT" ||function_return=="FLOAT"))
					{
						errorfile<<"Line# "<<returnLine<<": Returing "<<function_return<<" in VOID return type function"<<endl;
						error_count++;
					}
					else if($1->getDataType()!=function_return && function_return!="")
					{
                        errorfile<<"Line# "<<returnLine<<": Return type mismatched"<<endl;
						error_count++;
					}
					returnLine=-1;
					function_return="";
					function_end($2,var_prevscope,$6->getlabel());
		}
 		;				


parameter_list : parameter_list COMMA type_specifier ID {
	              Symbolinfo *info=new Symbolinfo($4->getName(),$4->getType(),$3->getDataType());
				  info->SetStartLine($3->GetStartLine());
				  info->SetEndLine($3->GetEndLine());
				  function_parameter->push_back(info);
                  logfile<<"parameter_list : parameter_list COMMA type_specifier ID"<<endl;
				  $$=new Symbolinfo("parameter_list COMMA type_specifier ID","parameter_list");
					 $$->add_child($1);
                     $$->add_child($2);
			         $$->add_child($3);
					 $$->add_child($4);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($4->GetEndLine());
            }
		| parameter_list COMMA type_specifier {
			      Symbolinfo *info=new Symbolinfo("","",$3->getDataType());
				   info->SetStartLine($3->GetStartLine());
				  info->SetEndLine($3->GetEndLine());
			      function_parameter->push_back(info);
                  logfile<<"parameter_list : parameter_list COMMA type_specifier"<<endl;
				   $$=new Symbolinfo("parameter_list COMMA type_specifier","parameter_list");
					 $$->add_child($1);
                     $$->add_child($2);
			         $$->add_child($3);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($3->GetEndLine());
		   }
 		| type_specifier ID {
			      
				  function_parameter=new vector<Symbolinfo*>();
			      Symbolinfo *info=new Symbolinfo($2->getName(),$2->getType(),$1->getDataType());
				   info->SetStartLine($1->GetStartLine());
				  info->SetEndLine($1->GetEndLine());
			      function_parameter->push_back(info);
                  logfile<<"parameter_list : type_specifier ID"<<endl;
				  $$=new Symbolinfo("type_specifier ID","parameter_list");
					 $$->add_child($1);
                     $$->add_child($2);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($2->GetEndLine());
		 }
		| type_specifier {
			 
			  function_parameter=new vector<Symbolinfo*>();
			  Symbolinfo *info=new Symbolinfo("","",$1->getDataType());
			  info->SetStartLine($1->GetStartLine());
				  info->SetEndLine($1->GetEndLine());
			  function_parameter->push_back(info);
              logfile<<"parameter_list : type_specifier"<<endl;
			  $$=new Symbolinfo("type_specifier","parameter_list");
					 $$->add_child($1);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($1->GetEndLine());
		  }
 		;

 		
compound_statement : LCURL{ table->Enter_Scope();if(function_parameter!=NULL){add_parameter_toScopeTable(function_parameter); clear_list(function_parameter);function_parameter=NULL;}} statements RCURL {
                        $$=new Symbolinfo("LCURL statements RCURL","compound_statement",$3->getDataType());
					    $$->add_child($1);
						$$->add_child($3);
						$$->add_child($4);
					    $$->SetStartLine($1->GetStartLine());
			           $$->SetEndLine($4->GetEndLine());
					   logfile<<"compound_statement : LCURL statements RCURL"<<endl;
					   var_prevscope=table->getvarCountCurrentScope();
					   table->printAll(logfile);
					   table->Exit_Scope();
					    
				   $$->setlabel($3->getlabel());
                  }
 		    | LCURL{ table->Enter_Scope();add_parameter_toScopeTable(function_parameter);clear_list(function_parameter);} RCURL {
				        $$=new Symbolinfo("LCURL RCURL","compound_statement");
					    $$->add_child($1);
						$$->add_child($3);
						 var_prevscope=table->getvarCountCurrentScope();
					    $$->SetStartLine($1->GetStartLine());
			           $$->SetEndLine($3->GetEndLine());
					  table->printAll(logfile);
				      table->Exit_Scope();
					    
				   $$->setlabel("");
                      logfile<<"compound_statement : LCURL RCURL"<<endl;
			}
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {
	                 $$=new Symbolinfo("type_specifier declaration_list SEMICOLON","var_declaration");
					 $$->add_child($1);
                     $$->add_child($2);
			         $$->add_child($3);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($3->GetEndLine());
	                 cout<<"yo"<<endl;
	                  variable_declare($1->getDataType(),variable_declaration);
					  cout<<"bleh"<<endl;
					  clear_list(variable_declaration);
					  //delete $1;
	                  logfile<<"var_declaration	: type_specifier declaration_list SEMICOLON"<<endl;

           }
 		 ;
 	
type_specifier	: INT { 
	                 $$=new Symbolinfo("INT","type_specifier");
					 $$->setDataType("INT");
					 $$->add_child($1);
					 $$->SetStartLine($1->GetStartLine());
			         $$->SetEndLine($1->GetEndLine());
	                 logfile<<"type_specifier : INT"<<endl;
                         
                    }
 		| FLOAT  {  
			        $$=new Symbolinfo("FLOAT","type_specifier");
					$$->setDataType("FLOAT");
					$$->add_child($1);
					$$->SetStartLine($1->GetStartLine());
			        $$->SetEndLine($1->GetEndLine());
			        logfile<<"type_specifier : FLOAT"<<endl;

                         }
 		| VOID    {
			        $$=new Symbolinfo("VOID","type_specifier");
					$$->setDataType("VOID");
					$$->add_child($1);
					$$->SetStartLine($1->GetStartLine());
			        $$->SetEndLine($1->GetEndLine());
			        logfile<<"type_specifier : VOID"<<endl;
                         }
 		;
 		
declaration_list : declaration_list COMMA ID {
	               Symbolinfo *child=new Symbolinfo($3->getName(),$3->getType());
				   child->setisglobal(table->get_Current_Scope());
	               variable_declaration->push_back(child);
				   child->setoffset((table->getvarCountCurrentScope()+1)*2);
			       table->varCountCurrentScope(1);
				   variable_declare_code(child,line_count+":declaring variable "+$3->getName());
                   logfile<<"declaration_list : declaration_list COMMA ID"<<endl;
				   $$=new Symbolinfo("declaration_list COMMA ID","declaration_list");
				   $$->add_child($1);
                   $$->add_child($2);
			       $$->add_child($3);
				   $$->SetStartLine($1->GetStartLine());
			       $$->SetEndLine($3->GetEndLine());	   
          }
 		  | declaration_list COMMA ID LSQUARE CONST_INT RSQUARE {
			    Symbolinfo *child=new Symbolinfo($3->getName(),$3->getType());
			    child->setisArray(true);
			    child->setarraysize($5->getName());
				child->setisglobal(table->get_Current_Scope());
				child->setoffset((table->getvarCountCurrentScope()+1)*2);
			    table->varCountCurrentScope(stoi($5->getName()));
				variable_declaration->push_back(child);
				variable_declare_code(child,line_count+":declaring array "+$3->getName());
               logfile<<"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE"<<endl;
			   $$=new Symbolinfo("declaration_list COMMA ID LSQUARE CONST_INT RSQUARE","declaration_list");
			  $$->add_child($1);
              $$->add_child($2);
			  $$->add_child($3);
              $$->add_child($4);
			  $$->add_child($5);
              $$->add_child($6);
			  $$->SetStartLine($1->GetStartLine());
			$$->SetEndLine($6->GetEndLine());
          }
 		  | ID { 
			    variable_declaration=new vector<Symbolinfo*>();
				Symbolinfo *child=new Symbolinfo($1->getName(),$1->getType());
				child->setisglobal(table->get_Current_Scope());
				child->setoffset((table->getvarCountCurrentScope()+1)*2);
			    table->varCountCurrentScope(1);
				variable_declaration->push_back(child);
				//variable_declare_assign(child);
				variable_declare_code(child,line_count+":declaring variable "+$1->getName());
               logfile<<"declaration_list : ID	"<<endl;
			   $$=new Symbolinfo("ID","declaration_list");
			   $$->add_child($1);
			   cout<<"isleaf:"<<$1->getisLeaf()<<endl;
			   $$->SetStartLine($1->GetStartLine());
			   $$->SetEndLine($1->GetEndLine());
          }
 		  | ID LSQUARE CONST_INT RSQUARE {
			Symbolinfo *child=new Symbolinfo($1->getName(),$1->getType());
			child->setisArray(true);
			child->setarraysize($3->getName());
			child->setisglobal(table->get_Current_Scope());
			child->setoffset((table->getvarCountCurrentScope()+1)*2);
			table->varCountCurrentScope(stoi($3->getName()));
			//variable_declare_assign(child);
			variable_declare_code(child,line_count+":declaring array "+$1->getName());
            variable_declaration=new vector<Symbolinfo*>();
			variable_declaration->push_back(child);
            logfile<<"declaration_list : ID LSQUARE CONST_INT RSQUARE"<<endl;
			$$=new Symbolinfo("ID LSQUARE CONST_INT RSQUARE","declaration_list");
			$$->add_child($1);
            $$->add_child($2);
			$$->add_child($3);
            $$->add_child($4);
			$$->SetStartLine($1->GetStartLine());
			$$->SetEndLine($4->GetEndLine());
          }
 		  ;
 		  
statements : statement {
	               $$=new Symbolinfo("statement","statements",$1->getDataType());
			       $$->add_child($1);
			       $$->SetStartLine($1->GetStartLine());
			       $$->SetEndLine($1->GetEndLine());
                   logfile<<"statements	: statement"<<endl;
				   if($1->getlabel()!="")
				   $$->setlabel($1->getlabel());
        }
	   | statements statement {
		      $$=new Symbolinfo("statements statement","statements");
			$$->add_child($1);
            $$->add_child($2);
			$$->SetStartLine($1->GetStartLine());
			$$->SetEndLine($2->GetEndLine());
              logfile<<"statements : statements statement"<<endl;
			   if($2->getlabel()!="")
				   $$->setlabel($2->getlabel());
				else   if($1->getlabel()!="")
				   $$->setlabel($1->getlabel());
	   }
	   ;
	   
statement : var_declaration {
	           		      $$=new Symbolinfo("var_declaration","statement");
			              $$->add_child($1);
			              $$->SetStartLine($1->GetStartLine());
			              $$->SetEndLine($1->GetEndLine());
                          logfile<<"statement : var_declaration"<<endl;
        }
	  | expression_statement {
		                  $$=new Symbolinfo("expression_statement","statement");
			              $$->add_child($1);
			              $$->SetStartLine($1->GetStartLine());
			              $$->SetEndLine($1->GetEndLine());
             logfile<<"statement : expression_statement"<<endl;
	  }
	  | compound_statement {
		      $$=new Symbolinfo("compound_statement","statement");
			              $$->add_child($1);
			              $$->SetStartLine($1->GetStartLine());
			              $$->SetEndLine($1->GetEndLine());
             logfile<<"statement : compound_statement"<<endl;
	  }
	  | FOR LPAREN expression_statement {for_start=newLabel();for_inc_start=newLabel();for_inc_end=newLabel();for_end=newLabel();codeout<<for_start<<":\n";
	     $2->addlabel(for_start);$2->addlabel(for_inc_start);$2->addlabel(for_inc_end);$2->addlabel(for_end);}
	  expression_statement { 
		            
                    // codeout<<"\tPOP AX\n";
					 codeout<<"\tCMP AX ,0\n";
					 codeout<<"\tJE "<<for_end<<"\n";
					 codeout<<"\tJMP "<<for_inc_end<<"\n";
					 codeout<<for_inc_start<<":\n";
	  } expression{ codeout<<"\tJMP "<<for_start<<"\n";codeout<<for_inc_end<<":\n";} RPAREN statement {
		      
			  $$=new Symbolinfo("FOR LPAREN expression_statement expression_statement expression RPAREN statement","statement");
		 
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			  $$->add_child($5);
			  $$->add_child($7);
			  $$->add_child($9);
			  $$->add_child($10);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($10->GetEndLine());
             logfile<<"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement"<<endl;

			 //CODE
			 codeout<<"\tJMP "<<(*($2->getlabels()))[1]<<"\n";
			 codeout<<(*($2->getlabels()))[3]<<":\n";
	  }
	  | if_part %prec LOWER_THAN_ELSE{
		      $$=new Symbolinfo("IF LPAREN expression RPAREN statement","statement");
			//   $$->add_child($1);
			//   $$->add_child($2);
			//   $$->add_child($3);
			//   $$->add_child($5);
			//   $$->add_child($6);
			//   $$->SetStartLine($1->GetStartLine());
			//   $$->SetEndLine($6->GetEndLine());
              logfile<<"statement : IF LPAREN expression RPAREN statement"<<endl;
			  codeout<<$1->getlabel()<<":\n";
	  }
	  |if_part ELSE{ 
		           string endelse=newLabel();
		           codeout<<"\tJMP "<<endelse<<"\n";
				   codeout<<$1->getlabel()<<":\n";
				   $1->setlabel(endelse);
	  } statement {
		      $$=new Symbolinfo("IF LPAREN expression RPAREN statement ELSE statement","statement");
			//   $$->add_child($1);
			//   $$->add_child($2);
			//   $$->add_child($3);
			//   $$->add_child($5);
			//   $$->add_child($6);
			//   $$->add_child($8);
			//   $$->add_child($10);
			//   $$->SetStartLine($1->GetStartLine());
			//   $$->SetEndLine($10->GetEndLine());
              logfile<<"statement : IF LPAREN expression RPAREN statement ELSE statement"<<endl;
			  codeout<<$1->getlabel()<<":\n";
	  }
	  | WHILE LPAREN{while_start=newLabel();while_end=newLabel();codeout<<while_start<<":\n";
	      $2->addlabel(while_start);$2->addlabel(while_end);
		 } expression { 
		          //code
				  
				  //codeout<<"\tPOP AX\n";
				  codeout<<"\tCMP AX, 0\n";
				  codeout<<"\tJE "<<while_end<<"\n";
	  } RPAREN statement {
		     $$=new Symbolinfo("WHILE LPAREN expression RPAREN statement","statement");
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($4);
			  $$->add_child($6);
			   $$->add_child($7);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($7->GetEndLine());
             logfile<<"statement : WHILE LPAREN expression RPAREN statement"<<endl;

			 //CODE
			 codeout<<"\tJMP "<<(*($2->getlabels()))[0]<<"\n";
			 codeout<<(*($2->getlabels()))[1]<<":\n";
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON {
		      $$=new Symbolinfo("PRINTLN LPAREN ID RPAREN SEMICOLON","statement");
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			  $$->add_child($4);
			  $$->add_child($5);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($5->GetEndLine());
             logfile<<"statement : PRINTLN LPAREN ID RPAREN SEMICOLON"<<endl;
			 //code
			 variable_code($3);
			 codeout<<"\tCALL print_output\n";
	         codeout<<"\tCALL new_line\n";

	  }
	  | RETURN expression SEMICOLON {
		      $$=new Symbolinfo("RETURN expression SEMICOLON","statement");
			  $$->setDataType($2->getDataType());
			  function_return=$2->getDataType();
			  returnLine=line_count;
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($3->GetEndLine());
             logfile<<"statement : RETURN expression SEMICOLON"<<endl;
			 string label=newLabel();
			 $$->setlabel(label);
			 codeout<<"\tJMP "<<label<<"\t;nothing after return statement and before function end will execute\n";
	  }
	  ;

if_part:  IF LPAREN expression {
		         //codeout<<"\tPOP AX\n";
				 codeout<<"\tCMP AX, 0\n";
				 string endif=newLabel();
				 codeout<<"\tJE "<<endif<<"\n";
				 $3->setlabel(endif); }RPAREN statement{$$->setlabel($3->getlabel()); };
        
expression_statement : SEMICOLON{
	           $$=new Symbolinfo("SEMICOLON","expression_statement");
			  $$->add_child($1);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($1->GetEndLine());
              logfile<<"expression_statement : SEMICOLON"<<endl;
            }		
			| expression SEMICOLON {
				$$=new Symbolinfo("expression SEMICOLON","expression_statement",$1->getDataType());
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($2->GetEndLine());
              logfile<<"expression_statement : expression SEMICOLON"<<endl;
			}
			;
	  
variable : ID {
	          
			  Symbolinfo *info=table->LookUp($1->getName());
			  
			  if(info==NULL)
			  {
                errorfile<<"Line# "<<line_count<<": Undeclared variable '"<<$1->getName()<<"'"<<endl;
				 $$=new Symbolinfo("ID","variable","");
				 error_count++;
			  }else {
			    $$=new Symbolinfo("ID","variable",info->getDataType());
			   
			  }
			  $$->add_child($1);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($1->GetEndLine());
              logfile<<"variable : ID"<<endl;
			
			  
            }	
	 | ID LSQUARE expression RSQUARE {
		      
		   codeout<<"\tMOV BX, AX\t;\n";
	 
		      Symbolinfo *info=table->LookUp($1->getName());
			  if(info==NULL)
			  {
                errorfile<<"Line# "<<line_count<<": Undeclared variable '"<<$1->getName()<<"'"<<endl;
				error_count++;
                $$=new Symbolinfo("ID LSQUARE expression RSQUARE","variable","");
			  }
			  else
			  {
				$$=new Symbolinfo("ID LSQUARE expression RSQUARE","variable",info->getDataType());
				if(!info->getisArray())
				{
					errorfile<<"Line# "<<line_count<<": '"<<$1->getName()<<"' is not an array"<<endl;
					error_count++;
				}
				 if($3->getDataType()!="INT")
			   {
				errorfile<<"Line# "<<line_count<<": Array subscript is not an integer"<<endl;
				error_count++;
			   }
			   
			  }
			    
			  $$->add_child($1);
			   $$->add_child($2);
			    $$->add_child($3);
				 $$->add_child($4);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($4->GetEndLine());
		       $$->set_arrayindex($3->get_arrayindex());
			   cout<<"\n\t"<<$3->get_arrayindex()<<"\n";
            logfile<<"variable	: ID LSQUARE expression RSQUARE"<<endl;
			
			
	 }
	 ;
	 
expression : logic_expression {
	                 $$=new Symbolinfo("logic_expression","expression",$1->getDataType());
					 $$->add_child($1);
			  
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($1->GetEndLine());
	                 if($1->getiszero())
						 {
							$$->setisZero(true);
						 }
	         $$->set_arrayindex($1->get_arrayindex());
             logfile<<"expression : logic_expression"<<endl;
        }
	   | variable ASSIGNOP logic_expression {
		        if($1->getDataType()=="FLOAT"||$3->getDataType()=="FLOAT")
							{
								 $$=new Symbolinfo("variable ASSIGNOP logic_expression","expression","FLOAT");
							}else
		       $$=new Symbolinfo("variable ASSIGNOP logic_expression","expression",$1->getDataType());
					 $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			 
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($3->GetEndLine());
		      if($3->getiszero())
						 {
							$$->setisZero(true);
						 }
		      if(($1->getDataType()=="INT" && $3->getDataType()=="FLOAT")){
		      errorfile<<"Line# "<<line_count<<": Warning: possible loss of data in assignment of "<<$3->getDataType()<<" to "<<$1->getDataType()<<endl;
			  error_count++;
			  }
		    if($3->getDataType()=="VOID")
			  {
				errorfile<<"Line# "<<line_count<<": Void cannot be used in expression "<<endl;
				error_count++;
			  }
			  vector<Symbolinfo*>temp=*($1->getChildList());
              logfile<<"expression : variable ASSIGNOP logic_expression"<<endl;
			  //codeout<<"\tPOP AX\n";
			  assigntovariable(temp[0],$1->get_arrayindex());
              //codeout<<"\tPUSH AX\n";
	          arrayindex=-1;
	   }	
	   ;
			
logic_expression : rel_expression {
	                    $$=new Symbolinfo("rel_expression","logic_expression",$1->getDataType());
					    $$->add_child($1);
			            $$->SetStartLine($1->GetStartLine());
			            $$->SetEndLine($1->GetEndLine());
	                    
	                     if($1->getiszero())
						 {
							$$->setisZero(true);
						 }
	              				cout<<"checking:"<<$1->getDataType()<<endl;
	              
                  logfile<<"logic_expression : rel_expression"<<endl;
				     $$->set_arrayindex($1->get_arrayindex());
        }
		 | rel_expression {codeout<<"\tPUSH AX\n";}LOGICOP rel_expression {
			        
			  $$=new Symbolinfo("rel_expression LOGICOP rel_expression","logic_expression","INT");
			  $$->add_child($1);
			  $$->add_child($3);
			  $$->add_child($4);
			 
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($4->GetEndLine());
			     if($1->getDataType()=="VOID"||$4->getDataType()=="VOID")
			  {
				errorfile<<"Line# "<<line_count<<": Void cannot be used in expression"<<endl;
				error_count++;
			  }
                 logfile<<"logic_expression	: rel_expression LOGICOP rel_expression "<<endl;
				
             //CODING PART
			 string label=newLabel();
			 string label2=newLabel();
			 codeout<<"\tPUSH AX\n";
			 if($3->getName()=="||"){
			  codeout<<"\tPOP BX\n";
              codeout<<"\tPOP AX\n";
			  codeout<<"\tCMP AX, 0\n";
			  codeout<<"\tJNE "<<label<<"\n";
			  codeout<<"\tCMP BX, 0\n";
			  codeout<<"\tJNE "<<label<<"\n";
			  codeout<<"\tMOV AX, 0\n";
			  //codeout<<"\tPUSH AX\n";
			  codeout<<"\tJMP "<<label2<<"\n";
              codeout<<label<<":\n";
			  codeout<<"\tMOV AX, 1\n";
			  //codeout<<"\tPUSH AX\n";
			  codeout<<label2<<":\n";
			 }
			 else
			 {
              codeout<<"\tPOP BX\n";
              codeout<<"\tPOP AX\n";
			  codeout<<"\tCMP AX, 0\n";
			  codeout<<"\tJE "<<label<<"\n";
			  codeout<<"\tCMP BX, 0\n";
			  codeout<<"\tJE "<<label<<"\n";
			  codeout<<"\tMOV AX, 1\n";
			  //codeout<<"\tPUSH AX\n";
			  codeout<<"\tJMP "<<label2<<"\n";
              codeout<<label<<":\n";
			  codeout<<"\tMOV AX, 0\n";
			  //codeout<<"\tPUSH AX\n";
			  codeout<<label2<<":\n";
			 }
		 }	
		 ;
			
rel_expression	: simple_expression {
	                             $$=new Symbolinfo("simple_expression","rel_expression",$1->getDataType());
					             $$->add_child($1);
			  
			                      $$->SetStartLine($1->GetStartLine());
			                      $$->SetEndLine($1->GetEndLine());
	                         
	                            if($1->getiszero())
						 {
							$$->setisZero(true);
						 }
	              				cout<<"checking:"<<$1->getDataType()<<endl;
	             
                  logfile<<"rel_expression : simple_expression"<<endl;
				     $$->set_arrayindex($1->get_arrayindex());
        }
		| simple_expression {codeout<<"\tPUSH AX\n";}RELOP simple_expression	{
			    $$=new Symbolinfo("simple_expression RELOP simple_expression","rel_expression","INT");
				$$->add_child($1);
			    $$->add_child($3);
			    $$->add_child($4);
			    $$->SetStartLine($1->GetStartLine());
			    $$->SetEndLine($4->GetEndLine());
			
            logfile<<"rel_expression : simple_expression RELOP simple_expression"<<endl;
			   if($4->getDataType()=="VOID"||$1->getDataType()=="VOID")
			  {
				errorfile<<"Line# "<<line_count<<": Void cannot be used in expression "<<endl;
				error_count++;
			  }
               string Relop=get_relop($3);
			   string label=newLabel();
			   string label2=newLabel();
			  //code
			  codeout<<"\tPUSH AX\n";
			  codeout<<"\tPOP BX\n";
			  codeout<<"\tPOP AX\n";
			  codeout<<"\tCMP AX, BX\n";
			  codeout<<"\t"<<Relop<<" "<<label<<"\n";
			  codeout<<"\tMOV AX, 0\n";
			  //codeout<<"\tPUSH AX\n";
			  codeout<<"\tJMP "<<label2<<"\n";
			  codeout<<label<<":\n";
			  codeout<<"\tMOV AX, 1\n";
			  //codeout<<"\tPUSH AX\n";
			  codeout<<label2<<":\n";
		}
		;
				
simple_expression : term {
	                  $$=new Symbolinfo("term","simple_expression",$1->getDataType());
					 $$->add_child($1);
			         $$->SetStartLine($1->GetStartLine());
			          $$->SetEndLine($1->GetEndLine());
	                  cout<<"checking:"<<$1->getDataType()<<endl;
	                  
						 if($1->getiszero())
						 {
							$$->setisZero(true);
						 }
                     logfile<<"simple_expression : term"<<endl;
					    $$->set_arrayindex($1->get_arrayindex());
        }
		  | simple_expression {codeout<<"\tPUSH AX\n";}ADDOP term {
			             if($1->getDataType()=="FLOAT"||$3->getDataType()=="FLOAT")
							{
								 $$=new Symbolinfo("simple_expression ADDOP term","simple_expression","FLOAT");
							}
							else{
			              $$=new Symbolinfo("simple_expression ADDOP term","simple_expression",$1->getDataType());
							}
						$$->add_child($1);
						$$->add_child($3);
						$$->add_child($4);

						$$->SetStartLine($1->GetStartLine());
						$$->SetEndLine($4->GetEndLine());
			
			          
						 if ($1->getName()==$4->getName() && $3->getName()=="-")
						 {
							$$->setisZero(true);
						 }
						 if($4->getiszero() && $1->getiszero())
						 {
							$$->setisZero(true);
						 }
						    if($4->getDataType()=="VOID"||$1->getDataType()=="VOID")
			             {
				      errorfile<<"Line# "<<line_count<<": Void cannot be used in expression "<<endl;
					  error_count++;
			             }
                    logfile<<"simple_expression : simple_expression ADDOP term"<<endl;

					//code
					codeout<<"\tPUSH AX\n";
					ADDOP_code($3);
		  } 
		  ;
					
term :	unary_expression {
	                     cout<<"checking:"<<$1->getDataType()<<endl;
	                        $$=new Symbolinfo("unary_expression","term",$1->getDataType());
					 $$->add_child($1);
			  
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($1->GetEndLine());
						 if($1->getiszero())
						 {
							$$->setisZero(true);
						 }
                         logfile<<"term : unary_expression"<<endl;
						$$->set_arrayindex($1->get_arrayindex());
        }
     |  term{codeout<<"\tPUSH AX\n";} MULOP unary_expression {
		                 cout<<"unary_expression:"<<$3->getiszero()<<endl;
						    if(($1->getDataType()=="FLOAT"||$3->getDataType()=="FLOAT")&& $3->getName()!="%")
							{
								 $$=new Symbolinfo("term MULOP unary_expression","term","FLOAT");
							}else{
		                    $$=new Symbolinfo("term MULOP unary_expression","term",$1->getDataType());
							}
					 $$->add_child($1);
			         $$->add_child($3);
			          $$->add_child($4);
			  
			         $$->SetStartLine($1->GetStartLine());
			        $$->SetEndLine($4->GetEndLine());
						 if(($3->getName()=="%" || $3->getName()=="/")&&($4->getiszero()))
						 {
							errorfile<<"Line# "<<line_count<<": Warning: division by zero i=0f=1Const=0"<<endl;
							error_count++;
						 }
						 if($3->getName()=="%" && ($4->getDataType()!="INT"||$1->getDataType()!="INT")){
							errorfile<<"Line# "<<line_count<<": Operands of modulus must be integers "<<endl;
							error_count++;
						 }
						 if(($3->getName()=="*")&&($4->getiszero()||$1->getiszero()))
						 {
							$$->setisZero(true);
						 }
						    if($3->getDataType()=="VOID"||$1->getDataType()=="VOID")
			             {
				           errorfile<<"Line# "<<line_count<<": Void cannot be used in expression "<<endl;
				           error_count++;
			             }
                         logfile<<"term : term MULOP unary_expression"<<endl;

						 //code part
						 codeout<<"\tPUSH AX\n";
						 MULOP_code($3);
	 }
     ;

unary_expression : ADDOP unary_expression {
	                    
	                     $$=new Symbolinfo("ADDOP unary_expression","unary_expression",$2->getDataType());
					     $$->add_child($1);
			             $$->add_child($2);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($2->GetEndLine());
                        logfile<<"unary_expression : ADDOP unary_expression"<<endl;
						   if($2->getDataType()=="VOID")
			              {
				             errorfile<<"Line# "<<line_count<<": Void cannot be used in expression"<<endl;
							 error_count++;
			              }
                 
				 //code

				 if($1->getName()=="-")
				 {
					//codeout<<"\tPOP AX\n";
					codeout<<"\tNEG AX\n";
					codeout<<"\tPUSH AX\n";
				 }

         } 
		 | NOT unary_expression {
			             $$=new Symbolinfo("NOT unary_expression","unary_expression",$2->getDataType());
					     $$->add_child($1);
			             $$->add_child($2);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($2->GetEndLine());
                        logfile<<"unary_expression : NOT unary_expression"<<endl;
						   if($2->getDataType()=="VOID")
			  {
				errorfile<<"Line# "<<line_count<<": Void cannot be used in expression "<<endl;
				error_count++;
			  }

            
			  //code 
              string label=newLabel();
			  string label2=newLabel();
			  //codeout<<"\tPOP AX\n";
			  codeout<<"\tCMP AX, 0\n";
			  codeout<<"\tJE "<<label<<"\n";
			  codeout<<"\t MOV AX, 0\n";
			  codeout<<"\tJMP "<<label2<<"\n";
			  codeout<<label<<":\n";
			  codeout<<"\t MOV AX, 0\n";
			  codeout<<label2<<":\n";

		 }
		 | factor {   
			          cout<<"FACTOR:"<<$1->getiszero()<<endl;
					  $$=new Symbolinfo("factor","unary_expression",$1->getDataType());
					     $$->add_child($1);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
			          if($1->getiszero())
						 {
							$$->setisZero(true);
						 }
			          cout<<"checking:"<<$1->getDataType()<<endl;
			          $$->set_arrayindex($1->get_arrayindex());
                      logfile<<"unary_expression : factor"<<endl;
		 }
		 ;
	
factor	: variable{  
	                    
					  $$=new Symbolinfo("variable","factor",$1->getDataType());
					     $$->add_child($1);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
					  cout<<"checking:"<<$1->getDataType()<<endl;
                      logfile<<"factor : variable"<<endl;
					  vector<Symbolinfo*>temp=*($1->getChildList());
					  variable_code(temp[0],$1->get_arrayindex());
					  
					  
        }
	| ID LPAREN argument_list RPAREN {//function call
	                
					 cout<<endl;
	                  Symbolinfo *info=CallFunction($1,ArgumentList);
					  if(info==NULL)
					   $$=new Symbolinfo("ID LPAREN argument_list RPAREN","factor","");
					   else
					    $$=new Symbolinfo("ID LPAREN argument_list RPAREN","factor",info->getDataType());
					     $$->add_child($1);
						 $$->add_child($2);
						 $$->add_child($3);
						 $$->add_child($4);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($4->GetEndLine());
					  clear_list(ArgumentList);
					  //delete $1;
                      logfile<<"factor : ID LPAREN argument_list RPAREN"<<endl;
					  codeout<<"\tCALL "<<$1->getName()<<"\n";
	}
	| LPAREN expression RPAREN {
		             $$=new Symbolinfo("LPAREN expression RPAREN","factor",$2->getDataType());
					     $$->add_child($1);
						 $$->add_child($2);
						 $$->add_child($3);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($3->GetEndLine());
                     logfile<<"factor : LPAREN expression RPAREN"<<endl;
	}
	| CONST_INT {
                $1->setDataType("INT");
		        $$=new Symbolinfo("CONST_INT","factor",$1->getDataType());
					     $$->add_child($1);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
		        $$->set_arrayindex(atoi(($1->getName()).c_str()));
				if($1->getName()=="0")
				{
					$$->setisZero(true);
				}
                logfile<<"factor : CONST_INT"<<endl;
				codeout<<"\tMOV AX, "<<$1->getName()<<"\t;line number:"<<line_count<<"\n";
				//codeout<<"\tPUSH AX\t;line number:"<<line_count<<"\n";
				arrayindex=stoi($1->getName());
	}
	| CONST_FLOAT {
		         $1->setDataType("FLOAT");
		       $$=new Symbolinfo("CONST_FLOAT","factor",$1->getDataType());
					     $$->add_child($1);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
		      codeout<<"\tMOV AX, "<<$1->getName()<<"\t;line number:"<<line_count<<"\n";
			  //codeout<<"\tPUSH AX\t;line number:"<<line_count<<"\n";
               logfile<<"factor : CONST_FLOAT"<<endl;
	}
	| variable INCOP {
		       $$=new Symbolinfo("variable INCOP","factor",$1->getDataType());
					     $$->add_child($1);
						 $$->add_child($2);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($2->GetEndLine());
             logfile<<"factor : variable INCOP"<<endl;
			  vector<Symbolinfo*>temp=*($1->getChildList());
					  variable_code(temp[0],$1->get_arrayindex());
					  codeout<<"\tPUSH AX\n";
					  codeout<<"\tINC AX\n";
					  assigntovariable(temp[0],$1->get_arrayindex());
					  codeout<<"\tPOP AX\n";
					  arrayindex=-1;
 
	}
	| variable DECOP {
		     $$=new Symbolinfo("variable DECOP","factor",$1->getDataType());
					     $$->add_child($1);
						 $$->add_child($2);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($2->GetEndLine());
		  
            logfile<<"factor : variable DECOP"<<endl;
			 vector<Symbolinfo*>temp=*($1->getChildList());
					  variable_code(temp[0],$1->get_arrayindex());
					  codeout<<"\tPUSH AX\n";
					  codeout<<"\tDEC AX\n";
					  
					  assigntovariable(temp[0],$1->get_arrayindex());
					  codeout<<"\tPOP AX\n";
					  arrayindex=-1;
	}
	;
	
argument_list : arguments {
	                  $$=new Symbolinfo("arguments","argument_list",$1->getDataType());
					     $$->add_child($1);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
	               ArgumentList=Argument;
                   logfile<<"argument_list	: arguments"<<endl;
              }
			  | { 
				      $$=new Symbolinfo("","argument_list","");
				   ArgumentList=new vector<Symbolinfo*>();
                   logfile<<"argument_list	: "<<endl;
			  }
			  ;
	
arguments : arguments COMMA logic_expression {
	                 $$=new Symbolinfo("arguments COMMA logic_expression","arguments",$1->getDataType());
					     $$->add_child($1);
						 $$->add_child($2);
						 $$->add_child($3);
						
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($3->GetEndLine());
				  Symbolinfo *info=new Symbolinfo($3->getName(),$3->getType(),$3->getDataType());
				  info->SetStartLine($3->GetStartLine());
	              Argument->push_back(info);
                  logfile<<"arguments	: arguments COMMA logic_expression"<<endl;
				  codeout<<"\tPUSH AX\n";
           }
	      | logic_expression {
			       $$=new Symbolinfo("logic_expression","arguments",$1->getDataType());
					     $$->add_child($1);
					
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
			    cout<<"checking2:"<<$1->getDataType()<<endl;
			    Argument=new vector<Symbolinfo*>();
				 Symbolinfo *info=new Symbolinfo($1->getName(),$1->getType(),$1->getDataType());
				 info->SetStartLine($1->GetStartLine());
	              Argument->push_back(info);
				codeout<<"\tPUSH AX\n";
                logfile<<"arguments	: logic_expression"<<endl;
			
		  }
	      ;

%%
int main(int argc,char *argv[])
{
    FILE *fp;
	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	// fp2= fopen(argv[2],"w");
	// fclose(fp2);
	// fp3= fopen(argv[3],"w");
	// fclose(fp3);
	
	// fp2= fopen(argv[2],"a");
	// fp3= fopen(argv[3],"a");
    logfile.open("1905062_log.txt", ios::out);
	errorfile.open("1605062_error.txt", ios::out);
	parsefile.open("1605062_parse.txt",ios::out);
    create_code_files();
	table=new SymbolTable(11);
    yylineno=1;
	yyin=fp;
	

	//code starting
	
	yyparse();
	yylex_destroy();
    

	
	// fclose(fp2);
	// fclose(fp3);
	
	return 0;
}
