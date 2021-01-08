unit gbkstroke;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, jpeg, ExtCtrls, Grids, ImgList;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ImageList1: TImageList;
    StringGrid1: TStringGrid;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure ToolButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  gbkbhk,GBBHK,big5bhk:file of byte;
  gbkchar,big5char,biggbk:file of word;
implementation

{$R *.DFM}

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  gbkcode,big5code:word;
  gbkstroke,big5stroke,gbstroke,t1,t2:byte;
begin
  assignfile(gbkchar,'GBKCHAR.txt');
  reset(gbkchar);
  assignfile(big5char,'BIG5CHAR.txt');
  reset(big5char);
  assignfile(GBBHK,'GBBHK.bin');
  reset(GBBHK);
  assignfile(big5bhk,'BIG5BHK.bin');
  reset(big5bhk);
  assignfile(biggbk,'biggbkchar.txt');
  reset(biggbk);
  assignfile(gbkbhk,'gbkstroke.bin');
  reset(gbkbhk);
  stringgrid1.Cells[0,0]:='GBK代码';
  stringgrid1.Cells[1,0]:='GBK字型';
  stringgrid1.Cells[2,0]:='GBK笔划';
  stringgrid1.Cells[3,0]:='BIG5代码';
  stringgrid1.Cells[4,0]:='BIG5字型';
  stringgrid1.Cells[5,0]:='BIG5笔划';
  stringgrid1.Cells[6,0]:='GB繁体';
  stringgrid1.Cells[7,0]:='GB繁码';
  stringgrid1.Cells[8,0]:='GBK笔划';
  for i:=1 to 32192 do
  begin
    read(GBKchar,gbkcode);
    t1:=gbkcode div 256;
    t2:=gbkcode mod 256;
    gbkcode:=t2*256+t1;
    stringgrid1.Cells[0,i]:=inttohex(gbkcode,4);
    stringgrid1.Cells[1,i]:=chr(gbkcode div 256)+chr(gbkcode mod 256);
    gbstroke:=0;
    if (gbkcode>$b0a0) then
    begin
      t1:=((gbkcode div 256)-$b0);
      t2:=(gbkcode mod 256)-$a0;
      if ((t1*94+t2-1)<6768) and ((gbkcode mod 256)>=$a0) then
      begin
        seek(gbbhk,t1*94+t2-1);
        read(gbbhk,gbstroke);
      end
      else gbstroke:=0;
    end;
    stringgrid1.Cells[2,i]:=inttostr(gbstroke);
    seek(big5char,i-1);
    read(big5char,big5code);
    t1:=big5code div 256;
    t2:=big5code mod 256;
    big5code:=t2*256+t1;
    stringgrid1.cells[3,i]:=inttohex(big5code,4);

    if(big5code>$a3ff) and (big5code<$f9ff) then
    begin
      seek(big5bhk,big5code-$a400);
      read(big5bhk,big5stroke);
    end;

    stringgrid1.Cells[4,i]:=chr(big5code div 256)+chr(big5code mod 256);
    stringgrid1.Cells[5,i]:=inttostr(big5stroke);

    seek(biggbk,i-1);
    read(biggbk,big5code);
    t1:=big5code div 256;
    t2:=big5code mod 256;
    big5code:=t2*256+t1;

    stringgrid1.Cells[6,i]:=chr(big5code div 256)+chr(big5code mod 256);
    stringgrid1.Cells[7,i]:=inttohex(big5code,4);

    read(gbkbhk,gbkstroke);
    stringgrid1.Cells[8,i]:=inttostr(gbkstroke);
  end;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
var
  i:integer;
begin
  i:=stringgrid1.row;
  i:=i-100;
  if i>1 then stringgrid1.row:=i;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
var
i:integer;
begin
  i:=stringgrid1.Row;
  i:=i+100;
  if i<=stringgrid1.RowCount then stringgrid1.row:=i;
end;

procedure TForm1.ToolButton7Click(Sender: TObject);
var
  i:integer;
  t:byte;
begin
  assignfile(gbkbhk,'gbkstroke.bin');
  rewrite(gbkbhk);
  for i:=1 to 32192 do
  begin
    if strtoint(stringgrid1.Cells[5,i])<>0 then
    begin
      t:=strtoint(stringgrid1.Cells[5,i]);
      write(gbkbhk,t);
    end
    else
    begin
      t:=strtoint(stringgrid1.cells[2,i]);
      write(gbkbhk,t);
    end;
  end;
  closefile(gbkbhk);
  showmessage('保存完成！');
end;

end.
