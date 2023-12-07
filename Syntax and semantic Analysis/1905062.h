#pragma once
#include<bits/stdc++.h>
using namespace std;
class Symbolinfo
{
private:
    string name;
    string type;
    string datatype;
    bool isFunction;
    bool isArray;
    int pos;
    string arraysize;
    vector<Symbolinfo*>*ParameterList;
    vector<Symbolinfo*>*ChildList;
    bool isFunctionDefination;
    bool isFunctionDeclaration;
    bool iszero;
    int start_Line;
    int end_Line;
    bool isLeaf;
public:
    Symbolinfo *next;
    
    Symbolinfo()
{
    //nothing
    isArray=false;
    arraysize=-1;
    isFunction=false;
    ParameterList=new vector<Symbolinfo*>();
    ChildList=new vector<Symbolinfo*>();
    isFunctionDefination=false;
    isFunctionDeclaration=false;
    iszero=false;
    datatype="";
    start_Line=-1;
    end_Line=-1;
    isLeaf=false;
}
Symbolinfo(string name,string type)
{
    this->name=name;
    this->type=type;
    isArray=false;
    arraysize=-1;
    isFunction=false;
    ParameterList=new vector<Symbolinfo*>();
    ChildList=new vector<Symbolinfo*>();
    isFunctionDefination=false;
    isFunctionDeclaration=false;
    iszero=false;
    datatype="";
    start_Line=-1;
    end_Line=-1;
    isLeaf=false;
}
Symbolinfo(string name,string type,string datatype)
{
   this->name=name;
   this->type=type;
   this->datatype=datatype;
   isArray=false;
   arraysize=-1;
   isFunction=false;
   ParameterList=new vector<Symbolinfo*>();
   ChildList=new vector<Symbolinfo*>();
   isFunctionDefination=false;
   isFunctionDeclaration=false;
   iszero=false;
   start_Line=-1;
   end_Line=-1;
   isLeaf=false;
}   
    void setisFunctionDeclaration(bool isdeclaration)
    {
        this->isFunctionDeclaration=isdeclaration;
    }
    void setisFunctionDefination(bool isdefination)
    {
      this->isFunctionDefination=isdefination;
    }
    bool getisFunctionDeclaration()
    {
        return isFunctionDeclaration;
    }
    bool getisFunctionDefination()
    {
        return isFunctionDefination;
    }
    void setarraysize(string n)
    {
        this->arraysize=n;
    }
    string getarraysize()
    {
        return (this->arraysize);
    }
    void setDataType(string datatype)
    {
        this->datatype=datatype;
    }
    string getDataType()
    {
        return this->datatype;
    }
    void setisFunction(bool f)
    {
        isFunction=f;
    }
    bool getisFunction()
    {
        return isFunction;
    }
    void setisArray(bool a)
    {
        isArray=a;
    }
    bool getisArray()
    {
        return isArray;
    }
    void setName(string n)
    {
        name=n;
    }
    void setType(string t)
    {
        type=t;
    }
    void setposition(int pos)
    {
        this->pos=pos;
    }
    int getposition()
    {
        return pos;
    }
    string getName()
    {
        return name;
    }
    string getType()
    {
        return type;
    }
    void setNext(Symbolinfo* next)
    {
        this->next=next;
    }
    Symbolinfo *getNext()
    {
        return next;
    }
    void add_parameter(Symbolinfo *param)
    {  cout<<"testingin:"<<param->getDataType()<<" ";
        ParameterList->push_back(param);
    }
    vector<Symbolinfo*>* getParameterList()
    {
        return ParameterList;
    }
    void add_child(Symbolinfo* temp)
    {   
       
        ChildList->push_back(temp);
      

        cout<<"adding:"<<temp->getName()<<" "<<temp->getisLeaf()<<endl;
    }
    vector<Symbolinfo*>* getChildList()
    {
        return ChildList;
    }
   void setisZero(bool zero)
   {
    iszero=zero;
   }
   bool getiszero()
   {
    return iszero;
   }
   void SetStartLine(int line)
   {
     start_Line=line;
   }
   void SetEndLine(int line)
   {
    end_Line=line;
   }
   int GetStartLine()
   {
    return start_Line;
   }
   int GetEndLine()
   {
    return end_Line;
   }
   void setisLeaf(bool leaf)
   {
      this->isLeaf=leaf;
   }
   bool getisLeaf()
   {
    return isLeaf;
   }
};

class ScopeTable
{
private:

    Symbolinfo **bucketlist;
    ScopeTable *parent_scope;
    int  num_buckets ;
    int Scope_no;

public:
    ScopeTable(int num_buckets,int Scope_no)
{   //cout<<"\tScopeTable# "<<Scope_no<<" created"<<endl;
    this->num_buckets=num_buckets;
    this->Scope_no=Scope_no;
    bucketlist=new Symbolinfo*[num_buckets];
    for(int i=0; i<num_buckets; i++)
    {
        bucketlist[i]=NULL;
    }
    parent_scope=NULL;
}
~ScopeTable()
{
    for(int i=0; i<num_buckets; i++)
    {
        delete bucketlist[i];
    }
    delete []bucketlist;

}


unsigned long long sdbm_hash(string str)
{
    unsigned long long hash = 0;
    unsigned int i = 0;
    unsigned long long len = str.length();

    for (i = 0; i < len; i++)
    {
        hash = ((str[i])+ (hash << 6) + (hash << 16)- hash);
    }

    return hash;
}



    // unsigned long long sdbm_hash(string str);
    // ScopeTable(int  num_buckets,int Scope_no,FILE *);
    int get_num_buckets()
    {
        return num_buckets;
    }
    int get_Scope_no()
    {
        return Scope_no;
    }
    void set_parentscope(ScopeTable *parent_scope)
    {
        this->parent_scope=parent_scope;
    }
    ScopeTable * get_parentscope()
    {
        return parent_scope;
    }
    // ~ScopeTable();



    //Methods
    bool Insert (string name,string type)
    {
        ////cout<<"in"<<endl;
        if(LookUp(name)==NULL)
        {
            ////cout<<"YES"<<endl;
            long long index=(sdbm_hash(name))%num_buckets;
            Symbolinfo* obj=new Symbolinfo();
            obj->setName(name);
            obj->setType(type);
            obj->setNext(NULL);
            Symbolinfo *start=bucketlist[index];
            Symbolinfo *prev=NULL;
            int pos=1;
            while(start!=NULL)
            {
                prev=start;
                start=start->getNext();
                pos++;
            }

            if(prev==NULL)
            {
                bucketlist[index]=obj;//not sure

            }
            else
            {
                prev->setNext(obj);
            }
            obj->setposition(pos);

            ////cout<<"\tInserted in ScopeTable# "<<Scope_no<<" at position "<<index+1<<", "<<pos<<endl;

            return true;
        }
        else
        {   //cout<<"\t'"<<name<<"' already exists in the current ScopeTable"<<endl;
            
             //fprintf(logout,"\t%s already exisits in the current ScopeTable\n",name.c_str());
            return false;
        }
    }
    Symbolinfo* LookUp(string name)
    {
        long long index=(sdbm_hash(name))%num_buckets;
        ////cout<<index<<endl;
        Symbolinfo * start=bucketlist[index];

        while(start!=NULL)
        {
            ////cout<<"sesh"<<endl;
            ////cout<<start->getName()<<endl;
            ////cout<<name<<endl;
            if(start->getName()==name)
            {
                ////cout<<"OK"<<endl;
                return start;
            }
            start=start->getNext();
        }
        ////cout<<"NOT"<<endl;
        return NULL;

    }
    bool Delete(string name)
    {
        if(LookUp(name)==NULL)
        {   //cout<<"\tNot found in the current ScopeTable"<<endl;
            return false;
        }
        else
        {
            ////cout<<"IN delete"<<endl;
            long long index=(sdbm_hash(name))%num_buckets;
            Symbolinfo *start=bucketlist[index];
            Symbolinfo *prev=NULL;
            while(start!=NULL)
            {
                if(start->getName()==name)
                {
                    ////cout<<"delete OK"<<endl;
                    if(prev==NULL)
                    {
                        bucketlist[index]=start->getNext();
                    }
                    else
                        prev->setNext(start->getNext());
                    ////cout<<"delete OK2"<<endl;
                    break;
                }
                prev=start;
                start=start->getNext();
            }
            ////cout<<"delete OK3"<<endl;
            //cout<<"\tDeleted '"<<name<<"' from ScopeTable# "<<Scope_no<<" at position "<<index+1<<", "<<start->getposition()<<endl;

            return true;
        }
    }
    void print(ofstream& logout)
    {   //cout<<"\tScopeTable# "<<Scope_no<<endl;
        logout<<"\tScopeTable# "<<Scope_no<<endl;
        for(int i=0; i<num_buckets; i++)
        {
            Symbolinfo *traverse=bucketlist[i];
            //cout<<"\t"<<i+1<<"--> ";
            bool is=false;
            if(traverse!=NULL){
                is=true;
            logout<<"\t"<<i+1<<"--> ";
            }
            while(traverse!=NULL)
            {
                //cout<<"<"<<traverse->getName()<<","<<traverse->getType()<<">"<<" ";
                if(traverse->getisArray()){
                logout<<"<"<<traverse->getName()<<", ARRAY, "<<traverse->getDataType()<<"> ";
                }
                else if(traverse->getisFunction()){
                logout<<"<"<<traverse->getName()<<", FUNCTION, "<<traverse->getDataType()<<"> ";
                }
                else {
                 logout<<"<"<<traverse->getName()<<", "<<traverse->getDataType()<<"> ";
                }
                traverse=traverse->getNext();
            }
            if(is){
            logout<<endl;
            }
        }
    }
};






class SymbolTable
{
private:
    ScopeTable *current_scope;
    ScopeTable *root;
    int nums_bucket;
    int total_scope;
public:
    // SymbolTable(int,FILE *);
    // ~SymbolTable();
    // void Enter_Scope();
    // void Exit_Scope();
    // bool Insert(string,string);
    // bool Remove(string);
    // Symbolinfo * LookUp(string);
    // void printCurrent();
    // void printAll();






    SymbolTable(int num)
{
    //ScopeTable obj(num,1);
    total_scope=1;
    current_scope=new ScopeTable(num,1);
    root=current_scope;
    nums_bucket=num;
}
~SymbolTable()
{
    while(current_scope!=root)
    {
       Exit_Scope();
    }
    //cout<<"\tScopeTable# "<<current_scope->get_Scope_no()<<" removed"<<endl;
    ScopeTable *temp1=current_scope;
    ScopeTable *temp2=root;
    current_scope=NULL;
    root=NULL;

  
    delete temp1;

}
void Enter_Scope()
{

    ScopeTable *prev=current_scope;
    total_scope++;
    ScopeTable* obj=new ScopeTable(nums_bucket,total_scope);
    current_scope=obj;
    current_scope->set_parentscope(prev);

}
void Exit_Scope()
{
    if(current_scope!=root)
    {
        ScopeTable *temp=current_scope;
        //cout<<"\tScopeTable# "<<current_scope->get_Scope_no()<<" removed"<<endl;
        current_scope=current_scope->get_parentscope();

        delete temp;
    }
    else
    {
        //cout<<"\tScopeTable# 1 cannot be removed"<<endl;
    }
}
bool Insert(string name, string type)
{
    bool result=current_scope->Insert(name,type);
    return result;
}
bool Remove(string name)
{
    bool result=current_scope->Delete(name);
    return result;
}
Symbolinfo * LookUp(string name)
{
    ScopeTable *traverse=current_scope;
    Symbolinfo* result=NULL;
    while(traverse!=NULL)
    {
        result=traverse->LookUp(name);
        if(result!=NULL)
        {
            break;
        }
        traverse=traverse->get_parentscope();

    }
    if(result==NULL)
    {
       //cout<<"\t'"<<name<<"' not found in any of the ScopeTables"<<endl;
    }
    else
    {   long long index=(traverse->sdbm_hash(name))%nums_bucket;
        //cout<<"\t'"<<name<<"' found in ScopeTable# "<<traverse->get_Scope_no()<<" at position "<<index+1<<", "<<result->getposition()<<endl;

    }
    //delete traverse;
    return result;
}

void printCurrent(ofstream& logfile)
{
    current_scope->print(logfile);
}

void printAll(ofstream& logfile)
{
    ScopeTable *traverse=current_scope;

    while(traverse!=NULL)
    {
        traverse->print(logfile);
        traverse=traverse->get_parentscope();

    }
}


};