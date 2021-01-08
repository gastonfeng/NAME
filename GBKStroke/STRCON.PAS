{===============================================================================
StrCon.pas
 Class with string functions - by Eric Grobler (egrobler@quoka.com)

   Status:  Freeware - No restrictions apply - without a warranty of any kind.
 Compiler:  Delphi4,Delphi5
  Version:  1.5
 Lastdate:  21 March 2000

 This unit contains a TStringCollection class with a global instance "sc".
 The class has a large number of general purpose string functions.
 Example usage:
   s := sc.After(',',s); (sc is created in the implementation section)
   s := sc.Upcase(s);

 Advantages of putting string functions inside a class:
  * Functions are neatly grouped together.
  * Global function name conflicts and removed.
  * Function names can be shorter than their global counterparts.
  * The object can be extended.

--------------------------------------------------------------------------------
Note:
  Function overloading and default parameters are used. (Delphi 4,5 or higher)
  An "IC" suffix indicates "Ignore case".
  Most functions have examples at code implementation.
  Please feel free to email corrections or additions to egrobler@quoka.com.

Some examples:
 sc.Strip('   hello    world  ') > 'hello world'
 sc.GetChars('123Hello',['A'..'z']) > 'Hello'
 sc.Purge('123Hello',['A'..'z']) > '123'
 sc.After('.','c:\folder.files\name.txt') > 'files\name.txt'
 sc.AfterRev('.','c:\folder.files\name.txt') > 'txt'
 sc.BeforeRev('.','c:\folder.files\name.txt') > 'c:\folder.files\name'
 sc.Upcase('polé') > 'POLÉ'
 sc.BaseToStr(12,'01',8) > '00001100'
 sc.Str(12.1) > '12.10'
 sc.ToF('12.1') > 12.1
 sc.WordPos('the','where is the word?') > 10
 sc.Replace('dog','cat','The dog is Dogmeat') > 'The cat is Dogmeat'
--------------------------------------------------------------------------------
Modifications, additions:
  3 Sept 1999
    new function Parse (Reinder de Jager)
  4 Sept 1999
    ReturnSet renamed as GetChars
    new functions WordCase, ProperCase, CountChars, GetSingle
 10 Oct 1999
    TStringCollection changed from an Object type to a Class type.
    new StrFloat function
 06 April 2000 - Some note corrections
    New functions: CharSetToVisualStr, VisualStrToCharSet, StrVar, ToVar, CountWords,
                   MakePChar,FreePChar
===============================================================================}
unit StrCon;

interface                          

uses Windows,SysUtils;

type
  TCharSet = set of char;
  TIntSize = 1..4;
  //TCurrency is defined as a record type to differenciate in from Double and TDateTime values
  TCurrency = packed record c : Currency; end;
  TAskUpcaseWord = function(const s : string) : boolean;
const
  gcIntCharSet      : TCharSet = ['0'..'9','-','+'];
  gcNumCharSet      : TCharSet = ['0'..'9',',','.','-','+'];
  gcFloatCharSet    : TCharSet = ['0'..'9',',','.','-','+','E','e'];
  gcAZCharSet       : TCharSet = ['A'..'Z','a'..'z'];
  gcBooleanTrueSet  : TCharSet = ['1','T','t','Y','y','J','j'];
  gcCharSetVisualRange : TCharSet = ['\','$','%','&','@','*','+','/','A'..'Z','a'..'z','{','}','(',')','>','<','?','0'..'9','[',']'];
  gcBaseBinary  = '01';
  gcBaseHex     = '0123456789ABCDEF';


type
//TStringCollection - global instance "sc" declared below-----------------------
TStringCollection = class

  //Strip/Trim and Purge--------------------------------------------------------
  function Strip(const s : string; c : char = ' ') : string;
  function Trim(const s : string;c : char = ' ') : string;
  function Purge(const s : string; aSet : TCharSet) : string; overload;
  function Purge(const s : string; aChar : char) : string; overload;
  function PurgeWhile(const s : string; aSet : TCharSet) : string;
  function PurgeWhileRev(const s : string; aSet : TCharSet) : string;
  function PurgeWhileOuter(const s : string; aSet : TCharSet) : string;
  function GetChars(const s : string; aSet : TCharSet) : string;
  function GetSingle(const s1 : string;s2 : string = '') : string;

  //Compare and Informational---------------------------------------------------
  function IsSame(const s1,s2 : string; StripChar : char = ' ') : boolean; overload;
  function IsSameIC(const s1,s2 : string; StripChar : char = ' ') : boolean; overload;
  function IsSameFirst(SubStr,s : string; StripChar : char = ' ') : boolean; overload;
  function IsSameFirstIC(SubStr,s : string; StripChar : char = ' ') : boolean; overload;
  function IsSame(const s1,s2 : string; PurgeSet : TCharSet) : boolean; overload;
  function IsSameIC(const s1,s2 : string; PurgeSet : TCharSet) : boolean; overload;
  function IsSameFirst(SubStr,s : string; PurgeSet : TCharSet) : boolean; overload;
  function IsSameFirstIC(SubStr,s : string; PurgeSet : TCharSet) : boolean; overload;

  function IsLast(const SubStr,s : string) : boolean;
  function IsShortString(s : array of const) : boolean;
  function HasWord(const word,s : string) : boolean;
  function HasWordIC(const word,s : string) : boolean;
  function HasChar(c : char; const s : string) : boolean; overload;
  function HasChar(aSet : TCharSet; const s : string) : boolean; overload;
  function HasCharIC(c : char; const s : string) : boolean;
  function CountChars(const s : string;aSet : TCharSet) : integer;
  function CountWords(const s : string;aDelims : TCharSet = [' ',#9,#10,#13]) : integer;

  //Case------------------------------------------------------------------------
  function UpCase(const s : string) : string; overload;
  function LoCase(const s : string) : string; overload;
  function LoCase(c : char) : char; overload;
  function UpCase(c : char) : char; overload;
  function HasLoCase(const s : string) : boolean;
  function HasUpCase(const s : string) : boolean;
  function AZUpCase(const s : string) : string; overload;//non ANSI
  function AZLoCase(const s : string) : string; overload;//non ANSI
  function AZUpCase(c : char) : char; overload;//non ANSI
  function AZLoCase(c : char) : char; overload;//non ANSI
  function ProperCase(const s : string;AskUpcaseWordFunc : TAskUpcaseWord = nil;UseBasicFuncIfNil : boolean = true) : string;
  function WordCase(const s : string;const UpcaseDelims : TCharSet = [' ',',',';'];
            WordDelims : TCharSet = [];AskUpcaseWordFunc : TAskUpcaseWord = nil): string;

  //Manipulation----------------------------------------------------------------
  function Ins(const SubStr, s : string; Index : integer) : string;
  function Copy(const s : string; Index, Count : integer) : string;
  function SetAt(const s : string; const c : char; Index : integer) : string;
  function Center(const s: string; Len: integer; PadChar : char = ' '): string;
  function ReplaceChars(const s : string; OldChars : TCharSet; NewChar : char) : string;
  function Replace(FindStr, ReplaceWith, InStr : string) : string; overload;
  function Replace(FindStr, ReplaceWith, InStr : string;
    WholeWord, CaseSensitive : boolean; Delims : TCharSet = [' ']) : string; overload;
  function ReplaceFirst(FindStr,ReplaceAllStr,InStr : string; wholeword : boolean;
    CaseSensitive : boolean; Delims : TCharSet; var StartAt : integer) : string;

  //Delete----------------------------------------------------------------------
  function Del(const SubStr,s : string): string;
  function DelIfFirst(IfInSet : TCharSet; const s : string) : string; overload;
  function DelIfFirst(const SubStr,s : string) : string; overload;
  function DelIfLast(const SubStr,s : string) : string; overload;
  function DelIfLast(IfInSet : TCharSet; const s : string) : string; overload;
  function Cut(var s : string; Index, Count : integer) : string;

  //Padding---------------------------------------------------------------------
  function Pad(const s : string; PadLen : SmallInt; c : char = ' ') : string; {-1 will pad left}
  function PadCut(const s : string; PadLen : SmallInt; c : char = ' ') : string;
  function PadLeft(const s : string; PadLen : Word; c : char = ' ') : string;

  //Positional------------------------------------------------------------------
  function Pos(const SubStr, s : string; StartPos : Cardinal = 0; IgnoreCase : boolean = false) : integer;
  function PosIC(const SubStr, s : string; StartPos : Cardinal = 0) : integer;
  function PosRev(SubStr, s : string; IgnoreCase : boolean = false) : integer;
  function WordPos(SubStr : string; s : string;Delims : TCharSet = [' '];StartPos : Cardinal = 0) : integer;

  function After(const SubStr : string; const s : string; Position : Cardinal = 0) : string; overload;
  function After(const aSet : TCharSet; const s : string) : string; overload;
  function AfterRev(const SubStr : string; const s : string) : string; overload;
  function AfterRev(const aSet : TCharSet; const s : string) : string; overload;
  function AfterIC(const SubStr : string; const s : string; Position : Cardinal = 0) : string;
  function AfterNth(const SubStr : string; const s : string; Nth : integer=0) : string;

  function Before(const SubStr : string; const s : string; Position : Cardinal = 0) : string; overload;
  function Before(const aSet : TCharSet; const s : string) : string; overload;
  function BeforeRev(const SubStr : string; const s : string) : string; overload;
  function BeforeRev(const aSet : TCharSet; const s : string) : string; overload;
  function BeforeIC(const SubStr : string; const s : string;Position : Cardinal = 0) : string;
  function BeforeNth(const SubStr : string; const s: string;Nth : integer=0): string;


  function At(const s : string; Index : integer) : char;
  function First(const s : string; count : integer = 1) : string;
  function Last(const s : string; count : integer = 1) : string;
  function FirstChar(const s: string) : char;
  function LastChar(const s: string) : char;
  function FirstWord(const s: string; Delims : TCharSet = [' ']) : string;
  function LastWord(const s: string; Delims : TCharSet= [' ']) : string;

  function LeftAt(const s : string; Position : integer) : string;
  function RightAt(const s : string; Position : integer) : string;

  function Parse(const SubStr: string; var s: string;Position: Cardinal = 0): string; overload;
  function Parse(const aSet: TCharSet; var s: string): string; overload;


  //Numeric To String conversions-------------------------------------------------------
  function Str(Value : integer) : string; overload;
  function Str(Value : Byte;PadLen : SmallInt = 0; PadChar : char = '0') : string; overload;
  function Str(Value : SmallInt; PadLen : SmallInt = 0; PadChar : char = '0') : string; overload;
  function Str(Value : Word; PadLen : SmallInt = 0; PadChar : char = '0') : string; overload;
  function Str(Value : integer; PadLen : SmallInt; PadChar : char = '0') : string; overload;
  function Str(Value : Cardinal; PadLen : SmallInt = 0; PadChar : char = '0') : string; overload;
  function Str(Value : Int64; PadLen : SmallInt = 0; PadChar : char = '0') : string; overload;

  function Str(Value : double; PadLen : SmallInt = 0; PadChar : char = '0') : string; overload;
  function Str(Value : Extended; PadLen : SmallInt = 0; PadChar : char = '0') : string; overload;
  function Str(Value : TCurrency; PadLen : SmallInt = 0; PadChar : char = '0') : string; overload;

  function StrCur(Value : Currency; PadLen : SmallInt = 0; PadChar : char = '0') : string;
  function StrFloat(Value : extended; aFormatStr : string = '0.00###'; PadLen : SmallInt = 0; PadChar : char = ' ') : string;
  function FormatSize(Size : word) : string; overload;
  function FormatSize(Size : Integer) : string; overload;
  function FormatSize(Size : Cardinal) : string; overload;
  function FormatSize(Size : Int64) : string; overload;



  //From string to Numeric conversions-----------------------------------------------------
  procedure Val(const s : string; var Value : Byte); overload;
  procedure Val(const s : string; var Value : SmallInt); overload;
  procedure Val(const s : string; var Value : Word); overload;
  procedure Val(const s : string; var Value : integer); overload;
  procedure Val(const s : string; var Value : Cardinal); overload;
  procedure Val(const s : string; var Value : Int64); overload;
  procedure Val(const s : string; var Value : double); overload;
  procedure Val(const s : string; var Value : Extended); overload;
  procedure Val(const s : string; var Value : TCurrency); overload;
  //Unfortunately Delphi currently does not allow overloading on function results,
  //therefore ToI is sometimes preferable to overloaded Val version
  function ToI(const s : string) : integer;
  function ToF(const s : string) : Extended;
  function ToC(const s : string) : TCurrency;
  function ToL(const s : string) : Cardinal;
  function ToI64(const s : string) :  Int64;

  //Other type to string conversions
  function Str(Value : boolean) : string; overload;
  function Str(Value : TCharSet;AsVisual : boolean = false) : string; overload;
  function StrDate(Value : TDateTime) : string; overload;
  function StrDate(Value : TDateTime;aDateFormat : string) : string; overload;
  function StrDateTime(Value : TDateTime) : string; overload;
  function StrDateTime(Value : TDateTime;aDateFormat : string) : string; overload;
  function Str(const aFormat: string; const Args: array of const): string; overload;
  function StrVar(var Source;Count : integer = -1;Terminators : TCharSet = []) : string;


  //Other string to type conversions
  procedure Val(const s : string; var Value : boolean); overload;
  procedure Val(const s : string; var Value : TCharSet;FromVisualSet : boolean = false); overload;
  function  ToSet(const s : string;FromVisualSet : boolean = false) : TCharset;
  function  ToBool(const s : string) : boolean;
  procedure ToVar(const Source : string;var Target;TargetSize : integer;EnsureAsciiZ : Boolean = false;ClearData : boolean = true);


  //Numeric base conversions----------------------------------------------------
  function BaseToStr(Value : Cardinal; Key : string; Digits : Byte = 0) : string;
  function BaseVal(s : string; Key : string) : Cardinal;
  function BaseStr(Value : Cardinal; Key : string) : string; overload;
  function BaseStr(Value : integer; Key : string) : string; overload;
  function BaseStr(Value : ShortInt; Key : string) : string; overload;
  function BaseStr(Value : SmallInt; Key : string) : string; overload;
  function BaseStr(Value : Word; Key : string) : string; overload;
  function BaseStr(Value : Byte; Key : string) : string; overload;
  function BaseStrR(Value : Cardinal; Key : string; Digits : Byte) : string; //with range check
  function BaseRange(Key : string; Digits : Byte) : Cardinal;
  function BaseStrLen(Key : string; ByteSize : TIntSize) : Byte;

  //Miscellaneous---------------------------------------------------------------
  function Rev(const s : string) : string;
  function RepeatChar(c : char; Count : integer) : string;
  function RepeatStr(const s : string; Count : integer) : string;
  function Sort(const s : string) : string;
  function SlashAdd(const s : String) : string;
  function SlashDel(const s : String) : string;
  function CharsetToVisualStr(const aSet: TCharset; DoRange: boolean = true): string;
  function VisualStrToCharSet(s: string): TCharset;
  function  MakePChar(const s : string) : PChar;
  procedure FreePChar(var p : PChar);

end;

//Global functions
function BasicUpcaseWords(const s : string) : boolean;

//Exception procedures - see "Notes on the eRaise exception procedure" below
procedure eRaise(aMessage : string; aObject : TObject); overload; //same as "on e:exception.create(aMessage+gcCR+e.message);"
procedure eRaise(aMessage : string; aFuncName : string= ''; aObject : TObject= nil); overload;



//Global instance
var sc : TStringCollection; //Global string collection variable (see Initialization)

implementation

{-------------------------------------------------------------------------------
Notes on the eRaise exception procedure
 You can use this procedure instead of the default call "raise exception.create("
 The eRaise procedure preserve nested exception error messages and is more consice.

 Delphi method:
     x := 0;
     try
       x := 2 div x;
     except
       on e:exception do raise exception.create('We have a problem'+#13+10+e.message);
     end;

  eRaise method:
     x := 0;
     try
       x := 2 div x;
     except
       eRaise('We have a problem'); //will add e.message "division by 0" automatically
     end;


You can also optionally pass a function name and class to the eRaise procedure.
 The example below will return the following error message:
 "Unable to read autoexec.bat
  Cannot open file: d:\autoexec.bat
  File not found
  Func: OpenAFile,ReadAutoExec
  Class: TForm1"

  procedure OpenAFile(var f : textfile; path : string);
  begin
    try
      AssignFile(f,path);
      Reset(f);
    except
      eRaise('Cannot open file: '+path,'OpenAFile'); //use ERaiseFunc for Delphi3
    end;
  end;

  procedure Tform1.ReadAutoExec;
  var f : textfile;
  begin
    try
      OpenAFile(f,'d:\autoexec.bat');
    except
      eRaise('Unable to read autoexec.bat','ReadAutoExec',self); //use EraiseEx for Delphi3
    end;
  end;

  procedure TForm1.Button1Click(Sender: TObject);
  begin
    ReadAutoExec;
  end;
--------------------------------------------------------------------------------}

//Exception constants
const
  geIdFunc = 'Func: ';
  geIdClass = 'Class: ';
  gcCR = #13+#10;


//TStringCollection=============================================================

{-------------------------------------------------------------------------------
*UpCase - AnsiUpperCase converts all characters in the given string to uppercase.
 The conversion uses the current Windows locale.
 Note: This function supports multi-Byte character sets (MBCS).
 Example: UpCase('polé') > 'POLÉ'
See also overloaded char version
-------------------------------------------------------------------------------}
function TStringCollection.UpCase(const s : string) : string;
begin
  Result := SysUtils.AnsiUpperCase(s);
end;

{-------------------------------------------------------------------------------
*LoCase - AnsiLowerCase converts all characters in the given string to lowercase.
 The conversion uses the current Windows locale.
 Note: This function supports multi-Byte character sets (MBCS).
 Example: LoCase('POLÉ') > 'polé'
See also overloaded char version
-------------------------------------------------------------------------------}
function TStringCollection.LoCase(const s : string) : string;
begin
  Result := SysUtils.AnsiLowerCase(s);
end;

{-------------------------------------------------------------------------------
*LoCase - LoCase a character according to System locale settings.
 Example: LoCase('É') > 'é'
See also overloaded string version
-------------------------------------------------------------------------------}
function TStringCollection.LoCase(c : char) : char;
begin
  Windows.CharLowerbuff(@c,1);
  Result := c;
end;

{-------------------------------------------------------------------------------
*UpCase
 UpCase a character according to System locale settings.
 Example: UpCase('é') > 'É'
See also overloaded string version
-------------------------------------------------------------------------------}
function TStringCollection.UpCase(c : char) : char;
begin
  Windows.CharUpperbuff(@c,1);
  Result := c;
end;

{-------------------------------------------------------------------------------
*HasLoCase - Returns true if a string contains lowercase characters.
 Example: HasLoCase('Hello') > true
 ANSI compatible
-------------------------------------------------------------------------------}
function TStringCollection.HasLoCase(const s : string) : boolean;
var i : integer;
begin
  Result := true;
  for i := 1 to Length(s) do if s[i]=LoCase(s[i]) then exit;
  Result := false;
end;

{-------------------------------------------------------------------------------
*HasUpCase - Returns true if a string contains uppercase characters.
 Example: HasUpCase('Hello') > true
 ANSI compatible
-------------------------------------------------------------------------------}
function TStringCollection.HasUpCase(const s : string) : boolean;
var i : integer;
begin
  Result := true;
  for i := 1 to Length(s) do if s[i]=UpCase(s[i]) then exit;
  Result := false;
end;

{-------------------------------------------------------------------------------
*Pos - Same as standard Pos function, except that you also can specify the start.
 position, and ignore the case.
 Example: Pos('the','the man there',2) > 9
 Example: Pos('THE','the man there',2,true) > 9
 Note that StartPos 1 and 0 is functionally the same.
-------------------------------------------------------------------------------}
function TStringCollection.Pos(const SubStr,s : string; StartPos : Cardinal = 0; IgnoreCase : boolean = false) : integer;
begin
  if StartPos=0 then
  begin
    if IgnoreCase
    then Result := System.Pos(UpCase(SubStr),UpCase(s))
    else Result := System.Pos(SubStr,s)
  end else
  begin
    if IgnoreCase
    then Result := System.Pos(UpCase(SubStr),UpCase(System.Copy(s,StartPos,Length(s))))
    else Result := System.Pos(SubStr,System.Copy(s,StartPos,Length(s)));
    if Result>0 then Result := (Result+integer(StartPos))-1;
  end;
end;

{-------------------------------------------------------------------------------
*PosIC - Same as standard Pos function, except case insensitive and a starting
 position can be specified.
 See Pos function above
-------------------------------------------------------------------------------}
function TStringCollection.PosIC(const SubStr,s : string; StartPos : Cardinal = 0) : integer;
begin
  Result := Pos(SubStr,s,StartPos,true);
end;

{-------------------------------------------------------------------------------
*PosRev - Same as standard Pos string function except that it scans backwards.
 Example: PosRev('O','HELLO WORLD') > 8 (last O)
-------------------------------------------------------------------------------}
function TStringCollection.PosRev(SubStr,s : string; IgnoreCase : boolean = false) : integer;
var i : integer;

   function IsMatch : boolean;
   var j : integer;
   begin
     Result := false;
     for j := 2 to Length(SubStr) do if SubStr[j]<>s[i+(j-1)] then exit;
     Result := true;
   end;

var l : integer;
begin
  Result := 0;
  if IgnoreCase then
  begin
    s := UpCase(s);
    SubStr := UpCase(SubStr);
  end;
  l := Length(SubStr);
  if l=0 then exit;
  for i := Length(s) downto 1 do
  begin
    if s[i]=SubStr[1] then
    begin
      if l=1 then
      begin
        Result := i;
        exit;
      end else
      begin
        if IsMatch then
        begin
          Result := i;exit;
        end;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------
*WordPos - Returns the position of a word in a string.
 Example: WordPos('the','where is the word?') > 10
-------------------------------------------------------------------------------}
function TStringCollection.WordPos(SubStr : string; s : string; Delims : TCharSet = [' '];StartPos : Cardinal = 0) : integer;
var
  p,n : integer;
  ok  : boolean;
begin
  Result := 0;
  p := StartPos;
  repeat
    n := Pos(SubStr,s,p);
    if n=0 then exit;
    ok := true;
    if n>1 then
    begin
      if s[n-1] in Delims then else ok := false;
    end;
    if n+Length(SubStr)<=Length(s) then
    begin
      if s[n+Length(SubStr)] in Delims then else ok := false;
    end;
    if ok then
    begin
      Result := n;
      exit;
    end;
    p := p + Length(SubStr);
  until (p=0);
end;


{-------------------------------------------------------------------------------
*After
 Scans for SubStr in s - if found the characters after SubStr is returned else
 an empty string is returned.
 Example: After('Funny','Those Funny People') > ' People';
 Example: After('land','Your land is my land ok',1) > ' is my land ok'
 Example: After('land','Your land is my land ok',7) > ' ok'
 Example: After('not there','Your land is my land ok') > ''
See also Before,Parse,AfterIC,AfterRev and Set overloaded versions.
-------------------------------------------------------------------------------}
function TStringCollection.After(const SubStr : string;const s : string;Position : Cardinal = 0) : string;
var p : integer;
begin
  p := Pos(SubStr,s,Position);
  if p=0
  then Result := ''
  else Result := System.Copy(s,p+Length(SubStr),Length(s));
end;

{-------------------------------------------------------------------------------
*AfterIC - Same as function After except case insensitive.
 Example: AfterIC('FUNNY','Those Funny People' ) > ' People';
See also After
-------------------------------------------------------------------------------}
function TStringCollection.AfterIC(const SubStr : string;const s : string;Position : Cardinal = 0) : string;
var p : integer;
begin
  p := Pos(SubStr,s,Position,true);
  if p=0
  then Result := ''
  else Result := System.Copy(s,p+Length(SubStr),Length(s));
end;

{-------------------------------------------------------------------------------
*AfterNth - Returns the string after the <Nth> appearance of SubStr.
 Example: AfterNth('tree','Green tree, blue tree everywhere',1) > ', blue tree everywhere'
 Example: AfterNth('tree','Green tree, blue tree everywhere',2) > ' everywhere'
See also After,BeforeNth
-------------------------------------------------------------------------------}
function TStringCollection.AfterNth(const SubStr : string;const s : string;Nth : integer=0) : string;
var i : integer;
begin
  if Nth<=1 then Result := After(SubStr,s) else
  begin
    Result := s;
    for i := 1 to Nth do Result := After(SubStr,Result);
  end;
end;

{-------------------------------------------------------------------------------
*BeforeNth
 Returns the string before the <Nth> appearance of SubStr from the left.
 Example: BeforeNth('tree','Green tree, blue tree everywhere',1) > 'Green '
 Example: BeforeNth('tree','Green tree, blue tree everywhere',2) > 'Green tree, blue '
See also Before,AfterNth
-------------------------------------------------------------------------------}
function TStringCollection.BeforeNth(const SubStr : string;const s: string;Nth : integer=0): string;
var i : integer;
    p : integer;
begin
  if Nth<=1 then Result := Before(SubStr,s) else
  begin
    p := 1;
    for i := 1 to Nth do p := Pos(SubStr,s,p+1);
    if p=0
    then Result := s
    else Result := System.Copy(s,1,p-1);
    Result := AfterRev(SubStr,Result);
  end;
end;

{-------------------------------------------------------------------------------
*Before
 Scans for SubStr in s - if found the characters before SubStr is returned else
 the complete string is returned.
 Example: Before(' People','Those Funny People') > 'Those Funny';
 Example: Before('land','Your land is my land',1) > 'Your';
 Example: Before('land','Your land is my land',7) > 'Your land is my ';
 Example: Before('not there','Your land is my land') > 'Your land is my land'
See also After,BeforeIC,BeforeRev
-------------------------------------------------------------------------------}
function TStringCollection.Before(const SubStr : string;const s : string;Position : Cardinal = 0) : string;
var p : integer;
begin
  p := Pos(SubStr,s,Position);
  if p=0
  then Result := s
  else Result := System.Copy(s,1,p-1);
end;

{-------------------------------------------------------------------------------
*BeforeIC - Same as function Before but is case insensitive.
 Example: BeforeIC(' PEOPLE','Those Funny People') > 'Those Funny';
See also Before
-------------------------------------------------------------------------------}
function TStringCollection.BeforeIC(const SubStr : string;const s : string;Position : Cardinal = 0) : string;
var p : integer;
begin
  p := Pos(SubStr,s,Position,true);
  if p=0
  then Result := s
  else Result := System.Copy(s,1,p-1);
end;

{-------------------------------------------------------------------------------
*BeforeRev
 This function scans a string from the right and returns the portion of the
 string before SubStr.
 Example: BeforeRev('.','c:\my.file.txt') > 'c:\my.file'
See also Before,AfterRev
-------------------------------------------------------------------------------}
function TStringCollection.BeforeRev(const SubStr : string;const s : string) : string;
 var p : integer;
begin
  p := PosRev(SubStr,s);
  if p=0
  then Result := s
  else Result := System.Copy(s,1,p-1);
end;

{-------------------------------------------------------------------------------
*AfterRev
 This functions scans s for SubStr from the right and returns the portion after
 SubStr.
 Example: AfterRev('.','c:\my.file.txt') > '.txt'
See also After,BeforeRev
-------------------------------------------------------------------------------}
function TStringCollection.AfterRev(const SubStr : string;const s : string) : string;
var p : integer;
begin
  p := PosRev(SubStr,s);
  if p=0
  then Result := ''
  else Result := System.Copy(s,p+Length(SubStr),Length(s));
end;

{-------------------------------------------------------------------------------
*Pad
 Ads a character at the end of the string until the length is equal to PadLen.
 If PadLen is negative the character will be inserted to the left.
 Example: Pad('hello',7)  > 'hello  '
 Example: Pad('hello',7,' ')  > 'hello  '
 Example: Pad('hello',-7,'.') > '..hello'
 Example: Pad('hello',1,'.') > 'hello'
See also PadCut
-------------------------------------------------------------------------------}
function TStringCollection.Pad(const s : string;PadLen : SmallInt;c : char = ' ') : string;
begin
  Result := s;
  if PadLen<0 then
  begin
    while Length(Result)<abs(PadLen) do Result := c+Result;
  end else
  begin
    while Length(Result)<PadLen do Result := Result+c;
  end;
end;

{-------------------------------------------------------------------------------
*PadCut
 Pads a character at the end of s while Length(s)<PadLen but allways returns
 the length as specified by PadLen.
 Example:
 PadCut('Warm Breeze',14) > 'Warm Breeze  '
 PadCut('Warm Breeze',-14,'.') > '..Warm Breeze'
 PadCut('Warm Breeze',2,' ') > 'Wa'
See also Pad
-------------------------------------------------------------------------------}
function TStringCollection.PadCut(const s : string;PadLen : SmallInt;c : char = ' ') : string;
begin
  Result := s;
  if PadLen<0 then
  begin
    while Length(Result)<abs(PadLen) do Result := c+Result;
  end else
  begin
    while Length(Result)<PadLen do Result := Result+c;
  end;
  Setlength(Result,abs(PadLen));
end;

{-------------------------------------------------------------------------------
*PadLeft - Pads a character to the left while Length(s)<PadLen.
 PadLeft('hello',7)  > '  hello'
 PadLeft('hello',7,'.')  > '..hello'
Note that function Pad with a negative PadLen is functionally then same.
See also Pad
-------------------------------------------------------------------------------}
function TStringCollection.PadLeft(const s : string;PadLen : Word;c : char = ' ') : string;
begin
  Result := Pad(s,-PadLen,c);
end;

{-------------------------------------------------------------------------------
*BaseToStr - General function for converting binary,hex,octal or a custom base key
 to a string.
  Example1:  Hex (Base 16)
    BaseToStr(255,'0123456789ABCDEF') >'FF'
    Note if i=255 and i is an integer, overloaded BaseStr(i,'0123456789ABCDEF')
     will return '000000FF' (knows it is an 32 bit integer)
  Example2: Binary (Base 2)
    BaseToStr(5,'01',8) > '00000101'
  Example3:  A..Z (Base 26)
    BaseToStr(675,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',4) > 'AAZZ'
  Example4: 0..9,A..V (Base 32)
    BaseToStr(1023,'0123456789ABCDEFGHIJKLMNOPQRSTUV',4) > '00VV'

See also BaseStr,BaseVal,BaseRange,SysUtils.IntToHex
-------------------------------------------------------------------------------}
function TStringCollection.BaseToStr(Value : Cardinal;Key : string;Digits : Byte = 0) : string;
var x    : Cardinal;
    Base : Word;
    w    : Cardinal;
begin
  Result := '';
  try
    Base := length(Key);
    if Base=0 then eRaise('Invalid Key');
    w := Value;
    repeat
      x := w mod Base;
      w := w div Base;
      Result := Key[x+1]+Result;
    until w=0;
    if Digits<>0 then Result := PadCut(Result,-Digits,Key[1]);
  except
    eRaise('Key: '+Key,'BaseToStr');
  end;
end;

{-------------------------------------------------------------------------------
*BaseVal - General function for converting binary,hex,octal or a custom string
 to an integer according to a specified base key.
 See notes at BaseToStr
 Example: BaseVal('FF','0123456789ABCDEF') > 255
 Example: BaseVal('0011','01') > 3
See also BaseToStr,BaseStr,BaseRange
-------------------------------------------------------------------------------}
function TStringCollection.BaseVal(s : string;Key : string) : Cardinal;
var x : Cardinal;
    i : Word;
 Base : Cardinal;
begin
  Result := 0;
  try
    Base := length(Key);
    if Base=0 then eRaise('Invalid Key');
    for i := 1 to length(s) do
    begin
      x := pos(s[i],Key);
      if x=0 then eRaise(Key[i]+' in "'+s+'" not found in Key');
      dec(x);
      Result := (Result*Base)+x;
    end;
  except
    eRaise('Key: '+Key,'BaseVal');
  end;
end;

{-------------------------------------------------------------------------------
*BaseStr - overload function - passes the correct digits according to the
 byte size of Value - Example: BaseStr($F,'0123456789ABCDEF') >'0000000F'
-------------------------------------------------------------------------------}
function TStringCollection.BaseStr(Value : Cardinal;Key : string) : string;
begin
  Result := BaseToStr(Value,key,BaseStrLen(Key,sizeof(Value)));
end;

{-------------------------------------------------------------------------------
*BaseStr - overload function - passes the correct digits according to the
 byte size of Value - Example: BaseStr($F,'0123456789ABCDEF') >'0F'
-------------------------------------------------------------------------------}
function TStringCollection.BaseStr(Value : ShortInt;Key : string) : string;
begin
  Result := BaseToStr(Value,key,BaseStrLen(Key,sizeof(Value)));
end;

{-------------------------------------------------------------------------------
*BaseStr - overload function - passes the correct digits according to the
 byte size of Value - Example: BaseStr($F,'0123456789ABCDEF') >'000F'
-------------------------------------------------------------------------------}
function TStringCollection.BaseStr(Value : SmallInt;Key : string) : string;
begin
  Result := BaseToStr(Value,key,BaseStrLen(Key,sizeof(Value)));
end;

{-------------------------------------------------------------------------------
*BaseStr - overload function - passes the correct digits according to the
 byte size of Value - Example: BaseStr($F,'0123456789ABCDEF') >'000F'
-------------------------------------------------------------------------------}
function TStringCollection.BaseStr(Value : Word;Key : string) : string;
begin
  Result := BaseToStr(Value,key,BaseStrLen(Key,sizeof(Value)));
end;

{-------------------------------------------------------------------------------
*BaseStr - overload function - passes the correct digits according to the
 byte size of Value - Example: BaseStr($F,'0123456789ABCDEF') >'0F'
-------------------------------------------------------------------------------}
function TStringCollection.BaseStr(Value : Byte;Key : string) : string;
begin
  Result := BaseToStr(Value,key,BaseStrLen(Key,sizeof(Value)));
end;

{-------------------------------------------------------------------------------
*BaseStr - overload function - passes the correct digits according to the
 byte size of Value - Example: BaseStr($F,'0123456789ABCDEF') >'0000000F'
-------------------------------------------------------------------------------}
function TStringCollection.BaseStr(Value : integer;Key : string) : string;
begin
  Result := BaseToStr(Value,key,BaseStrLen(Key,sizeof(Value)));
end;

{-------------------------------------------------------------------------------
*BaseStrR - see notes at function BaseToStr.
 This function performs an additional range check.
-------------------------------------------------------------------------------}
function TStringCollection.BaseStrR(Value : Cardinal;Key : string;Digits : Byte) : string;
begin
  if Value>BaseRange(Key,Digits) then eRaise('Value too big for Key/Digits '+gcCR+'Value: '+inttostr(Value),'BaseStrR');
  Result := BaseToStr(Value,Key,Digits);
end;

{-------------------------------------------------------------------------------
*BaseRange - returns the biggest possible integer if using n Digits
 according to a specified base key.
 Example: BaseRange('0123456789ABCDEF',1) > 15  ($f)
 Example: BaseRange('0123456789ABCDEF',2) > 255 ($ff)
 See notes at BaseToStr
--------------------------------------------------------------------------------}
function TStringCollection.BaseRange(Key : string;Digits : Byte) : Cardinal;
begin
  Result := BaseVal(RepeatChar(LastChar(Key),Digits),Key);
end;

{-------------------------------------------------------------------------------
*BaseStrLen - returns the length of a string if a Byte,Word or Cardinal is
 converted to a base string.
 Example: BaseStrLen('0123456789ABCDEF',4) > 8 (Cardinal is 'FFFFFFFF')
 Example: BaseStrLen('01',1) > 8 (Byte is '11111111')
 Example: BaseStrLen('0123',1) > 4 (Byte is '3333')
 Example: BaseStrLen('01',sizeof(Word)) > 16 (Word is '1111111111111111')
--------------------------------------------------------------------------------}
function TStringCollection.BaseStrLen(Key : string;ByteSize : TIntSize) : Byte;
begin
  case ByteSize of
    1 : Result := length(BaseToStr($ff,key));
    2 : Result := length(BaseToStr($ffff,key));
    3 : Result := length(BaseToStr($ffffff,key));
    4 : Result := length(BaseToStr($ffffffff,key));
    else Result := 0;
  end;
end;

{-------------------------------------------------------------------------------
*RepeatChar - Sets a string with a certain character and length.
 Example: RepeatChar('a',3) > 'aaa'
See also RepeatStr
-------------------------------------------------------------------------------}
function TStringCollection.RepeatChar(c : char;Count : integer) : string;
begin
  SetLength(Result,Count);
  FillChar(Result[1],Count,c);
end;

{-------------------------------------------------------------------------------
*RepeatStr - Repeats a string count times.
 Example: RepeatStr('hello',3) > 'hellohellohello'
-------------------------------------------------------------------------------}
function TStringCollection.RepeatStr(const s : string;Count : integer) : string;
var i : integer;
begin
  if Length(s)=1
  then Result := RepeatChar(s[1],count) else
  begin
    Result := '';
    for i := 1 to Count do Result := Result+s;
  end;
end;

{-------------------------------------------------------------------------------
*FirstChar - safe method to get the first character of a string.
 Example: FirstChar('hello world') > 'h'
 Example: FirstChar('') > #0
See also LastChar
-------------------------------------------------------------------------------}
function TStringCollection.FirstChar(const s: string) : char;
begin
  Result := #0;
  if s<>'' then Result := s[1];
end;

{-------------------------------------------------------------------------------
*LastChar - retrurns the last character in a string.
 Example: LastChar('hello world') > 'd'
 Example: LastChar('') > #0
See also FirstChar
-------------------------------------------------------------------------------}
function TStringCollection.LastChar(const s: string) : char;
begin
  Result := #0;
  if s<>'' then Result := s[Length(s)];
end;

{-------------------------------------------------------------------------------
*FirstWord - returns the first word from a string.
 Example: FirstWord('Delphi programming is fun') > 'Delphi'
 Example: FirstWord('Delphi, programming is fun') >'Delphi,'
 Example: FirstWord('Delphi, programming is fun',[' ','.',',']) >'Delphi'
 Example: FirstWord('Delphiprogramming') > 'Delphiprogramming'
See also LastWord
-------------------------------------------------------------------------------}
function TStringCollection.FirstWord(const s: string;Delims : TCharSet = [' ']) : string;
begin
  Result := Before(Delims,s);
end;

{-------------------------------------------------------------------------------
*LastWord - retrurns the last word in a string.
 Example: LastWord('Delphi programming is fun') > 'fun'
 Example: LastWord('Delphiprogramming') > '' 
See also FirstWord
-------------------------------------------------------------------------------}
function TStringCollection.LastWord(const s: string;Delims : TCharSet = [' ']) : string;
begin
  Result := AfterRev(Delims,s);
end;

{-------------------------------------------------------------------------------
*First - Simply returns the first count characters of a string
 Example: First('hello',2) > 'he'
See also Copy,Last,LeftAt,RightAt
-------------------------------------------------------------------------------}
function TStringCollection.First(const s : string;count : integer = 1) : string;
begin
  Result := System.Copy(s,1,count);
end;

{------------------------------------------------------------------------------
*Last - Simply returns the last count characters of a string
 Example: Last('hello',2) > 'lo'
 Example: Last('hello',10) > 'hello'
See also First,Copy,LeftAt,RightAt 
-------------------------------------------------------------------------------}
function TStringCollection.Last(const s : string;count : integer = 1) : string;
begin
  Result := System.Copy(s,(Length(s)-count)+1,Length(s));
end;

{-------------------------------------------------------------------------------
*Strip - Strips leading,trailing and double characters from a string.
 Not the same as the standard Trim function. Where trim strips only leading and
 trailing spaces, this function also strips extra spaces between words.
 Example: Strip('   hello    world  ') > 'hello world'
See also Trim
-------------------------------------------------------------------------------}
function TStringCollection.Strip(const s : string;c : char = ' ') : string;
var
   i,l : integer;
   f   : boolean;
begin
  Result := '';
  l := Length(s);
  i := 1;
  f := true;
  while (i<=l) and (s[i]=c) do Inc(i);
  if i<=l then
  begin
    while s[l]=c do Dec(l);
    for i := i to l do
    begin
      if (s[i]=c) then
      begin
        if f then Result := Result+s[i];f := false;
      end else
      begin
        Result := Result+s[i];
        f := true;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------
*Trim - Strips leading and trailing spaces
  Same as standard Trim function, except the trim character can be specified.
 Example: Trim('   hello    world  ') > 'hello    world'
See also Strip
-------------------------------------------------------------------------------}
function TStringCollection.Trim(const s : string;c : char = ' ') : string;
var i, l: Integer;
begin
  l := Length(s);
  i := 1;
  while (i <= l) and (s[i] <= c) do Inc(i);
  if i > l then Result := '' else
  begin
    while s[l] <= c do Dec(l);
    Result := System.Copy(s, i, l - i + 1);
  end;
end;

{-------------------------------------------------------------------------------
*At - Returns the Nth character in a string - safer than s[x].
 Example:
  if s='hello'
  st.at(s,0)   > #0
  st.at(s,100) > #0
  st.at(s,2)   > 'e'
See also SetAt
-------------------------------------------------------------------------------}
function TStringCollection.At(const s : string;Index : integer) : char;
begin
  if (Index>0) and (Index<=Length(s))
  then Result := s[Index]
  else Result := #0;
end;

{-------------------------------------------------------------------------------
*SetAt - Just a safe way to set a char in a string.
 Instead of s[4] := 'a' use s := SetAt(s,'a',4)
See also At
-------------------------------------------------------------------------------}
function TStringCollection.SetAt(const s : string;const c : char;Index : integer) : string;
begin
  Result := s;
  if (Index=0) or (Index>Length(s)) then exit;
  Result[Index] := c;
end;

{-------------------------------------------------------------------------------
*IsSame
 Returns true if the two strings are identical when leading/trailing and duplicate
 spaces are ignored.
 Example: IsSame('hello','  hello ') > true
 Example: IsSame('hello','  Hello ') > false
See also IsSameIC,IsSameFirst and overloaded Set version
-------------------------------------------------------------------------------}
function TStringCollection.IsSame(const s1,s2 : string;StripChar : char = ' ') : boolean;
begin
  if StripChar<>#0
  then Result := Strip(s1,StripChar)=Strip(s2,StripChar)
  else Result := s1=s2;
end;

{-------------------------------------------------------------------------------
*IsSameIC
 Returns true if the two strings are identical when case and duplicated spaces
 are ignored.
 Example: IsSameIC('Hello',' hello ') > true
 Example: IsSameIC('Hello','hello ',#0) > false
See also IsSame,IsSameFirst and overloaded Set version
-------------------------------------------------------------------------------}
function TStringCollection.IsSameIC(const s1,s2 : string;StripChar : char = ' ') : boolean;
begin
  if StripChar<>#0
  then Result := SysUtils.AnsiCompareText(Strip(s1,StripChar),Strip(s2,StripChar))=0
  else Result := SysUtils.AnsiCompareText(s1,s2)=0;
end;

{-------------------------------------------------------------------------------
*IsSameFirst
 Returns true if the SubStr is the same as the start of the second string, while
 ignoring leading/trailing and double spaces.
 Example: IsSameFirst('hello','hello world') > true
 Example: IsSameFirst('hello world','hello') > false
 Example: IsSameFirst('hello.','.hello.world','.') > true
See also IsSame,IsSameIC,IsSameFirstIC and overloaded set version
-------------------------------------------------------------------------------}
function TStringCollection.IsSameFirst(SubStr,s : string;StripChar : char = ' ') : boolean;
begin
  if StripChar<>#0 then
  begin
    SubStr := Strip(SubStr,Stripchar);
    s := Strip(s,Stripchar);
  end;
  Result := SubStr=System.Copy(s,1,Length(SubStr));
end;

{-------------------------------------------------------------------------------
*IsSameFirstIC
 Returns true if the SubStr is the same as the start of the second string, while
 ignoring Case, leading/trailing and double spaces.
 Example: IsSameFirstIC('Hello','hello world') > true
 Example: IsSameFirstIC('hello world','hello') > false
 Example: IsSameFirstIC('HELLO.','.hello.world','.') > true
See also IsSame,IsSameIC,IsSameFirst and overloaded set version
-------------------------------------------------------------------------------}
function TStringCollection.IsSameFirstIC(SubStr,s : string;StripChar : char = ' ') : boolean;
begin
  if StripChar<>#0 then
  begin
    SubStr := Strip(SubStr,Stripchar);
    s := Strip(s,Stripchar);
  end;
  Result := SysUtils.AnsiCompareText(SubStr,System.Copy(s,1,Length(SubStr)))=0;
end;



{-------------------------------------------------------------------------------
*IsSame
 Returns true if the two strings are identical when all characters are stripped
 as specified by PurgeSet.
 Example: IsSame('hello','12  hello ',[' ','0'..'9']) > true
 Example: IsSame('Hello','12  hello ',[' ','0'..'9']) > false
 See also IsSameIC,IsSameFirst and overloaded char version
-------------------------------------------------------------------------------}
function TStringCollection.IsSame(const s1,s2 : string;PurgeSet : TCharSet) : boolean;
begin
  Result := Purge(s1,PurgeSet)=Purge(s2,PurgeSet);
end;

{-------------------------------------------------------------------------------
*IsSameIC
 Returns true if the two strings are identical when all characters are stripped
 as specified by PurgeSet and case is ignored.
 Example: IsSameIC('Hello','12  hello ',[' ','0'..'9']) > true
See also IsSame,IsSameFirst and overloaded char version
-------------------------------------------------------------------------------}
function TStringCollection.IsSameIC(const s1,s2 : string;PurgeSet : TCharSet) : boolean;
begin
  Result := SysUtils.AnsiCompareText(Purge(s1,PurgeSet),Purge(s2,PurgeSet))=0
end;

{-------------------------------------------------------------------------------
*IsSameFirst
 Returns true if the SubStr is the same as the start of the second string,
 when all characters are stripped as specified by PurgeSet.
 Example: IsSameFirst('hello','12  hello world',[' ','0'..'9']) > true
 Example: IsSameFirst('Hello','12  hello world',[' ','0'..'9']) > false
See also IsSame,IsSameIC,IsSameFirstIC and overloaded char version
-------------------------------------------------------------------------------}
function TStringCollection.IsSameFirst(SubStr,s : string;PurgeSet : TCharSet) : boolean;
begin
  SubStr := Purge(SubStr,PurgeSet);
  s := Purge(s,PurgeSet);
  Result := SubStr=System.Copy(s,1,Length(SubStr));
end;

{-------------------------------------------------------------------------------
*IsSameFirstIC
 Returns true if the SubStr is the same as the start of the second string,
 when case is ignored and all characters are stripped as specified by PurgeSet.
 Example: IsSameFirstIC('Hello','12  hello world',[' ','0'..'9']) > true
See also IsSame,IsSameIC,IsSameFirst and overloade char version
-------------------------------------------------------------------------------}
function TStringCollection.IsSameFirstIC(SubStr,s : string;PurgeSet : TCharSet) : boolean;
begin
  SubStr := Purge(SubStr,PurgeSet);
  s := Purge(s,PurgeSet);
  Result := SysUtils.AnsiCompareText(SubStr,System.Copy(s,1,Length(SubStr)))=0;
end;

{-------------------------------------------------------------------------------
*GetChars - Returns characters as specified by aSet.
 Example: GetChars('123Hallo',['a'..'z']) > 'allo'
 Example: GetChars('123Hallo',['0'..'9']) > '123'
See also CountChars, Purge
-------------------------------------------------------------------------------}
function TStringCollection.GetChars(const s : string;aSet : TCharSet) : string;
var i : integer;
begin
  Result := '';
  for i := 1 to Length(s) do if s[i] in aSet then Result := Result + s[i];
end;

{-------------------------------------------------------------------------------
*CountChars - counts all characters specified by aSet.
 Example: CountChars('123Hallo',['a'..'z']) > 4
 Example: CountChars('123Hallo',['A'..'z']) > 5
See also CountWords, GetChars, Purge
-------------------------------------------------------------------------------}
function TStringCollection.CountChars(const s : string;aSet : TCharSet) : integer;
var i : integer;
begin
  Result := 0;
  for i := 1 to Length(s) do if s[i] in aSet then inc(Result);
end;

{-------------------------------------------------------------------------------
*CountWords - counts all words in a string as delimited by aDelims
 Example: CountWords('hello world') > 2
 Example: CountWords('hello world.hello',[' ','.']) > 3
 Example: CountWords('  hello   world  ',[' ']) > 2
See also CountChars, Replace
-------------------------------------------------------------------------------}
function TStringCollection.CountWords(const s : string;aDelims : TCharSet = [' ',#9,#10,#13]) : integer;
var     i : integer;
   Status : word;
begin
  Result := 0;
  Status := 0;
  for i := 1 to length(s) do
  begin
    if s[i] in aDelims then
    begin
      if Status<>2 then inc(Result);
      Status := 2;
    end else Status:=1;
  end;
  if Status = 1 then inc(Result);
end;


{-------------------------------------------------------------------------------
*GetChars - returns single (unique Set like) characters sorted.
 Example: GetSingle('hhwwwhhaw') > 'ahw'
 Example: GetSingle('hhwwwhhaw','123h') > '123ahw'
-------------------------------------------------------------------------------}
function TStringCollection.GetSingle(const s1 : string;s2 : string = '') : string;
var i : integer;
   cs : TCharSet;
begin
  Result := '';
  cs:=[];
  for i := 1 to Length(s1) do cs:=cs+[s1[i]];
  for i := 1 to Length(s2) do cs:=cs+[s2[i]];
  Result:=Str(cs);
end;

{-------------------------------------------------------------------------------
*Purge - Removes all characters from s that are contained in aSet.
 Example: Purge('helloWORLD123Hello',['a'..'z']) --> 'WORLD123H'
 Example: Purge('helloWORLD123Hello',['A'..'z']) --> '123' 
See also overloaded char version, GetChars
-------------------------------------------------------------------------------}
function TStringCollection.Purge(const s : string;aSet : TCharSet) : string;
var i : integer;
begin
  Result := '';
  for i := 1 to Length(s) do
  begin
    if s[i] in aSet then else Result := Result+s[i];
  end;
end;

{-------------------------------------------------------------------------------
*Purge - Removes a character from a string
 Example: Purge('hello world',' ') --> 'helloworld'
See also overloaded TCharSet version
-------------------------------------------------------------------------------}
function TStringCollection.Purge(const s : string;aChar : char) : string;
begin
  Result := Purge(s,[aChar]);
end;

{-------------------------------------------------------------------------------
*PurgeWhile
 This function purges characters contained in aSet from the left until
 it encounters a character not found in the set.
 Example: PurgeWhile('helloWORLDhello',['a'..'z']) > 'WORLDhello'
See also PurgeWhileRev,PurgeWhileOuter
-------------------------------------------------------------------------------}
function TStringCollection.PurgeWhile(const s : string;aSet : TCharSet) : string;
var i : integer;
begin
  Result := '';
  for i := 1 to Length(s) do
  begin
    if s[i] in aSet then else
    begin
      Result := System.Copy(s,i,Length(s));
      break;
    end;
  end;
end;

{-------------------------------------------------------------------------------
*PurgeWhileRev
 This function purges characters contained in aSet from the right util
 it encounters a character not found in the set.
 Example: PurgeWhileRev('helloWORLDhello',['a'..'z']) > 'helloWORLD'
See also PurgeWhile,PurgeWhileOuter
-------------------------------------------------------------------------------}
function TStringCollection.PurgeWhileRev(const s : string;aSet : TCharSet) : string;
var i : integer;
begin
  Result := '';
  for i := Length(s) downto 1 do
  begin
    if s[i] in aSet then else
    begin
      Result := System.Copy(s,1,i);
      break;
    end;
  end;
end;

{-------------------------------------------------------------------------------
*PurgeWhileOuter - a combination of functions PurgeWhile and PurgeWhileRev.
 It first returns characters from the left while they are not found in aSet,
 then repeats the process from the right.
 Example: PurgeWhileOuter('helloWORLDxWORLDhello',['a'..'z']) > 'WORLDxWORLD'
 Example: PurgeWhileOuter('123letters45letters',['A'..'z']) > '123letters45'
See also PurgeWhile,PurgeWhileRev
-------------------------------------------------------------------------------}
function TStringCollection.PurgeWhileOuter(const s : string;aSet : TCharSet) : string;
begin
  Result := PurgeWhileRev(PurgeWhile(s,aSet),aSet);
end;

{-------------------------------------------------------------------------------
*Rev - Reverses the order of the characters in a string.
 Example: Rev('ABC') > 'CBA'
-------------------------------------------------------------------------------}
function TStringCollection.Rev(const s : string) : string;
var i : integer;
begin
  SetLength(Result,Length(s));
  for i := 1 to Length(s) do Result[(Length(s)-i)+1] := s[i];
end;

{-------------------------------------------------------------------------------
*Sort - Sorts the characters in a string.
 Example: Sort('hello') > 'ehllo'
-------------------------------------------------------------------------------}
function TStringCollection.Sort(const s : string) : string;
   procedure QuickSort(L, R: integer);
   var
     I, J: integer;
     c, t: char;
   begin
     repeat
       I := L;
       J := R;
       c := Result[(L+R) shr 1];
       repeat
         while Result[I]<c do Inc(I);
         while Result[J]>c do Dec(J);
         if I<=J then
         begin
           t := Result[I];
           Result[I] := Result[J];
           Result[J] := t;
           Inc(I);
           Dec(J);
         end;
       until I>J;
       if L<J then QuickSort(L, J);
       L := I;
     until I>=R;
   end;
begin
  Result := s;
  if Length(Result)<2 then exit;
  QuickSort(1,Length(Result));
end;


{-------------------------------------------------------------------------------
*Str - Converts boolean to a string.
 Example: Str(false) > 'False'
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : boolean) : string;
begin
  if Value then Result := 'True' else Result := 'False';
end;

{-------------------------------------------------------------------------------
*Str - Converts TCharSet to a string.
 Example:
  Str(['a'..'z') > 'abcdefghijklmnopqrstuvwxyz'
  Str(['a'..'z',true) > 'a..z'
See also ToSet, CharSetToVisualStr
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : TCharSet;AsVisual : boolean = false) : string;
var i : char;
begin
  if AsVisual then result:=CharSetToVisualStr(Value) else
  begin
    Result := '';
    for i := #0 to #255 do if i in Value then Result := Result+i;
  end;
end;

{-------------------------------------------------------------------------------
*Str - Converts an integer to a string.
 Identical to standard function IntToStr, but slightly faster.
 Example: Str(12) > '12'
See also the overloaded integer Str version with padding.
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : integer) : string;
begin
  System.Str(Value:0,result);
end;

{-------------------------------------------------------------------------------
*Str
 Converts an integer to string and pads it left to ensure a Length of PadLen.
 If the conversion Result is >PadLen then PadLen is ignored.
 Example: Str(12) > '12'
 Example: Str(12,6) > '000012'
 Example: Str(12,5,' ') > '   12'
 If PadLen=0 then no padding is performed
 If PadLen is negative then the padding will be done to the right.
 Example: Str(12,-5,' ') > '12   '

See also FormatSize, ToI
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : integer;PadLen : SmallInt;PadChar : char = '0') : string;
begin
  System.Str(Value,Result);
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar);
end;

{------------------------------------------------------------------------------
 See notes at the integer version of the function
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : Int64;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  try
    Result := SysUtils.IntToStr(Value);
  except
  end;
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar);
end;

{-------------------------------------------------------------------------------
 See notes at the integer version of the function
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : Cardinal;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  System.Str(Value,Result);
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar);
end;

{-------------------------------------------------------------------------------
 See notes at the integer version of the function
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : Byte;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  System.Str(Value,Result);
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar);
end;

{-------------------------------------------------------------------------------
 See notes at the integer version of the function
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : SmallInt;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  System.Str(Value,Result);
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar);
end;

{-------------------------------------------------------------------------------
 See notes at the integer version of the function
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : Word;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  System.Str(Value,Result);
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar);
end;

{-------------------------------------------------------------------------------
*Str - Extended
 Converts a float to string and pads it left to ensure a length of n.
 If the conversion Result is >n then n is ignored
 If n is negative the padding is done to the right
 The Result will allways have two decimal places and a max of 5
 Example: Str(12,8)       > '00012.00'
 Example: Str(12.1,8)     > '00012.10'
 Example: Str(12.123,8)   > '0012.123'
 Example: Str(12.123,2)   > '12.123'
 Example: Str(12.123,-8)  > '12.12300'
 Example: Str(12.1,8,'x') > 'xxx12.10'
See also System.CurrToStrF
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : Extended;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  try
    Result := SysUtils.FormatFloat('0.00###',Value);
  except
    Result := '';
  end;
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar)
end;

{-------------------------------------------------------------------------------
 Please see notes at the Extended version of the function
See also StrFloat
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : double;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  try
    Result := SysUtils.FormatFloat('0.00###',Value);
  except
   Result := '';
  end;
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar)
end;


{-------------------------------------------------------------------------------
*Str - Currency
 TCurrency is defined as a record type to allow function overloading with Double
 and TDateTime values.
 If not used use function StrCur
See notes at function StrCur
-------------------------------------------------------------------------------}
function TStringCollection.Str(Value : TCurrency;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  try
    Result := SysUtils.FormatFloat('0.00',Value.c);
  except
    Result := '';
  end;
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar)
end;

{-------------------------------------------------------------------------------
*StrFloat - float to string
 Example:
  StrFloat(   23.1)                   > '23.10'
  StrFloat(   23.123456)              > '23.12346'
  StrFloat(   23.12345,'#,##0.00',12) > '       23.12'
  StrFloat(12323.12345,'#,##0.00',12) > '   12,323.12'
See also double,extended Str overloaded functions
-------------------------------------------------------------------------------}
function TStringCollection.StrFloat(Value : extended;aFormatStr : string = '0.00###'; Padlen : SmallInt = 0;PadChar : char = ' ') : string;
begin
  try
    Result := SysUtils.FormatFloat(aFormatStr,Value);
  except
    Result := '';
  end;
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar)
end;


{-------------------------------------------------------------------------------
*StrCur -
 Converts a Currency value to a string and pads it left to ensure a length of n.
 If the conversion Result is >n then n is ignored.
 If n is negative the padding is done to the right.
 Example: StrCur(12,8)       > '00012.00'
 Example: StrCur(12.1,8)     > '00012.10'
 Example: StrCur(12.1,8,'x') > 'xxx12.10'
See also Str,System.CurrToStF
--------------------------------------------------------------------------------}
function TStringCollection.StrCur(Value : Currency;PadLen : SmallInt = 0;PadChar : char = '0') : string;
begin
  try
    Result := SysUtils.FormatFloat('0.00',Value);
  except
    Result := '';
  end;
  if PadLen<>0 then Result := Pad(Result,-PadLen,PadChar)
end;

{-------------------------------------------------------------------------------
*StrDate - Date to String
  Identical to the standard DateToStr function which uses the system
  ShortDateFormat global variable.

  Example: StrDate(now) > '21/03/2000' (output depends on ShortDateFormat)
See also overloaded StrDate with format param, StrDateTime
-------------------------------------------------------------------------------}
function TStringCollection.StrDate(Value: TDateTime): string;
begin
  result:=SysUtils.DateToStr(Value);
end;


{-------------------------------------------------------------------------------
*StrDate - Date to string with user defined formatting.

  Example: StrDate(now,'ddd dd-mmm-yyyy') > 'Wed 22-Mar-2000;
  You can also specify the time:

  Note that the format versions of StrDate and StrDateTime are identical:
  Example: StrDate(now,'hh:mm ddd dd-mm-yyyy') > '15:01 Wed 22-03-2000'


See also overloaded StrDate without the format param, StrDateTime
-------------------------------------------------------------------------------}
function TStringCollection.StrDate(Value: TDateTime;aDateFormat: string): string;
begin
  SysUtils.DateTimeToString(Result, aDateFormat, Value);
end;

{-------------------------------------------------------------------------------
*StrDateTime - Date and Time to string uses system formats.
  Identical to the standard DateTimeToStr function which uses the system
  ShortDateFormat and LongTimeFormat global variables.

  Example: StrDateTime(now) > '21:40 12 June 2000' (output depends on system defined format)
See also overloaded StrDate with format param, StrDateTime
-------------------------------------------------------------------------------}
function TStringCollection.StrDateTime(Value: TDateTime): string;
begin
  result:=SysUtils.DateTimeToStr(Value);
end;

{-------------------------------------------------------------------------------
*StrDateTime - Date/Time to string with user defined formatting.
  Example: StrDate(now,'hh:mm ddd dd-mm-yyyy') > '15:01 Wed 22-03-2000'

  Note that the format versions of StrDate and StrDateTime are identical:
  Example: StrDate(now,'ddd dd-mmm-yyyy') > 'Wed 22-Mar-2000;

See also overloaded StrDateTime without the format param, StrDate
-------------------------------------------------------------------------------}
function TStringCollection.StrDateTime(Value: TDateTime;aDateFormat: string): string;
begin
  SysUtils.DateTimeToString(Result, aDateFormat, Value);
end;




{-------------------------------------------------------------------------------
*ReplaceFirst
 The function starts at position StartAt and searches for the first occurence of
 FindStr in InStr and replaces it with ReplaceAllStr.
 If the FindStr was found StartAt will be advanced else it will be 0.
 Example:
 p := 1;
 s := ReplaceFirst('dog','cat','The dog sleeps',true,false,[' ']p) will
 GetChars 'The cat sleeps';
 Note: function Replace replaces all occurences.
See also Replace
-------------------------------------------------------------------------------}
function TStringCollection.ReplaceFirst(FindStr,ReplaceAllStr,InStr : string;
                            Wholeword,CaseSensitive : boolean;
                            Delims : TCharSet;var StartAt : integer ) : string;
   function Whole : boolean;
   var x : integer;
   begin
     Result := True;
     if WholeWord=False then Exit;
     if StartAt>1 then
     begin
       if ((instr[StartAt-1] in Delims) or (Delims=[])) then else
       begin
         Whole := false;
         exit;
       end;
     end;
     x := StartAt+Length(FindStr);
     if x<=Length(instr) then
     begin
       if ((instr[x] in Delims) or (Delims=[])) then else
       begin
         Whole := false;
         exit;
       end;
     end;
   end;

var doit : boolean;
begin
  if StartAt=0 then StartAt := 1;
  Repeat
    doit := false;
    if CaseSensitive=false
    then StartAt := Pos(AnsiUpperCase(FindStr),AnsiUpperCase(instr),StartAt)
    else StartAt := Pos(FindStr,instr,StartAt);
    if StartAt>0 then
    begin
      DoIt := Whole;
      if DoIt=false then inc(StartAt);
    end;
  Until (StartAt=0) or (DoIt);
  if (DoIt) and (StartAt>0) then
  begin
    Result := System.Copy(instr,1,StartAt-1)+ReplaceAllStr+System.Copy(instr,StartAt+Length(FindStr),$FFF0);
    StartAt := StartAt+Length(ReplaceAllStr);
  end else
  begin
    Result := instr;
    StartAt := 0;
  end;
end;

{-------------------------------------------------------------------------------
*Replace - Calls ReplaceFirst repeatedly and replaces all occurences.
See also overloaded function below 
-------------------------------------------------------------------------------}
function TStringCollection.Replace(FindStr,ReplaceWith,InStr : string;
        WholeWord,CaseSensitive : boolean;Delims : TCharSet = [' ']) : string;
var p : integer;
begin
  p := 1;
  Result := InStr;
  while p>0 do
  begin
    Result := ReplaceFirst(FindStr,ReplaceWith,Result,WholeWord,CaseSensitive,Delims,p);
  end;
end;


{-------------------------------------------------------------------------------
*Replace - Simple version of Replace (no Delimiters and case senstive)
 Example : Replace('dog','cat','The dog is Dogmeat') > 'The cat is Dogmeat'
 Example : Replace('Dog','cat','The dog is Dogmeat') > 'The dog is catmeat'
See also ReplaceFirst
-------------------------------------------------------------------------------}
function TStringCollection.Replace(FindStr,ReplaceWith,InStr : string) : string;
begin
  Result := Replace(FindStr,ReplaceWith,InStr,false,true,[]);
end;

{-------------------------------------------------------------------------------
*ReplaceChars
 Replaces all the occurences of OldChars with NewChar.
 Example:
  s := 'Replace e and a with *';
  ReplaceChars(s,['e','a'],'*') returns 'R*pl*c* * *nd * with *';
-------------------------------------------------------------------------------}
function TStringCollection.ReplaceChars(const s : string;OldChars: TCharSet;NewChar : char) : string;
var i : integer;
begin
  Result := s;
  for i := 1 to Length(Result) do
  begin
    if Result[i] in OldChars then Result[i] := newChar;
  end;
end;

{-------------------------------------------------------------------------------
*DelIfLast - Deletes SubStr from s if it is the last text.
 Example: DelIfLast('last','You are last') > 'You are '
 Example: DelIfLast('last','You are last.') > 'You are last.'
See also DelIfFirst and TCharSet overloaded version
-------------------------------------------------------------------------------}
function TStringCollection.DelIfLast(const SubStr,s : string) : string;
begin
  if IsLast(SubStr,s)
  then Result := System.Copy(s,1,length(s)-length(SubStr))
  else Result := s;
end;

{-------------------------------------------------------------------------------
*DelIfFirst - Deletes SubStr from s if it is the first text.
 Example: DelIfFirst('first','first text') > ' text'
 Example: DelIfFirst('*first','first text') > '*first text' 
See also DelIfLast and TCharSet overloaded version
-------------------------------------------------------------------------------}
function TStringCollection.DelIfFirst(const SubStr,s : string) : string;
begin
  if System.Copy(s,1,Length(SubStr))=SubStr
  then Result := System.Copy(s,length(SubStr)+1,length(s))
  else Result := s;
end;

{-------------------------------------------------------------------------------
*DelIfLast - Deletes the last character in s if it is in IfInSet
 Example: DelIfLast(['.'],'hello') -->'hello'
 Example: DelIfLast(['.'],'hello') -->'hello'
 Example: DelIfLast(['.','']) -->''
-------------------------------------------------------------------------------}
function TStringCollection.DelIfLast(IfInSet : TCharSet;const s : string) : string;
begin
  Result := s;
  if Result='' then exit;
  if Result[Length(Result)] in IfInSet then Setlength(Result,Length(Result)-1);
end;

{-------------------------------------------------------------------------------
*DelIfFirst - Deletes the first character in s if it is in IfInSet
 Example: DelIfFirst(['.'],'hello') -->'hello'
 Example: DelIfFirst(['.'],'.hello') -->'hello'
--------------------------------------------------------------------------------}
function TStringCollection.DelIfFirst(IfInSet : TCharSet;const s : string) : string;
begin
  if s='' then Result := s else
  begin
    if s[1] in IfInSet then Result := System.Copy(s,2,Length(s)) else Result := s;
  end;
end;

{-------------------------------------------------------------------------------
*Del - Deletes a SubStr from s.
 Example: Del('the','the moon is the light') > ' moon is   light';
--------------------------------------------------------------------------------}
function TStringCollection.Del(const SubStr,s : string): string;
begin
  Result := s;
  while Pos(SubStr,Result) > 0 do
  begin
    if Pos(SubStr,Result)=1
     then Result := System.Copy(Result,Length(SubStr)+1,Length(Result))
     else Result := System.Copy(Result,1,Pos(SubStr,Result)-1)+System.Copy(Result,Pos(SubStr,Result)+Length(SubStr),Length(Result));
  end;
end;

{-------------------------------------------------------------------------------
*IsLast - Returns true if SubStr is at the end of s.
 Example: IsLast('.txt','file.txt') > True
See also IsFirst,DelIfLast
-------------------------------------------------------------------------------}
function TStringCollection.IsLast(const SubStr,s : string) : boolean;
begin
  if length(SubStr)>length(s)
  then Result := false
  else Result := System.Copy(s,(length(s)+1)-length(SubStr),length(SubStr))=SubStr;
end;

{-------------------------------------------------------------------------------
*Cut - Deletes the characters defined by Index and Count from s and returns the
 deleted portion.
 Example: Cut('hello',2,2 ) > 'el'   'hello' > 'hlo';
-------------------------------------------------------------------------------}
function TStringCollection.Cut(var s : string; Index, Count : integer) : string;
begin
	Result := System.Copy(s,Index,Count);
  Delete(s,Index,Count );
end;

{-------------------------------------------------------------------------------
*Copy - Same as the standard Copy function.
 Example: Copy('ABCDEF', 2, 3) > 'BCD'
See also First,Last
-------------------------------------------------------------------------------}
function TStringCollection.Copy(const s : string; Index, Count : integer) : string;
begin
	Result := System.Copy(s,Index,Count);
end;

{-------------------------------------------------------------------------------
*Ins - function version of standard insert procedure.
 Example: Ins('a','1234',2) > '1a234'
 Example: Ins('a','1234',200) > '1234a'
-------------------------------------------------------------------------------}
function TStringCollection.Ins(const SubStr,s : string; Index : integer) : string;
begin
  Result := s;
	System.Insert(SubStr,Result,Index);
end;

{-------------------------------------------------------------------------------
*IsShortString - Returns true if string parameter is of ShortString type.
 If declaration; var s1 : string[20], s2 : string then:
 IsShortString([s1]) > true
 IsShortString([s2]) > false
-------------------------------------------------------------------------------}
function TStringCollection.IsShortString(s : array of const) : boolean;
begin
  with s[0] do Result := vtype=vtstring; //long is vtAnsiString
end;

{-------------------------------------------------------------------------------
*ToI - string to integer
 No error checking - Strips all non integer characters.
 Example: ToI(' 5') > 5
See also ToL,ToI64,Val
-------------------------------------------------------------------------------}
function TStringCollection.ToI(const s : string) : integer;
var e : integer;
begin
  System.Val(GetChars(s,gcIntCharSet),Result,e);
end;

{-------------------------------------------------------------------------------
*ToL - string to Cardinal/Longword - no error checking
 Strips all non integer characters.
 Example: ToL('4294967295') >  4294967295  (unsigned 32 bit max Value)
See also ToI,ToI64,Val
-------------------------------------------------------------------------------}
function TStringCollection.ToL(const s : string) : Cardinal;
var e : integer;
begin
  System.Val(GetChars(s,gcIntCharSet),Result,e);
end;

{-------------------------------------------------------------------------------
*ToI64 - string to 64bit integer, removes all non integer characters first.
 Example: ToI64('4294967295') >  4294967295  (unsigned 32 bit max Value)
 Example: ToI64('hello4294967295') >  4294967295
See also ToI,Val
-------------------------------------------------------------------------------}
function TStringCollection.ToI64(const s : string) : Int64;
begin
  Result := StrToInt64(GetChars(s,gcIntCharSet));
end;

{-------------------------------------------------------------------------------
*ToC - string to Currency, removes all non numeric characters first.
 Example: ToC(' 5.5') > 5.5
See also procedure Val
-------------------------------------------------------------------------------}
function TStringCollection.ToC(const s : string) : Tcurrency;
begin
  try
    Result.c := StrToCurr(GetChars(s,gcNumCharSet));
  except
    Result.c := 0.0;
  end;
end;

{-------------------------------------------------------------------------------
*ToF - string to Float - No error checking, removes all non float characters first.
 Example: ToF(' 5.125') > 5.125
See also procedure Val
-------------------------------------------------------------------------------}
function TStringCollection.ToF(const s : string) : Extended;
begin
  try
    Result := StrToFloat(GetChars(s,gcFloatCharSet));
  except
    Result := 0.0;
  end;
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : integer);
begin
  Value := ToI(s);
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : Cardinal);
begin
  Value := ToI(s);
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : Word);
begin
  Value := ToI(s);
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : Int64);
begin
  Value := ToI64(s);
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : SmallInt);
begin
  Value := ToI(s);
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : Byte);
begin
  Value := ToI(s);
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : double);
begin
  Value := ToF(s);
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : Extended);
begin
  Value := ToF(s);
end;

{-------------------------------------------------------------------------------
*Val - string to numeric - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : TCurrency);
begin
  Value := ToC(s);
end;

{-------------------------------------------------------------------------------
*Val - string to TCharSet - overloaded procedure
See also CharSetToVisualStr
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : TCharSet;FromVisualSet : boolean = false);
begin
  Value := ToSet(s,FromVisualSet);
end;

{-------------------------------------------------------------------------------
*Val - string to boolean - overloaded procedure
-------------------------------------------------------------------------------}
procedure TStringCollection.Val(const s : string;var Value : boolean);
begin
  Value := ToBool(s);
end;

{-------------------------------------------------------------------------------
*AZUpCase - String to uppercase - converts only characters a..z
 Example: AZUpCase('Polé') > 'POLé'
See also UpCase
-------------------------------------------------------------------------------}
function TStringCollection.AZUpCase(const s : string) : string;
var i : integer;
begin
  Result := s;
  for i := 1 to length(s) do if s[i] in ['a'..'z'] then Result[i] := char(byte(s[i])-32);
end;

{-------------------------------------------------------------------------------
*AZLoCase - String to lowercase - converts only characters A..Z
 Example: AZLoCase('POLÉ') > 'polÉ'
See also LoCase
-------------------------------------------------------------------------------}
function TStringCollection.AZLoCase(const s : string) : string;
var i : integer;
begin
  Result := s;
  for i := 1 to length(s) do if s[i] in ['A'..'Z'] then Result[i] := char(byte(s[i])+32);
end;

{-------------------------------------------------------------------------------
*AZUpCase - char upcase -  converts only characters a..z
 Example: AZUpCase('e') > 'E'
See also UpCase
-------------------------------------------------------------------------------}
function TStringCollection.AZUpCase(c : char) : char;
begin
  if c in ['a'..'z']
  then Result := char(byte(c)-32)
  else Result := c;
end;

{-------------------------------------------------------------------------------
*AZLoCase - char locase - converts only characters A..Z
 Example: AZLoCase('Z') > 'z'
See also LoCase
-------------------------------------------------------------------------------}
function TStringCollection.AZLoCase(c : char) : char;
begin
  if c in ['A'..'Z']
  then Result := char(byte(c)+32)
  else Result := c;
end;

{-------------------------------------------------------------------------------
*LeftAt
 Simple function that returns all chars to the left from a specific (including) Position
 Example: LeftAt('hello',2) > 'he'
See also RightAt,Copy,First,Last
-------------------------------------------------------------------------------}
function TStringCollection.LeftAt(const s : string;Position : integer) : string;
begin
  Result := System.Copy(s,1,Position);
end;

{-------------------------------------------------------------------------------
*RightAt
 Simple function that returns all chars to the right from a specific (including) Position
 Example: RightAt('hello',2) > 'ello'
See also LeftAt,Copy,First,Last
-------------------------------------------------------------------------------}
function TStringCollection.RightAt(const s : string;Position : integer) : string;
begin
  Result := System.Copy(s,Position,length(s));
end;

{-------------------------------------------------------------------------------
*Center - Centers text in a string of length Len
 Example: Center('ok',6) > '  ok  '
-------------------------------------------------------------------------------}
function TStringCollection.Center(const s: string; Len: integer; PadChar : char = ' '): string;
begin
  if Length(s) < Len then
  begin
    Result := RepeatChar(PadChar,(Len div 2) - (Length(s) div 2))+s;
    Result := Result + RepeatChar(PadChar,Len - Length(Result));
  end else Result := s;
end;


{-------------------------------------------------------------------------------
*HasWord - Returns true if a word is found in a string
 Example: HasWord('close','open close print') > true
 Example: HasWord('close','openclose print') > False
See also HasWordIC
-------------------------------------------------------------------------------}
function TStringCollection.HasWord(const word,s : string) : boolean;
begin
  Result := WordPos(word,s)>0;
end;

{-------------------------------------------------------------------------------
*HasWordIC - Returns true if a word is found in a string irrespective of case
 Example: HasWordIC('Close','open close print') > true
 Example: HasWordIC('Close','openclose print') > false
See also HasWord
-------------------------------------------------------------------------------}
function TStringCollection.HasWordIC(const word,s : string) : boolean;
begin
  Result := WordPos(UpCase(word),UpCase(s))>0;
end;

{-------------------------------------------------------------------------------
*HasChar - Returns true if c in s.
 Example: HasChar('a','jazz') > true
See also HasCharIC and set version
-------------------------------------------------------------------------------}
function TStringCollection.HasChar(c: char; const s: string) : boolean;
begin
  Result := System.Pos(c,s)>0;
end;

{-------------------------------------------------------------------------------
*HasChar - Returns true if any character in aSet is found in s.
 Example: HasChar(['a'],'jazz') > true
See also HasCharIC and char version
-------------------------------------------------------------------------------}
function TStringCollection.HasChar(aSet : TCharSet; const s : string) : boolean;
var i : integer;
begin
  Result := false;
  for i:=1 to length(s) do if s[i] in aSet then
  begin
    Result := true;
    break;
  end;
end;

{-------------------------------------------------------------------------------
*HasCharIC - Returns true if c in s irrespective of case.
 Example: HasCharIC('A','jazz') > true
See also HasChar
-------------------------------------------------------------------------------}
function TStringCollection.HasCharIC(c: char; const s: string): boolean;
begin
  Result := System.Pos(upcase(c),UpCase(s))>0;
end;

{-------------------------------------------------------------------------------
*Before
 This function returns the string to the left of the first character found in aSet
 Example: Before(['e','l'],'Those Funny People') > 'Thos'
 Example: Before(['z'],'Those Funny People') > 'Those Funny People'
See also overload string version, After
-------------------------------------------------------------------------------}
function TStringCollection.Before(const aSet : TCharSet;const s : string) : string;
var i : integer;
begin
  for i := 1 to length(s) do
  begin
    if s[i] in aSet then
    begin
      Result := System.Copy(s,1,i-1);
      exit;
    end;
  end;
  Result := s;
end;

{-------------------------------------------------------------------------------
*BeforeRev
 This function returns the string to the left of the first character found in aSet
 when scanning from right to left
 Example: BeforeRev(['e','l'],'Those Funny People') > 'Those Funny Peopl'
 Example: BeforeRev(['z'],'Those Funny People') > 'Those Funny People
See also overload string version
-------------------------------------------------------------------------------}
function TStringCollection.BeforeRev(const aSet : TCharSet;const s : string) : string;
var i : integer;
begin
  for i := length(s) downto 1 do
  begin
    if s[i] in aSet then
    begin
      Result := System.Copy(s,1,i-1);
      exit;
    end;
  end;
  Result := s;
end;

{-------------------------------------------------------------------------------
*After
 This function returns the string to the right of the first character found in aSet
 Example: After(['e','l'],'Those Funny People') > ' Funny People'
 Example: After(['z'],'Those Funny People') > ''
See also AfterRev,Before, and overloaded string versions
-------------------------------------------------------------------------------}
function TStringCollection.After(const aSet : TCharSet;const s : string) : string;
var i : integer;
begin
  for i := 1 to length(s) do
  begin
    if s[i] in aSet then
    begin
      Result := System.Copy(s,i+1,length(s));
      exit;
    end;
  end;
  Result := '';
end;

{-------------------------------------------------------------------------------
*AfterRev
 This function returns the string to the right of the first character found in aSet
 when scanning right to left
 Example: AfterRev(['e','l'],'Those Funny People') > ''
 Example: AfterRev(['l'],'Those Funny People') > 'e'
 Example: AfterRev(['z'],'Those Funny People') > ''
See also After,Before and overload string versions
-------------------------------------------------------------------------------}
function TStringCollection.AfterRev(const aSet : TCharSet;const s : string) : string;
var i : integer;
begin
  for i := length(s) downto 1 do
  begin
    if s[i] in aSet then
    begin
      Result := System.Copy(s,i+1,length(s));
      exit;
    end;
  end;
  Result := '';
end;

{-------------------------------------------------------------------------------
*ToSet - string to TCharSet
 Example: ToSet('CBA') > ['A'..'C']
 Example: ToSet('a..z',true) > ['a'..'z']
See also overloaded Str TCharSet version
-------------------------------------------------------------------------------}
function TStringCollection.ToSet(const s : string;FromVisualSet : boolean = false) : TCharset;
var i : integer;
begin
  if FromVisualSet then Result:=VisualStrToCharSet(s) else
  begin
    Result := [];
    for i := 1 to Length(s) do Result := Result+[s[i]];
  end;
end;

{-------------------------------------------------------------------------------
*ToBool - string to boolean
 Example: ToBool('true') > true
 Example: ToBool('y') > true
See also overloaded Str TCharSet version
-------------------------------------------------------------------------------}
function TStringCollection.ToBool(const s : string) : boolean;
begin
  if s=''
  then result:=false
  else result:=s[1] in gcBooleanTrueSet;
end;

{-------------------------------------------------------------------------------
*FormatSize - integer to string with thousand separator
 Example: FormatSize(23000) > '23,000'
 Uses system global variable ThousandSeparator
See also Int64 overloaded version
-------------------------------------------------------------------------------}
function TStringCollection.FormatSize(Size : Cardinal) : String;
var i : Integer;
    p : Integer;
begin
  p := 0;
  i := 3;
  Result := IntToStr(Size);
  while i + p < Length(Result) do
  begin
    Insert(ThousandSeparator, Result, Length(Result) - (i + p)+ 1);
    Inc(p);
    inc(i, 3);
  end;
end;

{-------------------------------------------------------------------------------
*FormatSize
See cardinal overloaded version
-------------------------------------------------------------------------------}
function TStringCollection.FormatSize(Size : Int64) : string;
var i : Integer;
    p : Integer;
begin
  p := 0;
  i := 3;
  Result := IntToStr(Size);
  while i + p < Length(Result) do
  begin
    Insert(ThousandSeparator, Result, Length(Result) - (i + p)+ 1);
    inc(p);
    inc(i, 3);
  end;
end;

{-------------------------------------------------------------------------------
*FormatSize
See cardinal overloaded version
-------------------------------------------------------------------------------}
function TStringCollection.FormatSize(Size : word) : String;
begin
  Result := FormatSize(Cardinal(ABS(Size)));
end;

{-------------------------------------------------------------------------------
*FormatSize
See cardinal overloaded version
-------------------------------------------------------------------------------}
function TStringCollection.FormatSize(Size : Integer) : String;
begin
  Result := FormatSize(Cardinal(ABS(Size)));
end;

{-------------------------------------------------------------------------------
*SlashAdd - add's a slash (typically a file/path name) at the end if needed
 Example: SlashAdd('c:\windows') > 'c:\windows\'
 Example: SlashAdd('c:\windows\') > 'c:\windows\'
See also SlashDel
-------------------------------------------------------------------------------}
function TStringCollection.SlashAdd(const s : String) : string;
begin
  if (Length(s) > 0) and (s[Length(s)] <> '\')
  then Result:=s+'\'
  else Result:=s;
end; {AddSlash}

{-------------------------------------------------------------------------------
*SlashDel- removes a slash (typically a file/path name) if at end.
 Example: SlashDel('c:\windows') > 'c:\windows'
 Example: SlashDel('c:\windows\') > 'c:\windows'
See also SlashAdd
-------------------------------------------------------------------------------}
function TStringCollection.SlashDel(const s : String) :string;
begin
  if (Length(s) > 0) and (S[Length(s)] = '\')
  then Result := System.Copy(s, 1, Pred(Length(s)))
  else Result := s;
end; {RemoveSlash}

{-------------------------------------------------------------------------------
*Parse - Extracts words,characters between delimiters.
 This function relies on After and Before; its Result is the string after
 SubStr, and before the next SubString. String S is thereafter
 reduced to : s -/- first substr -/- resulting string.
 Code by Reinder de Jager
 Example:
    s := '-a-b-c';
    while s<>'' do
    begin
      param := sc.parse('-',s);
      memo1.Lines.Add(param); //do what you want with param
    end;
    Memo Result: lines 'a','b','c'
See also the overloaded Set-version and After,Before
-------------------------------------------------------------------------------}
function TStringCollection.Parse(const SubStr : string;var s : string;Position: Cardinal = 0): string;
var temp : string;
begin
  if IsSameFirst(SubStr,s)
  then temp:=After(SubStr,s,Position)
  else temp:=s;

  Result:=Before(SubStr,temp,Position);
  s := DelIfFirst(Result,temp);
end;

{-------------------------------------------------------------------------------
*Parse - Extracts words,characters between delimiters.
 Code by Reinder de Jager
 Example:
    s := 'please,extract words;between delims.';
    while s<>'' do
    begin
      param := sc.parse([';',' ','.',','],s);
      memo1.Lines.Add(param); //do what you want with param
    end;
See also overloaded String version
-------------------------------------------------------------------------------}
function TStringCollection.Parse(const aSet: TCharSet;var s: string): string;
var temp : string;
begin
  if FirstChar(s) in aSet
  then temp := After(aSet,s)
  else temp:=s;
  Result := Before(aSet, temp);
  s := DelIfFirst(Result,temp);
end;

{-------------------------------------------------------------------------------
*WordCase - By default upcases the first letter of every word in a sentence.
 Example:
   s:='CASING IS PROBLEMATIC. ON SUNDAY I CODE IN PASCAL.';
   WordCase(s) >  'Casing Is Problematic. On Sunday I Code In Pascal.'
   WordCase(s,['.'],[' ',',']) >  'Casing is problematic. On sunday i code in pascal.'
   Note that WordDelims is used to locate the start of a sentence and is normally ['.']

   The logic looks something like this:
   While not end of text do
   begin
     If IsFirstWordInSentence then UpcaseFirstLetter else
     begin
       If assigned(AskUpcaseWordFunc) then
       begin
         If AskUpcaseWordFunc(CurrentWord) then UpcaseFirstLetter
       end else UpcaseFirstLetter
     end
     FindNextWord
   end
See also ProperCase,BasicUpcaseWords
-------------------------------------------------------------------------------}
function TStringCollection.WordCase(const s : string;const UpcaseDelims : TCharSet = [' ',',',';'];
  WordDelims : TCharSet = [];AskUpcaseWordFunc : TAskUpcaseWord = nil): string;
var
  i : Integer;
  n : integer;
  WasWordDelim : integer;
   procedure CheckUpcase;
   begin
     if AskUpcaseWordFunc(System.Copy(Result,WasWordDelim,i-WasWordDelim))
      then Result[WasWordDelim] := sc.Upcase(Result[WasWordDelim]);
   end;
begin
  Result := AnsiLowerCase(s);
  WasWordDelim:=0;
  i:=1;
  n := Length(Result);
  if Assigned(AskUpcaseWordFunc) then
  begin
    while i <= n do
    begin
      while (i <= n) and (Result[i] in UpcaseDelims+WordDelims) do inc(i);
      if i <= n then Result[i] := sc.Upcase(Result[i]);
      WasWordDelim:=0;
      while (i <= n) and not (Result[i] in UpcaseDelims) do
      begin
        if Result[i] in WordDelims then
        begin
          if WasWordDelim>0 then CheckUpcase;
          while (i <= n) and (Result[i] in WordDelims) do inc(i);
          WasWordDelim:=i;
        end;
        inc(i);
      end;
      if WasWordDelim>0 then CheckUpcase;
    end;
  end else
  begin
    while i <= n do
    begin
      while (i <= n) and (Result[i] in UpcaseDelims+WordDelims) do inc(i);
      if i <= n then Result[i] := sc.Upcase(Result[i]);
      while (i <= n) and not (Result[i] in UpcaseDelims) do inc(i);
    end;
  end;
end;

{-------------------------------------------------------------------------------
*ProperCase - By default it upcase the first letter of the first word in every
              sentence, and words that function BasicUpcaseWords returns true.
 Example:
   s:='CASING IS PROBLEMATIC. ON SUNDAY I CODE IN PASCAL.';
   ProperCase(s) > 'Casing is problematic. On Sunday I code in pascal.'
 Note that you can pass an alternative AskUpcaseWordFunc function.
See also WordCase,BasicUpcaseWords
-------------------------------------------------------------------------------}
function TStringCollection.ProperCase(const s : string;AskUpcaseWordFunc : TAskUpcaseWord = nil;UseBasicFuncIfNil : boolean = true) : string;
begin
  if (UseBasicFuncIfNil) and (not assigned(AskUpcaseWordFunc))
  then Result:=WordCase(s,['.'],[' ',',',';'],BasicUpcaseWords)
  else Result:=WordCase(s,['.'],[' ',',',';'],AskUpcaseWordFunc);
end;


{-------------------------------------------------------------------------------
*CharsetToVisualStr - Converts a CharSet to a string in a visual presentation form.

NOTE that only chars in gcCharSetVisualRange will be represented as literal values.
Because special characters like control characters, space and other extended
characters are not easy to identify in a string, or depends visually on the
system locale they are presended in their byte value with a hash prefix.
Therefore the escape character will be #27.

 The result is similar to inspecting a set of chars in the integrated debugger.
 Example: CharsetToVisualStr(['A'..'Z',#13,#12,#11,#9],true) > '#9,#11..#13,A..Z'
 Example: CharsetToVisualStr(['A'..'D',false) > 'A,B,C,D'
See also VisualStrToCharSet and overloaded Str function
-------------------------------------------------------------------------------}
function TStringCollection.CharsetToVisualStr(const aSet : TCharset;DoRange : boolean = true) : string;
var
   i : Char;
 f,l : SmallInt;
     function GetS(b : byte) : string;
     begin
       if char(b) in gcCharSetVisualRange
       then result:=char(b)
       else result:='#'+inttostr(b);
     end;
     procedure add;
     begin
       if f=-1 then exit;
       if f=l then
       begin
         if result=''
         then result:=Gets(f)
         else result:=result+','+Gets(f);
       end else
       begin
         if result=''
         then result:=Gets(f)+'..'+GetS(l)
         else result:=result+','+Gets(f)+'..'+GetS(l);
       end;
     end;
begin
  result:='';
  f:=-1;
  for i:=#0 to #255 do
  begin
    if DoRange then
    begin
      if i in aSet then
      begin
        if f=-1 then f:=byte(i);
        l:=byte(i);
      end else
      begin
        add;
        f:=-1;
      end;
    end else
    begin
      if i in aSet then
      begin
        f:=byte(i);l:=f;
        add;
        f:=-1;
      end;
    end;
  end;
  add;
end;

{-------------------------------------------------------------------------------
VisualStrToCharSet - Converts a string in visual CharSet form back to a CharSet
Note that the characters in the string do not have single quotes around them.

Example:
VisualStrToCharSet('A..Z,a..z') >  ['A'..'Z','a'..'z']
VisualStrToCharSet('A..Z,1,2,3,4') >  ['1'..'4','A'..'Z']

if aSet1:=['A'..'D','2'..'9',' ',#1] then:
  s:=CharsetToVisualStr(aSet,true) >  '#1,#32,2..9,A..D'
  aSet2:=VisualStrToCharSet(s) > aSet2 should equal aSet1
  
See also CharsetToVisualStr
-------------------------------------------------------------------------------}
function TStringCollection.VisualStrToCharSet(s : string) : TCharset;
var t1,t2 : string;
    function getc(t : string) : char;
    begin
      result:=#0;
      if t<>'' then
      begin
        if t[1]='#'
         then result:=char(ToI(copy(t,2,length(t))))
         else result:=t[1];
      end;
    end;

    procedure doit;
     var a,b : char;
           x : char;
    begin
      a:=getc(t1);
      b:=getc(t2);
      if b=#0 then result:=result+[a] else for x:=a to b do result:=result+[x];
    end;
begin
  result:=[];
  while s<>'' do
  begin
    t1:=Strip(before(',',s));
    if t1<>'' then
    begin
      t2:=strip(after('..',t1));
      t1:=strip(before('..',t1));
      doit;
    end;
    s:=After(',',s);
  end;
end;

{-------------------------------------------------------------------------------
*StrVar - Returns characters from an UnTyped variable as a string.
Source is typically an array of char or memory address.
Note that a Count of -1 means that the function will return all characters until
a terminator is found, and therefore Terminators will be set to [#0] if an empty set.
This is not intended as an asciiz function.


Example:
If Source is an array with the values 'h','e','l','l','o',#0 then:
 StrVar(Source,sizeof(Source)) > 'hello'+#0 //terminator an empty set
 StrVar(Source) > 'hello' //scans until first Terminator (default is #0)
 StrVar(Source,sizeof(Source),[#0]) > 'hello'
 StrVar(Source,sizeof(Source),['e']) > 'h'

If you have a PChar which points to 'hello' then:
 StrVar(p^,-1) > 'hello'
In Delphi 3+ you would actually just state s:=p. Conversely Delphi allows p:=s;

See also ToVar, system.move
-------------------------------------------------------------------------------}
function TStringCollection.StrVar(var Source;Count : integer = -1;Terminators : TCharSet = []) : string;
var
  p : PChar;
  i : word;
begin
  p := @Source;
  result := '';
  if Count=0 then exit;
  if Count = -1 then
  begin
    Count := System.MaxInt-4;
    if Terminators = [] then Terminators := [#0];
  end;
  if Terminators = [] then
  begin
    SetLength(result,Count);
    System.Move(p^,result[1],Count);
  end else
  begin
    i := 1;
    while (i <= Count) and (not (p^ in Terminators)) do
    begin
        result := result + p^;
        inc(p);
    end;
  end;
end;


{-------------------------------------------------------------------------------
*ToVar - Moves characters from a Source string to an UnTyped variable, typically
an array of char.
Note that the function does not create a NullTerminated array by default, EnsureAsciiZ has
to be true to ensure a #0 at the end.

If target is declared as array[0..5] then:
 ToVar('hello',target,sizeof(target)) > 'h','e','l','l','o',#0

If target is declared as array[0..4] then:
 ToVar('hello',target,sizeof(target)) > 'h','e','l','l','o'
 ToVar('hello',target,sizeof(target),true) > 'h','e','l','l',#0

See also StrVar, system.move
asciiz
-------------------------------------------------------------------------------}
procedure TStringCollection.ToVar(const Source : string;var Target;TargetSize : integer;EnsureAsciiZ : Boolean = false;ClearData : boolean = true);
var p : PChar;
    i : integer;
  Upto : integer;
begin
  p := @Target;
  if TargetSize <= 0 then Exit;
  if ClearData then System.FillChar(Target,TargetSize,#0);
  if EnsureAsciiZ then
  begin
    if Length(Source)+1>TargetSize
      then Upto := TargetSize-1
      else Upto := Length(Source);
  end else
  begin
    if Length(Source)>TargetSize
      then Upto := TargetSize
      else Upto := Length(Source);
  end;
  for i := 1 to Upto do
  begin
    p^ := Source[i];
    Inc(p);
  end;
  if Upto<TargetSize then if EnsureAsciiZ then p^:=#0;
end;



{-------------------------------------------------------------------------------
*MakePChar - allocates a copy of s on the heap and returns a null terminated string pointer.
Note that eventually the string needs to be free'd from the heap with FreePChar or SysUtils.StrDispose
See also FreePChar
-------------------------------------------------------------------------------}
function TStringCollection.MakePChar(const s: string): PChar;
begin
  result := SysUtils.StrNew(PChar(s));
end;

{-------------------------------------------------------------------------------
*FreePChar - free PChar string from the heap.
See also MakePChar
-------------------------------------------------------------------------------}
procedure TStringCollection.FreePChar(var p : PChar);
begin
  SysUtils.StrDispose(p);
  p:=nil;
end;

{-------------------------------------------------------------------------------
*Str - Returns a formatted string assembled from a format string
  and an array of arguments.
  Simply a call to SysUtils.Format
See also FormatSize and other Str overloaded functions
-------------------------------------------------------------------------------}
function TStringCollection.Str(const aFormat: string;const Args: array of const): string;
begin
  result:=SysUtils.Format(aFormat,Args);
end;


{-------------------------------------------------------------------------------
Simple example function used by ProperCase to return which words should be uppercased.
-------------------------------------------------------------------------------}
function BasicUpcaseWords(const s : string) : boolean;
begin
  Result:=true;
   if s='i' then exit;
   if s='c' then exit;
   if s='pascal' then exit;
   if s='delphi' then exit;
   if s='monday' then exit;
   if s='tuesday' then exit;
   if s='wednesday' then exit;
   if s='thursday' then exit;
   if s='friday' then exit;
   if s='saturday' then exit;
   if s='sunday' then exit;
  Result:=false;
end;


//==============================================================================
//Exception procedures
// see "Notes on the eRaise exception procedure" above
//==============================================================================
procedure RaiseException(aMessage,aFuncName : string;aObject : TObject);
var PrevMsg,PrevFunc,PrevClass : string;

  function Append(id : string;var IdText : string;SubStr : string) : boolean;
  begin
    Result := sc.IsSameFirst(id,SubStr);
    if not Result then exit;
    SubStr := sc.Strip(sc.After(id,SubStr));
    if IdText=''
    then IdText := SubStr else
    begin
      if sc.PosIC(SubStr,IdText)=0 then  IdText := IdText+','+SubStr;
    end;
  end;

  procedure GetPrevMsg;
   var e : tobject;
       m : string;
       s : string;
  begin
    e := SysUtils.ExceptObject;if e=nil then exit;
    m := exception(e).message;
    while m<>'' do
    begin
      s := sc.Before(gcCR,m);
      if sc.Strip(s)<>'' then
      begin
        if Append(geIdFunc,PrevFunc,s)=false then
        if Append(geIdClass,PrevClass,s)=false then
        PrevMsg := sc.DelIfFirst(gcCr,PrevMsg+gcCR+s);
      end;
      m := sc.After(gcCR,m);
    end;
  end;

  procedure Add(id : string;var Text : string;NewText : string);
  begin
    NewText := sc.Strip(NewText);
    if NewText='' then
    begin
      if Text<>'' then Text := id+Text;
    end else
    begin
      if Text=''
      then Text := id+NewText else
        if sc.PosIC(NewText,Text)=0
        then Text := id+Text+','+NewText
        else Text := id+Text
    end;
  end;

  function Clean(const s : string) : string;
  begin
    if s='' then Result := '' else Result := s+gcCR;
  end;
begin
  PrevMsg := '';
  PrevFunc := '';
  PrevClass := '';
  GetPrevMsg;
  Add(geIdFunc,PrevFunc,aFuncName);
  if aObject<>nil then Add(geIdClass,PrevClass,aObject.ClassName);
  Raise exception.Create(Clean(aMessage)+Clean(prevMsg)+Clean(PrevFunc)+PrevClass);
end;

procedure eRaise(aMessage : string;aFuncName : string= '';aObject : TObject= nil);
begin
  RaiseException(aMessage,aFuncName,aObject);
end;

procedure eRaise(aMessage : string;aObject : TObject);
begin
  RaiseException(aMessage,'',aObject);
end;






initialization
  sc := TStringCollection.Create;

end.

