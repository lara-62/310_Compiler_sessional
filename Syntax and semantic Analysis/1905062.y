%{
#include<bits/stdc++.h>
#include "1905062.h"


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
SymbolTable *table;
string function_return="";
int returnLine=-1;
int yylex_destroy(void);
//parameters for including them in the scope
vector<Symbolinfo*>*function_parameter;
vector<Symbolinfo*>*variable_declaration;
vector<Symbolinfo*>*ArgumentList;
vector<Symbolinfo*>*Argument;

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
    {
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
%type <symbolinfo> start variable factor term unary_expression simple_expression rel_expression logic_expression expression expression_statement statement statements compound_statement type_specifier var_declaration func_declaration func_definition unit program declaration_list argument_list arguments parameter_list


%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start : program
	{     logfile<<"start : program"<<endl;
		  $$=new Symbolinfo("program","start");
          $$->add_child($1);
		  $$->SetStartLine($1->GetStartLine());
		  $$->SetEndLine($1->GetEndLine());
		  DFS($$,"");
          logfile<<"Total Lines: "<<line_count<<endl;
	      logfile<<"Total Errors: "<<error_count<<endl;
		  delete table;
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
				 info->SetEndLine($2->GetEndLine());define_function($1->getDataType(),info,function_parameter);}compound_statement {
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
                }
		        | type_specifier ID LPAREN RPAREN {Symbolinfo *info=new Symbolinfo($2->getName(),$2->getType()); info->SetStartLine($2->GetStartLine());
				 info->SetEndLine($2->GetEndLine());define_function($1->getDataType(),info,new vector<Symbolinfo*>());}compound_statement {
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
					   table->printAll(logfile);
					   table->Exit_Scope();
					   
                  }
 		    | LCURL{ table->Enter_Scope();add_parameter_toScopeTable(function_parameter);clear_list(function_parameter);} RCURL {
				        $$=new Symbolinfo("LCURL RCURL","compound_statement");
					    $$->add_child($1);
						$$->add_child($3);
						
					    $$->SetStartLine($1->GetStartLine());
			           $$->SetEndLine($3->GetEndLine());
					  table->printAll(logfile);
				      table->Exit_Scope();
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
	               variable_declaration->push_back(child);
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
				variable_declaration->push_back(child);
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
				variable_declaration->push_back(child);
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
        }
	   | statements statement {
		      $$=new Symbolinfo("statements statement","statements");
			$$->add_child($1);
            $$->add_child($2);
			$$->SetStartLine($1->GetStartLine());
			$$->SetEndLine($2->GetEndLine());
              logfile<<"statements : statements statement"<<endl;
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
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement {
		      $$=new Symbolinfo("FOR LPAREN expression_statement expression_statement expression RPAREN statement","statement");
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			  $$->add_child($4);
			  $$->add_child($5);
			  $$->add_child($6);
			  $$->add_child($7);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($7->GetEndLine());
             logfile<<"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement"<<endl;
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE{
		      $$=new Symbolinfo("IF LPAREN expression RPAREN statement","statement");
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			  $$->add_child($4);
			  $$->add_child($5);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($5->GetEndLine());
             logfile<<"statement : IF LPAREN expression RPAREN statement"<<endl;
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement {
		      $$=new Symbolinfo("IF LPAREN expression RPAREN statement ELSE statement","statement");
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			  $$->add_child($4);
			  $$->add_child($5);
			  $$->add_child($6);
			  $$->add_child($7);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($7->GetEndLine());
             logfile<<"statement : IF LPAREN expression RPAREN statement ELSE statement"<<endl;
	  }
	  | WHILE LPAREN expression RPAREN statement {
		     $$=new Symbolinfo("WHILE LPAREN expression RPAREN statement","statement");
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			  $$->add_child($4);
			  $$->add_child($5);
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($5->GetEndLine());
             logfile<<"statement : WHILE LPAREN expression RPAREN statement"<<endl;
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
	  }
	  ;
	  
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
			  
              logfile<<"expression : variable ASSIGNOP logic_expression"<<endl;
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
        }
		 | rel_expression LOGICOP rel_expression {
			        
			  $$=new Symbolinfo("rel_expression LOGICOP rel_expression","logic_expression","INT");
			  $$->add_child($1);
			  $$->add_child($2);
			  $$->add_child($3);
			 
			  $$->SetStartLine($1->GetStartLine());
			  $$->SetEndLine($3->GetEndLine());
			     if($3->getDataType()=="VOID"||$1->getDataType()=="VOID")
			  {
				errorfile<<"Line# "<<line_count<<": Void cannot be used in expression"<<endl;
				error_count++;
			  }
                 logfile<<"logic_expression	: rel_expression LOGICOP rel_expression "<<endl;
				
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
        }
		| simple_expression RELOP simple_expression	{
			    $$=new Symbolinfo("simple_expression RELOP simple_expression","rel_expression","INT");
				$$->add_child($1);
			    $$->add_child($2);
			    $$->add_child($3);
			    $$->SetStartLine($1->GetStartLine());
			    $$->SetEndLine($3->GetEndLine());
			
            logfile<<"rel_expression : simple_expression RELOP simple_expression"<<endl;
			   if($3->getDataType()=="VOID"||$1->getDataType()=="VOID")
			  {
				errorfile<<"Line# "<<line_count<<": Void cannot be used in expression "<<endl;
				error_count++;
			  }
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
        }
		  | simple_expression ADDOP term {
			             if($1->getDataType()=="FLOAT"||$3->getDataType()=="FLOAT")
							{
								 $$=new Symbolinfo("simple_expression ADDOP term","simple_expression","FLOAT");
							}
							else{
			              $$=new Symbolinfo("simple_expression ADDOP term","simple_expression",$1->getDataType());
							}
						$$->add_child($1);
						$$->add_child($2);
						$$->add_child($3);

						$$->SetStartLine($1->GetStartLine());
						$$->SetEndLine($3->GetEndLine());
			
			          
						 if ($1->getName()==$3->getName() && $2->getName()=="-")
						 {
							$$->setisZero(true);
						 }
						 if($3->getiszero() && $1->getiszero())
						 {
							$$->setisZero(true);
						 }
						    if($3->getDataType()=="VOID"||$1->getDataType()=="VOID")
			             {
				      errorfile<<"Line# "<<line_count<<": Void cannot be used in expression "<<endl;
					  error_count++;
			             }
                    logfile<<"simple_expression : simple_expression ADDOP term"<<endl;
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
        }
     |  term MULOP unary_expression {
		                 cout<<"unary_expression:"<<$3->getiszero()<<endl;
						    if(($1->getDataType()=="FLOAT"||$3->getDataType()=="FLOAT")&& $2->getName()!="%")
							{
								 $$=new Symbolinfo("term MULOP unary_expression","term","FLOAT");
							}else{
		                    $$=new Symbolinfo("term MULOP unary_expression","term",$1->getDataType());
							}
					 $$->add_child($1);
			         $$->add_child($2);
			          $$->add_child($3);
			  
			         $$->SetStartLine($1->GetStartLine());
			        $$->SetEndLine($3->GetEndLine());
						 if(($2->getName()=="%" || $2->getName()=="/")&&($3->getiszero()))
						 {
							errorfile<<"Line# "<<line_count<<": Warning: division by zero i=0f=1Const=0"<<endl;
							error_count++;
						 }
						 if($2->getName()=="%" && ($3->getDataType()!="INT"||$1->getDataType()!="INT")){
							errorfile<<"Line# "<<line_count<<": Operands of modulus must be integers "<<endl;
							error_count++;
						 }
						 if(($2->getName()=="*")&&($3->getiszero()||$1->getiszero()))
						 {
							$$->setisZero(true);
						 }
						    if($3->getDataType()=="VOID"||$1->getDataType()=="VOID")
			             {
				           errorfile<<"Line# "<<line_count<<": Void cannot be used in expression "<<endl;
				           error_count++;
			             }
                         logfile<<"term : term MULOP unary_expression"<<endl;
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
			          
                      logfile<<"unary_expression : factor"<<endl;
		 }
		 ;
	
factor	: variable {  
	                    
					  $$=new Symbolinfo("variable","factor",$1->getDataType());
					     $$->add_child($1);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
					  cout<<"checking:"<<$1->getDataType()<<endl;
                      logfile<<"factor : variable"<<endl;
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
		        
				if($1->getName()=="0")
				{
					$$->setisZero(true);
				}
                logfile<<"factor : CONST_INT"<<endl;
	}
	| CONST_FLOAT {
		         $1->setDataType("FLOAT");
		       $$=new Symbolinfo("CONST_FLOAT","factor",$1->getDataType());
					     $$->add_child($1);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($1->GetEndLine());
		      
               logfile<<"factor : CONST_FLOAT"<<endl;
	}
	| variable INCOP {
		       $$=new Symbolinfo("variable INCOP","factor",$1->getDataType());
					     $$->add_child($1);
						 $$->add_child($2);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($2->GetEndLine());
             logfile<<"factor : variable INCOP"<<endl;
	}
	| variable DECOP {
		     $$=new Symbolinfo("variable DECOP","factor",$1->getDataType());
					     $$->add_child($1);
						 $$->add_child($2);
			             $$->SetStartLine($1->GetStartLine());
			             $$->SetEndLine($2->GetEndLine());
		  
            logfile<<"factor : variable DECOP"<<endl;
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
    logout=fopen("1905062_log.txt","a");
	table=new SymbolTable(11);
    yylineno=1;
	yyin=fp;
	
	yyparse();
	yylex_destroy();

	// fclose(fp2);
	// fclose(fp3);
	
	return 0;
}
