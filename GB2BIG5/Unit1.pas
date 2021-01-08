unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
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
const
 GBfirst = $A1A1;
 GBlast = $FEFE;
 GBsize = $5E5E;
var
 Instance: THandle;
 GBTAB, DupCode, DupData: TResourceStream;

function GetBIGS(S: string): string;
var
 C: array[0..5] of Char;
 W: PWordArray;
 CA: array[0..2] of Char;
 I: Integer;
 bak: string;
begin
 GBTAB := TResourceStream.Create(Instance, 'GB2BIG', RT_RCDATA);
 DupCode := TResourceStream.Create(Instance, 'DUPCODE', RT_RCDATA);
 DupData := TResourceStream.Create(Instance, 'DUPDATA', RT_RCDATA);
 bak := '';
 if Byte(S[1]) > $A0 then begin
  W := @(C[0]);
  C[2] := S[1];
  C[3] := S[2];
  C[5] := S[1];
  C[4] := S[2];
  W[2] := W[2] - GBfirst;
  GBTAB.Position := W[2] * 2;
  GBTAB.read(CA, 2);
  CA[2] := #0;
  bak := bak + StrPas(CA);
  I := 0;
  while I < DupCode.Size do begin
   DupCode.Position := I;
   DupCode.read(C, 2);
   if W[0] = W[1] then begin
    DupData.Position := I;
    DupData.read(CA, 2);
    CA[2] := #0;
    bak := bak + CA;
   end;
   inc(I, 2);
  end;
 end;
 Result := bak;
 GBTAB.Free;
 DupCode.Free;
 DupData.Free;
end;

function GBtoBIG5(S: string): string;
var
 bak: string;
 C: array[0..1] of Byte;
 I: Integer;
 W: PWordArray;
 CA: array[0..2] of Char;
begin
 GBTAB := TResourceStream.Create(Instance, 'GB2BIG', RT_RCDATA);
 DupCode := TResourceStream.Create(Instance, 'DUPCODE', RT_RCDATA);
 DupData := TResourceStream.Create(Instance, 'DUPDATA', RT_RCDATA);
 bak := '';
 W := @(C[0]);
 I := 1;
 while I <= Length(S) do begin
  C[1] := Byte(S[I]);
  if C[1] > $A0 then begin
   inc(I, 1);
   C[0] := Byte(S[I]);
   inc(I, 1);
   W[0] := W[0] - GBfirst;
   GBTAB.Position := W[0] * 2;
   GBTAB.read(CA, 2);
   CA[2] := #0;
   bak := bak + StrPas(CA);
  end
  else begin
   bak := bak + S[I];
   inc(I, 1);
  end;
 end;
 Result := bak;
 GBTAB.Free;
 DupCode.Free;
 DupData.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   edit2.text:=GBtoBIG5(edit1.text);
end;

end.
