unit d5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  gbklist:file of word;
  i,qm,wm:integer;
begin
  assignfile(gbklist,'GBKCHAR.TXT');
  rewrite(gbklist);
  for qm:=$81 to $fe do
    for wm:=0 to 255 do
  begin
    i:=qm+wm*256;
    write(gbklist,i);
  end;
  closefile(GBKlist);
  button1.Caption:='Complete!';
end;

end.
