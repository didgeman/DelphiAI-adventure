object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 576
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 338
    Width = 433
    Height = 230
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 8
    Width = 836
    Height = 281
    ColCount = 1
    FixedCols = 0
    RowCount = 2
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 8
    Top = 311
    Width = 137
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Memo1: TMemo
    Left = 456
    Top = 338
    Width = 388
    Height = 230
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object NavigatorBindSourceDB1: TBindNavigator
    Left = 604
    Top = 295
    Width = 240
    Height = 25
    DataSource = BindSourceDB1
    Orientation = orHorizontal
    TabOrder = 3
  end
  object Button1: TButton
    Left = 452
    Top = 295
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    OnClick = Button1Click
  end
  object BindSourceDB1: TBindSourceDB
    DataSource.OnDataChange = BindSourceDB1SubDataSourceDataChange
    ScopeMappings = <>
    Left = 328
    Top = 296
  end
  object BindingsList1: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 20
    Top = 5
    object LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource
      Category = 'Schnelle Bindungen'
      DataSource = BindSourceDB1
      GridControl = StringGrid1
      Columns = <>
    end
  end
end
