program name;

uses
  Forms,
  main in 'main.pas' {Form1},
  report in 'report.pas' {QuickReport1: TQuickRep},
  DateCn in 'DateCn.pas',
  stroke in 'stroke.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TQuickReport1, QuickReport1);
  Application.Run;
end.
