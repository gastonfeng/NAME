//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ToolButton10Click(TObject *Sender)
{
//shutdown the compute
    Close();       
//  ExitWindowsEx(EWX_SHUTDOWN,tmp);
}
//---------------------------------------------------------------------------


void __fastcall TForm1::Button1Click(TObject *Sender)
{


   int nf1,nf2,n1,n2;
   int year,month,day,hour,l1,l2;

   Edit1->Text.Trim();
   l1=Edit1->GetTextLen();
   if(l1==0 ||l1>4){
     ShowMessage("请输入正确的姓！");
     Edit1->SetFocus();
     Abort ();
   }

   Edit2->Text.Trim();
   l2=Edit2->GetTextLen();
   if(l2==0||l2>4){
     ShowMessage("请输入正确的名字！");
     Edit2->SetFocus();
     Abort();
   }

   nf1=Edit1->Text.c_str()[0]*256+Edit1->Text.c_str()[1];
   if(l1==4)nf2=Edit1->Text.c_str()[2]*256+Edit1->Text.c_str()[3];
     else nf2=0;
   n1=Edit2->Text.c_str()[0]*256+Edit2->Text.c_str()[1];
   if(l2==4)n2=Edit2->Text.c_str()[2]*256+Edit2->Text.c_str()[3];
     else n2=0;

   Edit3->Text.Trim();
   year=Edit3->Text.ToInt();
   if(year<1900 ||year>2200){
     ShowMessage("年份错误！");
     Edit3->SetFocus();
     Abort();
   }

   Edit4->Text.Trim();
   month=Edit4->Text.ToInt();
   if(month>12||month<1){
     ShowMessage("月份错误！");
     Edit4->SetFocus();
     Abort();
   }

   Edit5->Text.Trim();
   day=Edit5->Text.ToInt();
   if(day<1 ||day>31){
     ShowMessage("日期输入有误！");
     Edit5->SetFocus();
     Abort();
   }

   hour=Edit6->Text.ToInt();
   
}
//---------------------------------------------------------------------------


