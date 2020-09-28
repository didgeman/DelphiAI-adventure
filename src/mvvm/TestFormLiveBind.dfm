object TestFormLB: TTestFormLB
  Left = 0
  Top = 0
  Caption = 'TestFormLB'
  ClientHeight = 300
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 16
    Top = 16
    Width = 553
    Height = 241
    ColCount = 1
    FixedCols = 0
    RowCount = 2
    TabOrder = 0
    ColWidths = (
      64)
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 600
    Top = 32
  end
  object BindSourceDB1: TBindSourceDB
    DataSet = ClientDataSet1
    ScopeMappings = <>
    Left = 600
    Top = 96
  end
  object BindingsList1: TBindingsList
    Methods = <>
    OutputConverters = <>
    Left = 596
    Top = 165
    object LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource
      Category = 'Schnelle Bindungen'
      DataSource = BindSourceDB1
      GridControl = StringGrid1
      Columns = <>
    end
  end
end
