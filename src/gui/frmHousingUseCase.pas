unit frmHousingUseCase;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TDistrictRecord = record
    longitude: Single;
    latitude: Single;
    housing_median_age: Single;
    total_rooms: Single;
    total_bedrooms: Single;
    population: Single;
    households: Single;
    median_income: Single;
    median_house_value: Single;
    ocean_proximity: String;
  end;
  THousingForm = class(TForm)
    ListView1: TListView;
  private
    { Private declarations }
    tmpFilePath : string;
    HousingCSVdata : TStringList;
    tmpStrAry : TArray<string>;
    tmpRecord : TDistrictRecord;
    targetArray: array of TDistrictRecord;
    tmpListItem : TListViewItem;
    myFormatSettings : TFormatSettings;
  public
    { Public declarations }
    procedure execHousing();
  end;

var
  HousingForm: THousingForm;

implementation

procedure THousingForm.execHousing();
var
  I, J: integer;
begin
  {TODO: ask user for path to file }
  tmpFilePath := 'D:\workspace\Delphi\DelphiAI\data\houseprices\housing.csv';

  { setup the settings according to used format in our csv-files }
  myFormatSettings := TFormatSettings.Create;
  myFormatSettings.DecimalSeparator := '.';

  try
    HousingCSVdata := TStringList.Create;
    try
      HousingCSVdata.LoadFromFile(tmpFilePath);
    except
      On E : Exception Do Begin
        ShowMessage(E.Message);
        raise E;        { since we cant continue in meaningful way }
      End;
    end;
    { use length of StringList to reserve memory for data structure }
    SetLength(targetArray, HousingCSVdata.Count);
    for I := 1 to HousingCSVdata.Count - 1 do   { Index 0 = Header row }
    begin
      tmpStrAry := HousingCSVdata[I].Split([',']);
      J := 0;
      with tmpRecord do begin
        longitude := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings);
        Inc(J);
        latitude := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings);
        Inc(J);
        housing_median_age := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings);
        Inc(J);
        total_rooms := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings);
        Inc(J);
        if tmpStrAry[J] <> '' then
          total_bedrooms := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings)
        else
          total_bedrooms := Null;
        Inc(J);
        population := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings);
        Inc(J);
        median_income := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings);
        Inc(J);
        median_house_value := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings);
        Inc(J);
        ocean_proximity := tmpStrAry[J];
        targetArray[I] := tmpRecord;
        tmpListItem := ListView1.Items.Add;
        tmpListItem.Text := HousingCSVdata[I];
      end;
    end;

  finally
    HousingCSVdata.Free;
  end;

end;

{$R *.fmx}

end.
