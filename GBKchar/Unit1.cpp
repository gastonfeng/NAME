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
  oneline[3]=0x0A;                        //���з�
  for (int qm=0x81;qm<=0xFE;qm++)         //����0X81-0XFE
    for (int wm=0x40;wm<=0xFE;wm++)     //λ��0X40-0XFE
      if ((qm<=0xa0||qm>=0xaa)&&(wm!=0X7F) )
                                        //�޳�0xA1-0xA9����λ��Ϊ0x7F������
        if ( !(wm>=0Xa1 && ( (qm>=0xaa && qm<=0xaf)|| (qm>=0xf8))))
                                        //��ȥAAA1-AFFE��F8A1-FEFE�����������
          if (! ((wm>=0xfa && qm==0xd7)|| (wm>=0X50 &&qm==0xfe)))
                                        //�޳�D7FA-D7FE��FE50-FEFE
          {
            oneline[0]=qm;                          //��������
            oneline[1]=wm;                          //����λ��
            fprintf(ofs,"%c%c%c%c",oneline[0],oneline[1],oneline[2],oneline[3]);
           }                             //дһ����GBKHZ.TXT
            fclose(ofs);
        
}
//---------------------------------------------------------------------------
 