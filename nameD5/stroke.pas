unit stroke;

interface

var
  Fgbkstroke:file of byte;
  Fgbkbig5:file of word;
  function getstroke(hzchar:word):byte;
  function getbig5(hzchar:word):word;
  procedure openfiles();

implementation

function getstroke(hzchar:word):byte;
var
  i:byte;
  pos:integer;
begin
  pos:=integer(hzchar);//-$00008100);
  pos:=pos-$8100;
  seek(Fgbkstroke,pos);
  read(Fgbkstroke,i);
  result:= i;
end;

function getbig5(hzchar:word):word;
var
  i:word;
begin
  seek(Fgbkbig5,hzchar-$8100);
  read(Fgbkbig5,i);
  result := i;
end;

procedure openfiles();
begin
  assignfile(Fgbkstroke,'GBKSTROKE.BIN');
  reset(Fgbkstroke);
  assignfile(Fgbkbig5,'BIG5CHAR.TXT');
  reset(Fgbkbig5);
end;

end.
