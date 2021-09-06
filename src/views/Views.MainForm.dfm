object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 654
  ClientWidth = 1003
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 635
    Width = 1003
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1003
    Height = 635
    Align = alClient
    BorderWidth = 1
    BorderStyle = bsSingle
    TabOrder = 1
    object PaintBox1: TPaintBox
      Left = 176
      Top = 80
      Width = 705
      Height = 465
    end
  end
  object MainMenu: TMainMenu
    Left = 944
    Top = 16
    object MnuFile: TMenuItem
      Caption = '&File'
    end
  end
  object timRealWorld: TTimer
    Left = 944
    Top = 80
  end
end
