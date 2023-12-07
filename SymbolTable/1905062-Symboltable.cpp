#include<bits/stdc++.h>
using namespace std;
class Symbolinfo
{
private:
    string name;
    string type;
    int pos;
public:
    Symbolinfo *next;
    Symbolinfo();
    Symbolinfo(string name,string type);


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

};
Symbolinfo::Symbolinfo()
{
    //nothing
}
Symbolinfo::Symbolinfo(string name,string type)
{
    this->name=name;
    this->type=type;

}
class ScopeTable
{
private:

    Symbolinfo **bucketlist;
    ScopeTable *parent_scope;
    int  num_buckets ;
    int Scope_no;

public:
    unsigned long long sdbm_hash(string str);
    ScopeTable(int  num_buckets,int Scope_no);
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
    ~ScopeTable();

    //Methods
    bool Insert (string name,string type)
    {
        //cout<<"in"<<endl;
        if(LookUp(name)==NULL)
        {
            //cout<<"YES"<<endl;
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

            cout<<"\tInserted in ScopeTable# "<<Scope_no<<" at position "<<index+1<<", "<<pos<<endl;
            return true;
        }
        else
        {   cout<<"\t'"<<name<<"' already exists in the current ScopeTable"<<endl;
            return false;
        }
    }
    Symbolinfo* LookUp(string name)
    {
        long long index=(sdbm_hash(name))%num_buckets;
        //cout<<index<<endl;
        Symbolinfo * start=bucketlist[index];

        while(start!=NULL)
        {
            //cout<<"sesh"<<endl;
            //cout<<start->getName()<<endl;
            //cout<<name<<endl;
            if(start->getName()==name)
            {
                //cout<<"OK"<<endl;
                return start;
            }
            start=start->getNext();
        }
        //cout<<"NOT"<<endl;
        return NULL;

    }
    bool Delete(string name)
    {
        if(LookUp(name)==NULL)
        {   cout<<"\tNot found in the current ScopeTable"<<endl;
            return false;
        }
        else
        {
            //cout<<"IN delete"<<endl;
            long long index=(sdbm_hash(name))%num_buckets;
            Symbolinfo *start=bucketlist[index];
            Symbolinfo *prev=NULL;
            while(start!=NULL)
            {
                if(start->getName()==name)
                {
                    //cout<<"delete OK"<<endl;
                    if(prev==NULL)
                    {
                        bucketlist[index]=start->getNext();
                    }
                    else
                        prev->setNext(start->getNext());
                    //cout<<"delete OK2"<<endl;
                    break;
                }
                prev=start;
                start=start->getNext();
            }
            //cout<<"delete OK3"<<endl;
            cout<<"\tDeleted '"<<name<<"' from ScopeTable# "<<Scope_no<<" at position "<<index+1<<", "<<start->getposition()<<endl;

            return true;
        }
    }
    void print()
    {   cout<<"\tScopeTable# "<<Scope_no<<endl;
        for(int i=0; i<num_buckets; i++)
        {
            Symbolinfo *traverse=bucketlist[i];
            cout<<"\t"<<i+1<<"--> ";
            while(traverse!=NULL)
            {
                cout<<"<"<<traverse->getName()<<","<<traverse->getType()<<">"<<" ";
                traverse=traverse->getNext();
            }
            cout<<endl;
        }
    }
};

ScopeTable::ScopeTable(int num_buckets,int Scope_no)
{   cout<<"\tScopeTable# "<<Scope_no<<" created"<<endl;
    this->num_buckets=num_buckets;
    this->Scope_no=Scope_no;
    bucketlist=new Symbolinfo*[num_buckets];
    for(int i=0; i<num_buckets; i++)
    {
        bucketlist[i]=NULL;
    }
    parent_scope=NULL;
}
ScopeTable::~ScopeTable()
{
    for(int i=0; i<num_buckets; i++)
    {
        delete bucketlist[i];
    }
    delete []bucketlist;

}


unsigned long long ScopeTable::sdbm_hash(string str)
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




class SymbolTable
{
private:
    ScopeTable *current_scope;
    ScopeTable *root;
    int nums_bucket;
    int total_scope;
public:
    SymbolTable(int);
    ~SymbolTable();
    void Enter_Scope();
    void Exit_Scope();
    bool Insert(string,string);
    bool Remove(string);
    Symbolinfo * LookUp(string);
    void printCurrent();
    void printAll();


};
SymbolTable::SymbolTable(int num)
{
    //ScopeTable obj(num,1);
    total_scope=1;
    current_scope=new ScopeTable(num,1);
    root=current_scope;
    nums_bucket=num;
}
SymbolTable::~SymbolTable()
{
    while(current_scope!=root)
    {
       Exit_Scope();
    }
    cout<<"\tScopeTable# "<<current_scope->get_Scope_no()<<" removed"<<endl;
    ScopeTable *temp1=current_scope;
    ScopeTable *temp2=root;
    current_scope=NULL;
    root=NULL;

    delete temp2;
    delete temp1;

}
void SymbolTable::Enter_Scope()
{

    ScopeTable *prev=current_scope;
    total_scope++;
    ScopeTable* obj=new ScopeTable(nums_bucket,total_scope);
    current_scope=obj;
    current_scope->set_parentscope(prev);

}
void SymbolTable::Exit_Scope()
{
    if(current_scope!=root)
    {
        ScopeTable *temp=current_scope;
        cout<<"\tScopeTable# "<<current_scope->get_Scope_no()<<" removed"<<endl;
        current_scope=current_scope->get_parentscope();

        delete temp;
    }
    else
    {
        cout<<"\tScopeTable# 1 cannot be removed"<<endl;
    }
}
bool SymbolTable::Insert(string name, string type)
{
    bool result=current_scope->Insert(name,type);
    return result;
}
bool SymbolTable::Remove(string name)
{
    bool result=current_scope->Delete(name);
    return result;
}
Symbolinfo * SymbolTable::LookUp(string name)
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
       cout<<"\t'"<<name<<"' not found in any of the ScopeTables"<<endl;
    }
    else
    {   long long index=(traverse->sdbm_hash(name))%nums_bucket;
        cout<<"\t'"<<name<<"' found in ScopeTable# "<<traverse->get_Scope_no()<<" at position "<<index+1<<", "<<result->getposition()<<endl;

    }
    //delete traverse;
    return result;
}

void SymbolTable::printCurrent()
{
    current_scope->print();
}

void SymbolTable::printAll()
{
    ScopeTable *traverse=current_scope;

    while(traverse!=NULL)
    {
        traverse->print();
        traverse=traverse->get_parentscope();

    }
}

int main()
{

    FILE *fp=freopen("in069.txt","r",stdin);
    freopen("sample_output.txt","w",stdout);
    int bucket_size;
    cin>>bucket_size;
    SymbolTable* table= new SymbolTable(bucket_size);
    string store;
    char select;
    string name,type;
    string line;
    char nothing;
    int command=1;
    cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    while(true)
    {   vector<string>token;
        getline(cin,line);
        stringstream str(line);
        while(getline(str,store,' '))
        {
            token.push_back(store);

        }
        select=token[0][0];

        cout<<"Cmd "<<command<<": "<<line<<endl;
        command++;
        switch(select)
        {

        case 'I':
            if(token.size()==3)
            {
                name=token[1];
                type=token[2];
                table->Insert(name,type);
            }
            else
            {
              cout<<"\tNumber of parameters mismatch for the command "<<select<<endl;
            }
            break;
        case 'L':
            if(token.size()==2)
            {
                name=token[1];
                table->LookUp(name);
            }
            else
            {
              cout<<"\tNumber of parameters mismatch for the command "<<select<<endl;
            }

            break;
        case 'D':
            if(token.size()==2)
            {
                name=token[1];
                table->Remove(name);
            }
            else
            {
                cout<<"\tNumber of parameters mismatch for the command "<<select<<endl;
            }
            break;

        case 'P':
           char print;
           print=token[1][0];
            if(token.size()==2)
            {
                if(print=='A')
                {
                   table->printAll();
                }
                else
                {
                    table->printCurrent();
                }
            }
            else
            {
                cout<<"\tNumber of parameters mismatch for the command "<<select<<endl;
            }
            break;
        case 'S':
            if(token.size()==1)
            {
                table->Enter_Scope();
            }
            else
            {
                cout<<"\tNumber of parameters mismatch for the command "<<select<<endl;
            }
            break;
        case 'E':
            if(token.size()==1)
            {
                table->Exit_Scope();
            }
            else
            {
                cout<<"\tNumber of parameters mismatch for the command "<<select<<endl;
            }
            break;
        case 'Q':
            if(token.size()==1)
            {   delete table;

            }
            else
            {
                cout<<"\tNumber of parameters mismatch for the command "<<select<<endl;
            }
            break;

        }
        if(select=='Q')
        {
            break;
        }


    }
    fclose(fp);

}
