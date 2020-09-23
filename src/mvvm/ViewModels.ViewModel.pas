unit ViewModels.ViewModel;

interface

uses
  System.Classes, Vcl.Graphics, Data.DB, Models.Model, Interfaces.IView;

type TViewModel = class
  private
    FView: IView;
    FModel: TDataModel;
    cacheBmp: TBitmap;
    function GetBioLifeCDS(): TDataSet;
    function GetFishPicture: TBitmap;
    function GetName: string;
    function GetNotes: string;
  public
    constructor Create(aView: IView);
    destructor Destroy; override;
    procedure DataButton;
    property BioLifeCDS: TDataSet read GetBioLifeCDS;
    property Name: string read GetName;
    property Notes: string read GetNotes;
    property FishPicture: TBitmap read GetFishPicture;
end;


implementation

{ TViewModel }
uses View;

constructor TViewModel.Create(aView: IView);
begin
  inherited Create;
  // better approach: make model creation independent via factory?
  FModel := TDataModel.Create(nil);
  FView := aView;
end;

destructor TViewModel.Destroy;
begin
  FModel.Free;
  cacheBmp.Free;
  inherited;
end;

// -- event handler ---

procedure TViewModel.DataButton;
begin
  if BioLifeCDS.Active then
    BioLifeCDS.Close
  else
    BioLifeCDS.Open;
  FView.UpdateData;
end;


function TViewModel.GetBioLifeCDS: TDataSet;
begin
  Result := FModel.BioLife;    { global for now; should be switched later }
end;

function TViewModel.GetFishPicture: TBitmap;
var
  BF: TBlobField;
  BS: TStream;
begin
  if not (BioLifeCDS.State = dsInactive) then
  begin
    BF := BioLifeCDS.FieldByName('Graphic') as TBlobField;
    BS := BioLifeCDS.CreateBlobStream(BF, bmRead); { how to know we are owner,
                                i.e. caller hasnt to free? docs ? }
    try
      cacheBmp.Free;                // keep only one Bitmap in Memory
      cacheBmp := TBitmap.Create;   // or could we reuse the instance?
      BS.Position := 8;   { jump over header? }
      cacheBmp.LoadFromStream(BS);
    finally
      BS.Free;
      Result := cacheBmp;
    end;
  end
  else
    Result := nil;
end;

function TViewModel.GetName: string;
begin
  if not (BioLifeCDS.State = dsInactive) then
    Result := FModel.BioLife.FieldByName('Common_name').AsString;
end;

function TViewModel.GetNotes: string;
begin
  if not (BioLifeCDS.State = dsInactive) then
    Result := FModel.BioLife.FieldByName('Notes').AsString;
end;

end.
