//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("namelive.res");
USEFORM("main.cpp", Form1);
USEFORM("report.cpp", QuickReport1); /* TQuickRep: File Type */
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TForm1), &Form1);
     Application->CreateForm(__classid(TQuickReport1), &QuickReport1);
     Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
