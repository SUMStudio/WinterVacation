#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "lex.h"
#include "lex.c"
#include "symbol.h"
#include "parser.h"
#include "code.h"

void Lcommad()
{
     char ch;
     
     while((ch = nextch()) != ')');
}

void Acommad(int v)
{
     int i,mod,value;
     char ch,str[50];
     struct var_addr tem;
     struct sybtable *p,*newnode;
     int sw;
     
     for(i = 0;i < 17;i ++)
          instr[i] = '0';
     instr[0] = '0';
     instr[16] = '\0';
     
     ch = nextch();
     
     if(isalpha(ch))
     {
          getvar(ch,tem.str);
          if(!search(tem.str,&p))
                value = p->node.addr;
          else
          {
                tem.addr = value = date_addr;
                date_addr ++;
                p -> next = malloc(sizeof(struct sybtable));
                p = p -> next;
                p -> next = NULL;
                p -> node = tem;
          }
     }
     else
          value = getnum(ch);
     
     for(i = 15;i > 0;i --)
     {
           mod = value % 2;
           value = value / 2;
           instr[i] = mod + '0';
     }
     
     printf("%s\n",instr);
}

void compyield(int ch)
{
     char prech;
     switch(ch)
     {
           case '0':
                instr[4] = '1';instr[6] = '1';instr[8] = '1';
                break;
           case '1':
                instr[4] = '1';instr[5] = '1';instr[6] = '1';
                instr[7] = '1';instr[8] = '1';instr[9] = '1';
                break;
           case '-':
                ch = nextch();
                switch(ch)
                {
                     case '1':
                          instr[4] = '1';instr[5] = '1';instr[6] = '1';
                          instr[8] = '1';
                          break;
                     case 'D':
                          instr[6] = '1';instr[7] = '1';instr[8] = '1';
                          instr[9] = '1';
                          break;
                     case 'A':
                     case 'M':
                          instr[4] = '1';instr[8] = '1';instr[8] = '1';
                          instr[9] = '1';
                          if(ch == 'M')
                               instr[3] = '1';
                          break;
                }
                break;
           case '!':
                ch = nextch();
                switch(ch)
                {
                     case 'D':
                          instr[6] = '1';instr[7] = '1';instr[9] = '1';
                          break;
                     case 'A':
                     case 'M':
                          instr[4] = '1';instr[5] = '1';instr[9] = '1';
                          if(ch == 'M')
                               instr[3] = '1';                     
                          break;
                }
                break;
           case 'D':
                ch = nextch();
                switch(ch)
                {
                     case '+':
                          ch = nextch();
                          switch(ch)
                          {
                               case '1':
                                    instr[5] = '1';instr[6] = '1';instr[7] = '1';
                                    instr[8] = '1';instr[9] = '1';
                                    break;
                               case 'A':
                               case 'M':
                                    instr[8] = '1';
                                    if(ch == 'M')
                                          instr[3] = '1';
                                    break;
                          }
                          break;
                     case '-':
                          ch = nextch();
                          switch(ch)
                          {
                               case '1':
                                    instr[6] = '1';instr[7] = '1';instr[8] = '1';
                                    break;
                               case 'A':
                               case 'M':
                                    instr[5] = '1';instr[8] = '1';instr[9] = '1';
                                    if(ch == 'M')
                                         instr[3] = '1';
                                    break;
                          }                         
                          break;
                     case '&':
                          ch = nextch();
                          switch(ch)
                          {
                               case 'A':
                               case 'M':
                                    if(ch == 'M')
                                         instr[3] = '1';
                                    break;
                          }
                          break;
                     case '|':
                          ch = nextch();
                          switch(ch)
                          {
                               case 'A':
                               case 'M':
                                    instr[5] = '1';instr[7] = '1';instr[9] = '1';
                                    if(ch == 'M')
                                         instr[3] = '1';
                                    break;
                          }
                          break;
                     default:
                          instr[6] = '1';instr[7] = '1';
                          upchar();
                          break;
                }
                break;
           case 'A':
           case 'M':
                prech = ch;
                ch = nextch();
                switch(ch)
                {
                     case '+':
                          ch = nextch();
                          instr[4] = '1';instr[5] = '1';instr[7] = '1';
                          instr[8] = '1';instr[9] = '1';
                          break;
                     case '-':
                          ch = nextch();
                          switch(ch)
                          {
                               case '1':
                                    instr[4] = '1';instr[5] = '1';instr[8] = '1';
                                    break;
                               case 'D':
                                    instr[7] = '1';instr[8] = '1';instr[9] = '1';
                                    break;
                          }
                          break;
                     default:
                          instr[4] = '1';instr[5] = '1';
                          upchar();
                          break;
                }
                if(prech == 'M')
                     instr[3] = '1';
                break;
     }
}

void destyield(char *str)
{
     int i,len = strlen(str);
     for(i = 0;i < len;i ++)
     {
           switch(str[i])
           {
               case 'M':
                    instr[12] = '1';
                    break;
               case 'A':
                    instr[10] = '1';
                    break;
               case 'D':
                    instr[11] = '1';
                    break;
           }
     }
}

void jumpyield(char *str)
{
     if(!strcmp(str,"JGT"))
     {
          instr[15] = '1';
     }
     else if(!strcmp(str,"JEQ"))
     {
          instr[14] = '1';
     }
     else if(!strcmp(str,"JGE"))
     {
          instr[15] = '1';instr[14] = '1';
     }
     else if(!strcmp(str,"JLT"))
     {
          instr[13] = '1';
     }
     else if(!strcmp(str,"JNE"))
     {
          instr[13] = '1';instr[15] = '1';
     }
     else if(!strcmp(str,"JLE"))
     {
          instr[13] = '1';instr[14] = '1';
     }
     else if(!strcmp(str,"JMP"))
     {
          instr[13] = '1';instr[14] = '1';instr[15] = '1';
     }
}

void Ccommad(int value)
{    
     int i;
     char ch,str[50];
     
     for(i = 0;i < 17;i ++)
          instr[i] = '0';     
     instr[0] = '1';
     instr[1] = '1';
     instr[2] = '1';
     instr[16] = '\0';
     
     getvar(ch,str);
     ch = nextch();
     if(ch == '=')
     { 
          destyield(str);
          value = nextch();
     }
     else
     { 
          value = str[0];
          upchar();
     }
     
     compyield(value);
     
     ch = nextch();
     if(ch == ';')
     {
          ch = nextch();
          getvar(ch,str);
          jumpyield(str);
     }
     else
          upchar();
     
     printf("%s\n",instr);
}
