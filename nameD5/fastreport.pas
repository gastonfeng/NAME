unit fastreport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ReportControl;

type
  TForm2 = class(TForm)
    ReportControl1: TReportControl;
    ReportRunTime1: TReportRunTime;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

end.
