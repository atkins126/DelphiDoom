object StartUpConsoleForm: TStartUpConsoleForm
  Left = 328
  Top = 151
  Cursor = crHourGlass
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = '-'
  ClientHeight = 350
  ClientWidth = 572
  Color = clBtnFace
  Font.Charset = GREEK_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Memo1: TMemo
    Left = 0
    Top = 28
    Width = 572
    Height = 288
    Cursor = crHourGlass
    Align = alClient
    Color = 4210752
    Font.Charset = GREEK_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object GamePanel: TPanel
    Left = 0
    Top = 0
    Width = 572
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    Visible = False
    object GameLabel: TLabel
      Left = 8
      Top = 4
      Width = 553
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Caption = ' '
      Font.Charset = GREEK_CHARSET
      Font.Color = clMaroon
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object StartUpProgressBar: TProgressBar
    Left = 0
    Top = 333
    Width = 572
    Height = 17
    Align = alBottom
    Smooth = True
    TabOrder = 2
  end
  object StartUpProgressBar2: TProgressBar
    Left = 0
    Top = 316
    Width = 572
    Height = 17
    Align = alBottom
    Smooth = True
    TabOrder = 3
    Visible = False
  end
  object NetPanel: TPanel
    Left = 175
    Top = 112
    Width = 222
    Height = 65
    Cursor = crArrow
    Caption = ' '
    TabOrder = 4
    Visible = False
    object NetMsgLabel: TLabel
      Left = 8
      Top = 8
      Width = 181
      Height = 16
      Cursor = crArrow
      Caption = 'listening for network start info...'
    end
    object AbortNetButton: TButton
      Left = 72
      Top = 32
      Width = 75
      Height = 25
      Cursor = crHandPoint
      Caption = 'Abort'
      TabOrder = 0
      OnClick = AbortNetButtonClick
    end
  end
end
