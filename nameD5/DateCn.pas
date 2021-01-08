unit DateCn;

interface

uses Windows, SysUtils, Controls;

const
  //农历月份数据，每年4字节，从1901年开始，共150年
  //数据来源：UCDOS 6.0 UCT.COM
  //分析整理：Copyright (c) 1996-1998, Randolph
  //数据解析：
  //如果第一字节的bit7为1，则该年1月1日位于农历12月，否则位于11月
  //第一字节去除bit7为该年1月1日的农历日期
  //         第二字节                 第三字节
  //bit:     7  6  5  4  3  2  1  0   7  6  5  4  3  2  1  0
  //农历月份:16 15 14 13 12 11 10 9   8  7  6  5  4  3  2  1
  //农历月份指的是从该年1月1日的农历月份算起的顺序号
  //农历月份对应的bit为1则该月为30日，否则为29日
  //第四字节为闰月月份
//  BaseDate='2000/02/04';//2000立春
  BaseAnimalDate = '1972'; //1972年支为子(是鼠年)
  BaseSkyStemDate = '1974'; //1974年干为甲
  CnData: array[0..599] of Byte = (
    $0B, $52, $BA, $00, $16, $A9, $5D, $00, $83, $A9, $37, $05, $0E, $74, $9B,
    $00,
    $1A, $B6, $55, $00, $87, $B5, $55, $04, $11, $55, $AA, $00, $1C, $A6, $B5,
    $00,
    $8A, $A5, $75, $02, $14, $52, $BA, $00, $81, $52, $6E, $06, $0D, $E9, $37,
    $00,
    $18, $74, $97, $00, $86, $EA, $96, $05, $10, $6D, $55, $00, $1A, $35, $AA,
    $00,
    $88, $4B, $6A, $02, $13, $A5, $6D, $00, $1E, $D2, $6E, $07, $0B, $D2, $5E,
    $00,
    $17, $E9, $2E, $00, $84, $D9, $2D, $05, $0F, $DA, $95, $00, $19, $5B, $52,
    $00,
    $87, $56, $D4, $04, $11, $4A, $DA, $00, $1C, $A5, $5D, $00, $89, $A4, $BD,
    $02,
    $15, $D2, $5D, $00, $82, $B2, $5B, $06, $0D, $B5, $2B, $00, $18, $BA, $95,
    $00,
    $86, $B6, $A5, $05, $10, $56, $B4, $00, $1A, $4A, $DA, $00, $87, $49, $BA,
    $03,
    $13, $A4, $BB, $00, $1E, $B2, $5B, $07, $0B, $72, $57, $00, $16, $75, $2B,
    $00,
    $84, $6D, $2A, $06, $0F, $AD, $55, $00, $19, $55, $AA, $00, $86, $55, $6C,
    $04,
    $12, $C9, $76, $00, $1C, $64, $B7, $00, $8A, $E4, $AE, $02, $15, $EA, $56,
    $00,
    $83, $DA, $55, $07, $0D, $5B, $2A, $00, $18, $AD, $55, $00, $85, $AA, $D5,
    $05,
    $10, $53, $6A, $00, $1B, $A9, $6D, $00, $88, $A9, $5D, $03, $13, $D4, $AE,
    $00,
    $81, $D4, $AB, $08, $0C, $BA, $55, $00, $16, $5A, $AA, $00, $83, $56, $AA,
    $06,
    $0F, $AA, $D5, $00, $19, $52, $DA, $00, $86, $52, $BA, $04, $11, $A9, $5D,
    $00,
    $1D, $D4, $9B, $00, $8A, $74, $9B, $03, $15, $B6, $55, $00, $82, $AD, $55,
    $07,
    $0D, $55, $AA, $00, $18, $A5, $B5, $00, $85, $A5, $75, $05, $0F, $52, $B6,
    $00,
    $1B, $69, $37, $00, $89, $E9, $37, $04, $13, $74, $97, $00, $81, $EA, $96,
    $08,
    $0C, $6D, $52, $00, $16, $2D, $AA, $00, $83, $4B, $6A, $06, $0E, $A5, $6D,
    $00,
    $1A, $D2, $6E, $00, $87, $D2, $5E, $04, $12, $E9, $2E, $00, $1D, $EC, $96,
    $0A,
    $0B, $DA, $95, $00, $15, $5B, $52, $00, $82, $56, $D2, $06, $0C, $2A, $DA,
    $00,
    $18, $A4, $DD, $00, $85, $A4, $BD, $05, $10, $D2, $5D, $00, $1B, $D9, $2D,
    $00,
    $89, $B5, $2B, $03, $14, $BA, $95, $00, $81, $B5, $95, $08, $0B, $56, $B2,
    $00,
    $16, $2A, $DA, $00, $83, $49, $B6, $05, $0E, $64, $BB, $00, $19, $B2, $5B,
    $00,
    $87, $6A, $57, $04, $12, $75, $2B, $00, $1D, $B6, $95, $00, $8A, $AD, $55,
    $02,
    $15, $55, $AA, $00, $82, $55, $6C, $07, $0D, $C9, $76, $00, $17, $64, $B7,
    $00,
    $86, $E4, $AE, $05, $11, $EA, $56, $00, $1B, $6D, $2A, $00, $88, $5A, $AA,
    $04,
    $14, $AD, $55, $00, $81, $AA, $D5, $09, $0B, $52, $EA, $00, $16, $A9, $6D,
    $00,
    $84, $A9, $5D, $06, $0F, $D4, $AE, $00, $1A, $EA, $4D, $00, $87, $BA, $55,
    $04,
    $12, $5A, $AA, $00, $1D, $AB, $55, $00, $8A, $A6, $D5, $02, $14, $52, $DA,
    $00,
    $82, $52, $BA, $06, $0D, $A9, $3B, $00, $18, $B4, $9B, $00, $85, $74, $9B,
    $05,
    $11, $B5, $4D, $00, $1C, $D6, $A9, $00, $88, $35, $AA, $03, $13, $A5, $B5,
    $00,
    $81, $A5, $75, $0B, $0B, $52, $B6, $00, $16, $69, $37, $00, $84, $E9, $2F,
    $06,
    $10, $F4, $97, $00, $1A, $75, $4B, $00, $87, $6D, $52, $05, $11, $2D, $69,
    $00,
    $1D, $95, $B5, $00, $8A, $A5, $6D, $02, $15, $D2, $6E, $00, $82, $D2, $5E,
    $07,
    $0E, $E9, $2E, $00, $19, $EA, $96, $00, $86, $DA, $95, $05, $10, $5B, $4A,
    $00,
    $1C, $AB, $69, $00, $88, $2A, $D8, $03);

function DaysNumberOfDate(Date: TDate): Integer;
//日期是该年的第几天，1月1日为第一天
function CnMonthOfDate(Date: TDate): string; //指定日期的农历月
function CnDayOfDate(Date: TDate): string; //指定日期的农历日包括节日
function CnDateOfDateStr(Date: TDate): string; //指定日期的农历日期
function CnDayOfDatePH(Date: TDate): string; //指定日期的农历月
function CnDateOfDateStrPH(Date: TDate): string; //指定日期的农历日期包括节日
function CnDayOfDateJr(Date: TDate): string; //只有节日
function CnanimalOfYear(Date: TDate): string; //返回十二生肖(地支)
function CnSkyStemOfYear(Date: TDate): string; //返回十大天干
function GrDateOfDateStr(Date:TDate):Tdate;    //从农历日期返回公历日期字符串

implementation

//日期是该年的第几天，1月1日为第一天

function DaysNumberOfDate(Date: TDate): Integer;
var
  DaysNumber: Integer;
  I: Integer;
  yyyy, mm, dd: Word;
begin
  DecodeDate(Date, yyyy, mm, dd);
  DaysNumber := 0;
  for I := 1 to mm - 1 do
    Inc(DaysNumber, MonthDays[IsLeapYear(yyyy), I]);
  Inc(DaysNumber, dd);
  Result := DaysNumber;
end;



//日期的农历日期，返回农历格式：月份*100 + 日，负数为闰月
//超出范围则返回0

function CnDateOfDate(Date: TDate): Integer;
var
  CnMonth, CnMonthDays: array[0..15] of Integer;
  CnBeginDay, LeapMonth: Integer;
  yyyy, mm, dd: Word;
  Bytes: array[0..3] of Byte;
  I: Integer;
  CnMonthData: Word;
  DaysCount, CnDaysCount, ResultMonth, ResultDay: Integer;
begin
  DecodeDate(Date, yyyy, mm, dd);
  if (yyyy < 1901) or (yyyy > 2050) then
  begin
    Result := 0;
    Exit;
  end;
  Bytes[0] := CnData[(yyyy - 1901) * 4];
  Bytes[1] := CnData[(yyyy - 1901) * 4 + 1];
  Bytes[2] := CnData[(yyyy - 1901) * 4 + 2];
  Bytes[3] := CnData[(yyyy - 1901) * 4 + 3];
  if (Bytes[0] and $80) <> 0 then
    CnMonth[0] := 12
  else
    CnMonth[0] := 11;
  CnBeginDay := (Bytes[0] and $7F);
  CnMonthData := Bytes[1];
  CnMonthData := CnMonthData shl 8;
  CnMonthData := CnMonthData or Bytes[2];       //合并月份数据
  LeapMonth := Bytes[3];                        //闰月

  for I := 15 downto 0 do
  begin
    CnMonthDays[15 - I] := 29;
    if ((1 shl I) and CnMonthData) <> 0 then
      Inc(CnMonthDays[15 - I]);                 //每月天数
    if CnMonth[15 - I] = LeapMonth then
      CnMonth[15 - I + 1] := -LeapMonth
    else
    begin
      if CnMonth[15 - I] < 0 then               //上月为闰月
        CnMonth[15 - I + 1] := -CnMonth[15 - I] + 1
      else
        CnMonth[15 - I + 1] := CnMonth[15 - I] + 1;
      if CnMonth[15 - I + 1] > 12 then CnMonth[15 - I + 1] := 1;
    end;
  end;

  DaysCount := DaysNumberOfDate(Date) - 1;
  if DaysCount <= (CnMonthDays[0] - CnBeginDay) then    //该天在第一个月里
  begin
    if (yyyy > 1901) and
      (CnDateOfDate(EncodeDate(yyyy - 1, 12, 31)) < 0) then
      ResultMonth := -CnMonth[0]
    else
      ResultMonth := CnMonth[0];
    ResultDay := CnBeginDay + DaysCount;
  end
  else                                                  //不在第一个月
  begin
    CnDaysCount := CnMonthDays[0] - CnBeginDay;
    I := 1;
    while (CnDaysCount < DaysCount) and
      (CnDaysCount + CnMonthDays[I] < DaysCount) do
    begin
      Inc(CnDaysCount, CnMonthDays[I]);
      Inc(I);
    end;
    ResultMonth := CnMonth[I];
    ResultDay := DaysCount - CnDaysCount;
  end;
  if ResultMonth > 0 then
    Result := ResultMonth * 100 + ResultDay
  else
    Result := ResultMonth * 100 - ResultDay
end;

function CnMonthOfDate(Date: TDate): string;
const
  CnMonthStr: array[1..12] of string = (
    '正', '二', '三', '四', '五', '六', '七', '八', '九', '十',
    '冬', '腊');
var
  Month: Integer;
begin
  Month := CnDateOfDate(Date) div 100;
  if Month < 0 then
    Result := '闰' + CnMonthStr[-Month]
  else
    Result := CnMonthStr[Month] + '月';
end;

function CnDayOfDatePH(Date: TDate): string;
const
  CnDayStr: array[1..30] of string = (
    '初一', '初二', '初三', '初四', '初五',
    '初六', '初七', '初八', '初九', '初十',
    '十一', '十二', '十三', '十四', '十五',
    '十六', '十七', '十八', '十九', '二十',
    '廿一', '廿二', '廿三', '廿四', '廿五',
    '廿六', '廿七', '廿八', '廿九', '三十');
var
  Day: Integer;
begin
  Day := Abs(CnDateOfDate(Date)) mod 100;
  Result := CnDayStr[Day];
end;

function CnDateOfDateStr(Date: TDate): string;
begin
  Result := CnMonthOfDate(Date) + CnDayOfDatePH(Date);
end;

function CnDayOfDate(Date: TDate): string;
const
  CnDayStr: array[1..30] of string = (
    '初一', '初二', '初三', '初四', '初五',
    '初六', '初七', '初八', '初九', '初十',
    '十一', '十二', '十三', '十四', '十五',
    '十六', '十七', '十八', '十九', '二十',
    '廿一', '廿二', '廿三', '廿四', '廿五',
    '廿六', '廿七', '廿八', '廿九', '三十');
var
  Day: Integer;
begin
  Day := Abs(CnDateOfDate(Date)) mod 100;
  if (CnMonthOfDate(Date) = '正月') then
    case Day of
      1: Result := '春节';
      15: Result := '元宵节';
    else
      Result := CnDayStr[Day];
    end
  else
  begin
    case Day of
      5:
        if CnMonthOfDate(Date) = '五月' then
          Result := '端午节'
        else
          Result := CnDayStr[Day];
      7:
        if CnMonthOfDate(Date) = '七月' then
          Result := '七夕节'
        else
          Result := CnDayStr[Day];
      15:
        if CnMonthOfDate(Date) = '八月' then
          Result := '中秋节'
        else
          Result := CnDayStr[Day];
      9:
        if CnMonthOfDate(Date) = '九月' then
          Result := '重阳节'
        else
          Result := CnDayStr[Day];
      8:
        if CnMonthOfDate(Date) = '腊月' then
          Result := '腊八节'
        else
          Result := CnDayStr[Day];
    else
      if (CnMonthOfDate(Date + 1) = '正月') then
        Result := '除夕'
      else
        Result := CnDayStr[Day];
    end; {case}
  end;
end;

function CnDateOfDateStrPH(Date: TDate): string;
begin
  Result := CnMonthOfDate(Date) + CnDayOfDate(Date);
end;

function CnDayOfDateJr(Date: TDate): string;
const
  CnDayStr: array[1..30] of string = (
    '初一', '初二', '初三', '初四', '初五',
    '初六', '初七', '初八', '初九', '初十',
    '十一', '十二', '十三', '十四', '十五',
    '十六', '十七', '十八', '十九', '二十',
    '廿一', '廿二', '廿三', '廿四', '廿五',
    '廿六', '廿七', '廿八', '廿九', '三十');
var
  Day: Integer;
begin
  Day := Abs(CnDateOfDate(Date)) mod 100;
  if (CnMonthOfDate(Date) = '正月') then
    case Day of
      1: Result := '春节';
      15: Result := '元宵节';
    else
      Result := '';
    end
  else
  begin
    case Day of
      5:
        if CnMonthOfDate(Date) = '五月' then
          Result := '端午节'
        else
          Result := '';
      7:
        if CnMonthOfDate(Date) = '七月' then
          Result := '七夕节'
        else
          Result := '';
      15:
        if CnMonthOfDate(Date) = '八月' then
          Result := '中秋节'
        else
          Result := '';
      9:
        if CnMonthOfDate(Date) = '九月' then
          Result := '重阳节'
        else
          Result := '';
      8:
        if CnMonthOfDate(Date) = '腊月' then
          Result := '腊八节'
        else
          Result := '';
    else
      if (CnMonthOfDate(Date + 1) = '正月') then
        Result := '除夕'
      else
        Result := '';
    end; {case}
  end;
end;

function CnanimalOfYear(Date: TDate): string; //返回十二生肖
begin
  case (StrToInt(Copy(DateToStr(Date), 1, 4)) - StrToInt(BaseAnimalDate))
    mod 12 of
    0:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '子鼠'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '亥猪'
        else
          Result := '子鼠';
      end;
    1, -11:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '丑牛'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '子鼠'
        else
          Result := '丑牛';
      end;
    2, -10:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '寅虎'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '丑牛'
        else
          Result := '寅虎';
      end;
    3, -9:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '卯兔'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '寅虎'
        else
          Result := '卯兔';
      end;
    4, -8:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '辰龙'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '卯兔'
        else
          Result := '辰龙';
      end;
    5, -7:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '巳蛇'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '辰龙'
        else
          Result := '巳蛇';
      end;
    6, -6:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '午马'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '巳蛇'
        else
          Result := '午马';
      end;
    7, -5:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '未羊'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '午马'
        else
          Result := '未羊';
      end;
    8, -4:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '申猴'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '未羊'
        else
          Result := '申猴';
      end;
    9, -3:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '酉鸡'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '申猴'
        else
          Result := '酉鸡';
      end;
    10, -2:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '戌狗'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '酉鸡'
        else
          Result := '戌狗';
      end;
    11, -1:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '亥猪'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '戌狗'
        else
          Result := '亥猪';
      end;
  end; {case}
end;

function CnSkyStemOfYear(Date: TDate): string; //返回十大天干
begin
  case (StrToInt(Copy(DateToStr(Date), 1, 4)) - StrToInt(BaseSkyStemDate))
    mod 10 of
    0:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '甲'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '癸'
        else
          Result := '甲';
      end;
    1, -9:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '乙'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '甲'
        else
          Result := '乙';
      end;
    2, -8:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '丙'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '乙'
        else
          Result := '丙';
      end;
    3, -7:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '丁'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '丙'
        else
          Result := '丁';
      end;
    4, -6:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '戊'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '丁'
        else
          Result := '戊';
      end;
    5, -5:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '巳'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '戊'
        else
          Result := '巳';
      end;
    6, -4:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '庚'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '巳'
        else
          Result := '庚';
      end;
    7, -3:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '辛'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '庚'
        else
          Result := '辛';
      end;
    8, -2:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '壬'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '辛'
        else
          Result := '壬';
      end;
    9, -1:
      if (StrToInt(Copy(DateToStr(Date), 6, 2)) < 4) and ((Pos('腊',
        CnMonthOfDate(Date)) = 0) and (Pos('冬', CnMonthOfDate(Date)) = 0)) then
        Result := '癸'
      else
      begin
        if StrToInt(Copy(DateToStr(Date), 6, 2)) < 4 then
          Result := '壬'
        else
          Result := '癸';
      end;
  end;
end;

function GrdateOfDatestr(date:TDate):Tdate;
var
  days,CnBeginDay,i:integer;
  cnyy,Cnmm,Cndd,Gryy,Grmm,Grdd:word;
  Bytes:array[0..3] of Byte;
  CnMonths,CnMonthDays:array[0..15] of integer;
begin
  DecodeDate(date,Cnyy,Cnmm,cndd);
  if (Cnyy<1901) or(Cnyy>2050) then
  begin
    exit;
  end;
  Bytes[0]:=cnData[(Cnyy-1901+1)*4];
  Bytes[1]:=CnData[(Cnyy-1901+1)*4+1];
  Bytes[2]:=CnData[(Cnyy-1901+1)*4+2];
  Bytes[3]:=CnData[(Cnyy-1901+1)*4+3];
  if (Bytes[0] and $80)<>0 then
    Cnmonths[0]:=12
  else CnMonths[0]:=11;
  Cnbeginday:=bytes[0] and $7f;
  if (Cnmm>CnMonths[0]) or ((Cnmm=CnMonths[0]) and (Cndd>=Cnbeginday))then
  begin
    Gryy:=Cnyy+1;
    if Cnmonths[0]=12 then
      days:=Cndd-Cnbeginday
    else
      days:=CnMonthdays[11]-Cnbeginday+cndd;
  end
  else
  begin
    Gryy:=Cnyy;
    Bytes[0]:=CnData[(Cnyy-1901)*4];
    Bytes[1]:=CnData[(cnyy-1901)*4+1];
    Bytes[2]:=CnData[(Cnyy-1901)*4+2];
    Bytes[3]:=CnData[(Cnyy-1901)*4+3];
    days:=0;
    for i:=0to cnmm-1 do
      inc(days,CnMonthdays[i]);
    inc(days,cndd);
  end;
  for i:=1 to 12 do
  begin
    if days<Monthdays[isLeapyear(Cnyy),i] then
    begin
      Grmm:=i;
      break;
    end;
    dec(days,Monthdays[isLeapYear(Cnyy),i]);
  end;
  Grdd:=days;
end;


end.

