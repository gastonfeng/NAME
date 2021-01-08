//---------------------------------------------------------------------------

#include <vcl.h>
#include <fstream.h>
#pragma hdrstop

#include "Unit1.h"
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

void __fastcall TForm1::Button1Click(TObject *Sender)
{
  unsigned char oneline[4];
  //ofstream ofs( "GBKHZ.TXT", ios::binary );
  FILE * ofs=fopen("GBKHZ.TXT","w+t");
  oneline[2]=0x0D;
  oneline[3]=0x0A;                        //换行符
  for (int qm=0x81;qm<=0xFE;qm++)         //区码0X81-0XFE
    for (int wm=0x40;wm<=0xFE;wm++)     //位码0X40-0XFE
      if ((qm<=0xa0||qm>=0xaa)&&(wm!=0X7F) )
                                        //剔除0xA1-0xA9区和位码为0x7F的区域
        if ( !(wm>=0Xa1 && ( (qm>=0xaa && qm<=0xaf)|| (qm>=0xf8))))
                                        //除去AAA1-AFFE和F8A1-FEFE两块矩形区域
          if (! ((wm>=0xfa && qm==0xd7)|| (wm>=0X50 &&qm==0xfe)))
                                        //剔除D7FA-D7FE和FE50-FEFE
          {
            oneline[0]=qm;                          //汉字区码
            oneline[1]=wm;                          //汉字位码
            fprintf(ofs,"%c%c%c%c",oneline[0],oneline[1],oneline[2],oneline[3]);
           }                             //写一行至GBKHZ.TXT
            fclose(ofs);
        
}
//---------------------------------------------------------------------------
 