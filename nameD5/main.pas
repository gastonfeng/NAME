unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls, ActnList, StdActns, ComCtrls, ToolWin, Grids,
  Calendar,report,datecn,stroke;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Button1: TButton;
    procedure Action1Execute(Sender: TObject);
    procedure WindowCloseExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Fgbkstroke:file of byte;
  f1,f2,n1,n2:word;
  year,month,day,hour:integer;
  xing1,xing2,ming1,ming2:string;
  cdate:Tdate;
  strx1,strx2,strn1,strn2:byte;
implementation

{$R *.DFM}

procedure TForm1.Action1Execute(Sender: TObject);
begin
  trim(edit1.Text);
  if (edit1.GetTextLen < 2) or (edit1.GetTextLen > 4)then
  begin
    showmessage('输入错误！');
    edit1.SetFocus;
    Abort;
  end;

  trim(edit2.text);
  if (edit2.GetTextLen < 2) or (edit2.GetTextLen > 4)then
  begin
    showmessage('输入错误！');
    edit2.SetFocus;
    abort;
  end;

  trim(edit3.text);
  try
    year:=strtoint(edit3.text);
    except
      showmessage('年份输入错误!');
      edit3.SetFocus;
      abort;
  end;

  trim(edit4.text);
  try
    month:=strtoint(edit4.text);
    except
      showmessage('月份输入错误！');
      edit4.SetFocus;
      abort;
  end;

  trim(edit5.text);
  try
    day:=strtoint(edit5.text);
    except
      showmessage('日期输入错误！');
      edit5.SetFocus;
      abort;
  end;

  trim(edit6.text);
  try
    hour:=strtoint(edit6.text);
    except
      showmessage('时辰输入错误！');
      edit6.SetFocus;
      abort;
  end;

  f1:=ord(edit1.text[1])*256+ord(edit1.text[2]);
  xing1:=edit1.text[1]+edit1.text[2];
  if edit1.GetTextLen=4 then
    begin
      f2:=ord(edit1.text[3])*256+ord(edit1.text[4]);
      xing2:=edit1.text[3]+edit1.text[4];
    end
    else f2:=0;

  n1:=ord(edit2.text[1])*256+ord(edit2.text[2]);
  ming1:=edit2.text[1]+edit2.text[2];
  if edit2.GetTextLen=4 then
  begin
    n2:=ord(edit2.text[3])*256+ord(edit2.text[4]);
    ming2:=edit2.text[3]+edit2.text[4];
  end
    else n2:=0;

  strx1:=getstroke(f1);
  if f2>$8100 then strx2:=getstroke(f2);
  strn1:=getstroke(n1);
  strn2:=getstroke(n2);

  report.quickreport1.xingming.Caption:='姓名：'+xing1+ming1+ming2;
  cdate:=encodedate(year,month,day);
  report.QuickReport1.date.caption:='生日：公元'+inttostr(year)+'年'+inttostr(month)+'月'+inttostr(day)+'日  农历'+cndateofdatestrPH(cdate);
  quickreport1.animal.caption:='生肖：'+cnanimalofyear(cdate);
  quickreport1.family1.Caption:=xing1+'('+inttostr(strx1)+')';
  quickreport1.family2.Caption:=xing2+'('+inttostr(strx2)+')';
  quickreport1.name1.Caption:=ming1+'('+inttostr(strn1)+')';
  quickreport1.name2.Caption:=ming2+'('+inttostr(strn2)+')';
//  quickreport1.preview;
  reportdesignerdialog1.PreviewReport('output.QR2');

//  showmessage('OK!'+chr(f1 div 256)+chr(f1 mod 256));
end;

procedure TForm1.WindowCloseExecute(Sender: TObject);
begin
  close;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  openfiles;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  reportdesignerdialog1.EditReport('output.QR2');
end;

end.
