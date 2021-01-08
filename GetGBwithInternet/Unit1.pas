unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, ScktComp, Psock, NMHttp, StdCtrls,inifiles, ComCtrls;

type
  TForm1 = class(TForm)
    NMHTTP1: TNMHTTP;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  index:integer;
  GBBHK:file of byte;
  errorfile:textfile;
  inifile:TiniFile;
  path:string;
  run:boolean;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  address,temp:string;
  code1,code2,stroke:array[1..4] of integer;
  i,pt:integer;
begin
  button1.Enabled:=false;
  button2.Enabled:=true;
  button3.Enabled:=false;
  NMHTTP1.InputFileMode := FALSE;
  NMHTTP1.OutputFileMode := FALSE;
  NMHTTP1.ReportLevel := Status_Basic;
  run:=true;
  memo1.Clear;
  while run=true do
  begin
    code1[1]:=(index*4+1)div 94+176;
    code2[1]:=((index*4+1) mod 94)+$a0;
    code1[2]:=(index*4+2)div 94+$b0;
    code2[2]:=((index*4+2) mod 94)+$a0;
    code1[3]:=(index*4+3)div 94+$b0;
    code2[3]:=((index*4+3) mod 94)+$a0;
    code1[4]:=(index*4+4)div 94+$b0;
    code2[4]:=((index*4+4) mod 94)+$a0;
    address:='clickfate.com/cgi-bin/namefatecn/namefate.cgi?lastname=%'+inttohex(code1[1],2)+'%'+inttohex(code2[1],2);
    address:=address+'%'+inttohex(code1[2],2)+'%'+inttohex(code2[2],2);
    address:=address+'&firstname=%'+inttohex(code1[3],2)+'%'+inttohex(code2[3],2);
    address:=address+'%'+inttohex(code1[4],2)+'%'+inttohex(code2[4],2);
    NMHTTP1.Get(address);
//  Memo1.Text := NMHTTP1.Body;
    pt:=pos(chr(code1[1])+chr(code2[1])+'</b></font> ',NMHTTP1.body);
    if pt<>0 then
    begin
      temp:=NMHTTP1.Body[pt+14]+NMHTTP1.Body[pt+15];
      stroke[1]:=strtoint(temp);
      memo1.Lines.Add(chr(code1[1])+chr(code2[1])+':'+temp+'��');
      pt:=pos(chr(code1[2])+chr(code2[2])+'</b></font> ',NMHTTP1.body);
      temp:=NMHTTP1.Body[pt+14]+NMHTTP1.Body[pt+15];
      stroke[2]:=strtoint(temp);
      memo1.Lines.Add(chr(code1[2])+chr(code2[2])+':'+temp+'��');
      pt:=pos(chr(code1[3])+chr(code2[3])+'</b></font> ',NMHTTP1.body);
      temp:=NMHTTP1.Body[pt+14]+NMHTTP1.Body[pt+15];
      stroke[3]:=strtoint(temp);
      memo1.Lines.Add(chr(code1[3])+chr(code2[3])+':'+temp+'��');
      pt:=pos(chr(code1[4])+chr(code2[4])+'</b></font> ',NMHTTP1.body);
      temp:=NMHTTP1.Body[pt+14]+NMHTTP1.Body[pt+15];
      stroke[4]:=strtoint(temp);
      memo1.Lines.Add(chr(code1[4])+chr(code2[4])+':'+temp+'��');
    end
    else
    begin
      for i:=1 to 4 do
      begin
        address:='clickfate.com/cgi-bin/namefatecn/namefate.cgi?lastname=%'+inttohex(code1[i],2)+'%'+inttohex(code2[i],2)+'&firstname=%'+inttohex(code1[i],2)+'%'+inttohex(code2[i],2);
        NMHTTP1.Get(address);
        pt:=pos(chr(code1[i])+chr(code2[i])+'</b></font> ',NMHTTP1.body);
        if pt<>0 then
        begin
          temp:=NMHTTP1.Body[pt+14]+NMHTTP1.Body[pt+15];
          stroke[i]:=strtoint(temp);
          memo1.Lines.Add(chr(code1[i])+chr(code2[i])+':'+temp+'��');
        end
        else
        begin
          stroke[i]:=0;
          memo1.Lines.Add(chr(code1[i])+chr(code2[i])+':�޴���');
          writeln(errorfile,chr(code1[i])+chr(code2[i]));
        end;
      end;
    end;
    for i:=1 to 4 do
    begin
      write(GBBHK,stroke[i]);
    end;
    inc(index);
    if index=1692 then run:=false;
    inifile.WriteInteger('history','next',index);
    statusbar1.SimpleText:='�����'+inttostr(index*4)+'��';
  end;
  button3.Enabled:=true;
  button1.Enabled:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  path:=extractfilepath(application.exename);
  inifile:=Tinifile.Create(path+'history.ini');
  index:=inifile.ReadInteger('history','next',0);
  assignfile(GBBHK,path+'GBBHK.BIN');
  reset(GBBHK);
  seek(GBBHK,filesize(GBBHK));
  assignfile(errorfile,path+'error.txt');
  append(errorfile);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inifile.Free;
  closefile(GBBHK);
  closefile(errorfile);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  run:=false;
  button2.Enabled:=false;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  close;
end;


end.
