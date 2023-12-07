#pragma once
#include<bits/stdc++.h>
#include "1905062.h"
using namespace std;
ofstream codeout;
ofstream dataout;
int labelCount=0;
SymbolTable *table;

//code files
void create_code_files()
{
   codeout.open("temp.asm",ios::out);
   dataout.open("code.asm",ios::out);
}

//optimizing code file
void optimize_code()
{
  ifstream unoptimized("code.asm");
  ofstream optimized("optimized_code.asm");
  vector<string>unop_lines;
  string line;
   while (getline(unoptimized, line))
    {
        unop_lines.push_back(line);
    }
    int i;
    for(i=0;i<unop_lines.size()-1;i++)
    { 
      if(unop_lines[i].size()>9){
        if(unop_lines[i].substr(1,9)=="ADD AX, 0")
               continue;
      }
       if(unop_lines[i].size()>8 &&unop_lines[i+1].size()>7)
      {
        if(unop_lines[i].substr(1,7)=="PUSH AX" && unop_lines[i+1].substr(1,7)=="POP AX")
        {
         
          i++;
          continue;
        }
      }
      if(unop_lines[i].size()>3 && unop_lines[i+1].size()>3)
      {
        if(unop_lines[i].substr(1,3)=="MOV" && unop_lines[i+1].substr(1,3)=="MOV")
        {
             int semi1=unop_lines[i].find("\t;");
             int semi2=unop_lines[i+1].find("\t;");
             string firstline=unop_lines[i].substr(4,semi1-4);
             string secondline=unop_lines[i+1].substr(4,semi2-4);
             int first_comma=firstline.find(",");
             int second_comma=secondline.find(",");
            // optimized<<endl;
            // optimized<<firstline.substr(1,first_comma-1)<<"okay"<<endl;
            // optimized<<secondline.substr(second_comma+2)<<"okay"<<endl;
             // optimized<<firstline.substr(first_comma+2)<<"okay"<<endl;
             //optimized<<secondline.substr(1,second_comma-1)<<"okay"<<endl;
             // optimized<<endl;
             if(firstline.substr(1,first_comma-1)==secondline.substr(second_comma+2)&&firstline.substr(first_comma+2)==secondline.substr(1,second_comma-1)) 
             {
             // optimized<<unop_lines[i]<<unop_lines[i+1];
              optimized<<unop_lines[i]<<";Removing redundant assigment after it"<<endl;
              i++;
              continue;
             }
        }
      }
      optimized<<unop_lines[i]<<endl;
    }
    if(i<unop_lines.size())
    {
        optimized<<unop_lines[i]<<endl;
    }
    unoptimized.close();
    optimized.close();

}



//merging code files

void code_merge()
{
     if (dataout.is_open())
    {
        dataout.close();
    }
    if (codeout.is_open())
    {
        codeout.close();
    }
    ifstream codefile("temp.asm");
    ofstream final("code.asm", std::ios::app);
    string line;
    while (getline(codefile, line))
    {
        final<< line << endl;
    }

   
    codefile.close();
    final.close();
    optimize_code();
}




//printing functions
void print_function()
{
    codeout<<"print_output proc  ;print what is in ax\n"<<
    "\tpush ax\n"<<
    "\tpush bx\n"<<
    "\tpush cx\n"<<
    "\tpush dx\n"<<
    "\tpush si\n"<<
    "\tlea si,number\n"<<
    "\tmov bx,10\n"<<
    "\tadd si,4\n"<<
    "\tcmp ax,0\n"<<
    "\tjnge negate\n"<<
    "\tprint:\n"<<
    "\txor dx,dx\n"<<
    "\tdiv bx\n"<<
    "\tmov [si],dl\n"<<
    "\tadd [si],'0'\n"<<
    "\tdec si\n"<<
    "\tcmp ax,0\n"<<
    "\tjne print\n"<<
    "\tinc si\n"<<
    "\tlea dx,si\n"<<
    "\tmov ah,9\n"<<
    "\tint 21h\n"<<
    "\tpop si\n"<<
    "\tpop dx\n"<<
    "\tpop cx\n"<<
    "\tpop bx\n"<<
    "\tpop ax\n"<<
    "\tret\n"<<
    "\tnegate:\n"<<
    "\tpush ax\n"<<
    "\tmov ah,2\n"<<
    "\tmov dl,'-'\n"<<
    "\tint 21h\n"<<
    "\tpop ax\n"<<
    "\tneg ax\n"<<
    "\tjmp print\n"<<
  "print_output endp\n";
}
void print_newline()
{
      codeout<<"new_line proc\n"<<
    "\tpush ax\n"<<
    "\tpush dx\n"<<
    "\tmov ah,2\n"<<
    "\tmov dl,cr\n"<<
    "\tint 21h\n"<<
    "\tmov ah,2\n"<<
    "\tmov dl,lf\n"<<
    "\tint 21h\n"<<
    "\tpop dx\n"<<
    "\tpop ax\n"<<
    "\tret\n"<<
    "new_line endp\n";
}
//functions
void function_start(Symbolinfo *info)
{    
    codeout<<info->getName()<<" PROC\n";
    if(info->getName()=="main")
    {
      codeout<<"\tMOV AX, @DATA\n";
	  codeout<<"\tMOV DS, AX\n"; 
    }
    codeout<<"\tPUSH BP\n\tMOV BP, SP\n";
}
void function_end(Symbolinfo *info,int varcount,string label)
{   
    Symbolinfo *temp=table->LookUp(info->getName());
    if(label!=""){
    codeout<<label<<":\n";
    }
    if(varcount)
      {
        
        codeout<<"\tADD SP, "<<varcount*2<<"\n";

      }
      codeout<<"\tPOP BP\n";
     
    if(info->getName()=="main"){
    codeout<<"\tMOV AX,4CH\n\tINT 21H\n";
      }
      else
      {
         if((*(temp->getParameterList())).size())
      {
        codeout<<"\tRET "<<(*(temp->getParameterList())).size()*2<<"\n";
      }
      else
      {
        codeout<<"\tRET\n";
      }
      }
      codeout<<temp->getName()<<" ENDP\n";
}


//variables
void variable_declare_code(Symbolinfo *info,string comment)
{
    if(info->getisglobal())
    {    if(info->getisArray())
           {
             dataout<<"\t"<<info->getName()<<" DW "<<info->getarraysize()<<" DUP (0000H)\t;"<<comment<<"\n";
           }else{
        dataout<<"\t"<<info->getName()<<" DW 1 DUP (0000H)\t;"<<comment<<"\n";
           }
    }
    else
    {  
         if(info->getisArray())
         {
           codeout<<"\tSUB SP, "<<stoi(info->getarraysize())*2<<"\t;"<<comment<<"\n";
         }
         else{
        codeout<<"\tSUB SP, 2\t;"<<comment<<"\n";
         }
    }

}
// void variable_declare_assign(Symbolinfo *info)
// {   
//     if(!info->getisglobal())
//     {
//     codeout<<"\tPUSH BP"<<"\n"<<"\tMOV BP, SP\n";
//     }
// }
void variable_code(Symbolinfo *info,int index=-1)
{
    Symbolinfo *symbol=table->LookUp(info->getName());
    if(symbol->getisglobal())
    {   if(symbol->getisArray())
          { codeout<<"\tMOV AX, BX\t;\n";
            codeout<<"MOV BX ,2\n"<<"\tMUL BX\n";
            codeout<<"\tMOV SI, AX;\tASSIGNING INDEX REGISTER TO INDEX OF ARRAY\n";
            codeout<<"\tMOV AX, "<<symbol->getName()<<"[SI]\t; storing global array element "<<symbol->getName()<<" to AX\n";
          }
          else{
        codeout<<"\tMOV AX, "<<symbol->getName()<<"\t; storing global variable "<<symbol->getName()<<" to AX\n";
        //codeout<<"\tPUSH AX\n";
          }
    }
    else
    {  
      if(symbol->get_is_parameter())
      {
       if(symbol->getisArray()){
      codeout<<"\tMOV AX, [BP+"<<symbol->getoffset()+(index*2)<<"]\t; storing local array variable "<<symbol->getName()<<" to AX\n";
        //codeout<<"\tPUSH AX\n";  
    }
    else
    {
        codeout<<"\tMOV AX, [BP+"<<symbol->getoffset()<<"]\t; storing local variable "<<symbol->getName()<<" to AX\n";
        //codeout<<"\tPUSH AX\n";  
    }
      }
      else
      {
           if(symbol->getisArray()){
            codeout<<"\tMOV AX, BX\t;\n";
            codeout<<"\tMOV BX ,2\n\tMUL BX\n\tADD AX, "<<symbol->getoffset()<<"\n\tMOV SI,AX\n\tNEG SI\n";
      codeout<<"\tMOV AX, [BP-SI]\t; storing local array variable "<<symbol->getName()<<" to AX\n";
        //codeout<<"\tPUSH AX\n";  
    }
    else
    {
        codeout<<"\tMOV AX, [BP-"<<symbol->getoffset()<<"]\t; storing local variable "<<symbol->getName()<<" to AX\n";
        //codeout<<"\tPUSH AX\n";  
    }
      }
      
    }
}
void assigntovariable(Symbolinfo *info,int arrayindex=-1)
{
     Symbolinfo *symbol=table->LookUp(info->getName());
    if(symbol->getisglobal())
    {   if(symbol->getisArray())
            {
              codeout<<"\tPUSH AX\n";
              codeout<<"\tMOV AX, BX\t;\n";
             codeout<<"MOV BX ,2\n"<<"\tMUL BX\n";
             codeout<<"\tMOV SI, AX;\tASSIGNING INDEX REGISTER TO INDEX OF ARRAY\n";
              codeout<<"\tPOP AX\n";
              codeout<<"\tMOV "<<symbol->getName()<<"[SI], AX\t;assigning to global variable "<<symbol->getName()<<"\n";
            }
            else{
       codeout<<"\tMOV "<<symbol->getName()<<", AX\t;assigning to global variable "<<symbol->getName()<<"\n";
            }
     }
    else
    {  
      if(symbol->get_is_parameter())
      {
           if(symbol->getisArray()){
                   
		codeout<<"\tMOV "<<"[BP+"<<((symbol->getoffset()+(arrayindex*2)))<<"]"<<", AX\t;assigning to local variable "<<symbol->getName()<<"\n";
         
    }
    else
    {
        
		codeout<<"\tMOV "<<"[BP+"<<(symbol->getoffset())<<"]"<<", AX\t;assigning to local variable "<<symbol->getName()<<"\n";
    }
      }
      else{
      if(symbol->getisArray()){
        codeout<<"\tPUSH AX\n";
         codeout<<"\tMOV AX, BX\t;\n";
          codeout<<"\tMOV BX ,2\n\tMUL BX\n\tADD AX, "<<symbol->getoffset()<<"\n\tMOV SI,AX\n\tNEG SI\n";
          codeout<<"\tPOP AX\n";
		     codeout<<"\tMOV "<<"[BP-SI]"<<", AX\t;assigning to local variable "<<symbol->getName()<<"\n";
         
    }
    else
    {
        
		codeout<<"\tMOV "<<"[BP-"<<(symbol->getoffset())<<"]"<<", AX\t;assigning to local variable "<<symbol->getName()<<"\n";
    }
      }
    } 
			  
}

void MULOP_code(Symbolinfo *info)
{    codeout<<"\tPOP BX\n";
     codeout<<"\tPOP AX\n";
     codeout<<"\tCWD\n";
    if(info->getName()=="*")
    {
        codeout<<"\tMUL BX\n";
        // codeout<<"\tPUSH AX\n";
    }
    if(info->getName()=="/")
    {
         codeout<<"\tDIV BX\n";
        //codeout<<"\tPUSH AX\n";
    }
    if(info->getName()=="%")
    {
         codeout<<"\tDIV BX\n";
         codeout<<"\tMOV AX, DX\n";
        //codeout<<"\tPUSH DX\n";
    }

}
void ADDOP_code(Symbolinfo *info)
{
    codeout<<"\tPOP BX\n";
     codeout<<"\tPOP AX\n";
    
    if(info->getName()=="+")
    {
        codeout<<"\tADD AX, BX\n";
         //codeout<<"\tPUSH AX\n";
    }
    if(info->getName()=="-")
    {
         codeout<<"\tSUB AX, BX\n";
        //codeout<<"\tPUSH AX\n";
    }
  
}
string get_relop(Symbolinfo *info)
{
    if(info->getName()=="<=")
    {
        return "JLE";
    }
    else if(info->getName()==">=")
    {
        return "JGE";
    }
      else if(info->getName()==">")
    {
        return "JG";
    }
      else if(info->getName()=="<")
    {
        return "JL";
    }
      else if(info->getName()=="==")
    {
        return "JE";
    }
       else if(info->getName()=="!=")
    {
        return "JNE";
    }
       
}