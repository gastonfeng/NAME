object Form1: TForm1
  Left = 301
  Top = 128
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Form1'
  ClientHeight = 414
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 96
    Width = 377
    Height = 289
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'ÐÂËÎÌå'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 32
    Top = 32
    Width = 75
    Height = 25
    Caption = 'START'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 128
    Top = 32
    Width = 75
    Height = 25
    Caption = 'STOP'
    Enabled = False
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 232
    Top = 32
    Width = 75
    Height = 25
    Caption = 'QUIT'
    TabOrder = 3
    OnClick = Button3Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 384
    Width = 380
    Height = 30
    Panels = <>
    SimplePanel = True
  end
  object NMHTTP1: TNMHTTP
    Port = 0
    ReportLevel = 0
    Body = 'Default.htm'
    Header = 'Head.txt'
    InputFileMode = False
    OutputFileMode = False
    ProxyPort = 0
    Left = 328
    Top = 16
  end
end
