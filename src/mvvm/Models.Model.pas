unit Models.Model;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient;

type
  TDataModel = class(TDataModule)
    cdsBioLife: TClientDataSet;
  private
    { Private-Deklarationen }
    FFileName: string;
    function GetBioLife: TClientDataSet;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property BioLife: TClientDataSet read GetBioLife;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModel }

constructor TDataModel.Create(AOwner: TComponent);
begin
  inherited;
  cdsBioLife := TClientDataSet.Create(nil);
  FFileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
               'biolife.cds';
  cdsBioLife.FileName := FFileName;
end;

destructor TDataModel.Destroy;
begin
  cdsBioLife.Free;
  inherited;
end;

function TDataModel.GetBioLife: TClientDataSet;
begin
  Result := cdsBioLife;
end;

end.
