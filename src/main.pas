unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Generics.Collections,
  System.Classes, System.Variants, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Calendar, RegularPolygon,
  FMX.Menus, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  SGameInput = record
    LeftButtonPressed: boolean;
    RightButtonPressed: boolean;
    UpButtonPressed: boolean;
    DownButtonPressed: boolean;
  end;
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

  TMainForm = class(TForm)
    gameLoopTimer: TTimer;
    FrameLayout: TLayout;
    MenuPanel: TPanel;
    StatusPanel: TPanel;
    chk_IsDoubleBuffered: TCheckBox;
    lblFPS_Counter: TLabel;
    GameViewPort: TPanel;
    RegularPolygon1: TRegularPolygon;
    menuBar: TMenuBar;
    mnitemData: TMenuItem;
    mnitemLoad: TMenuItem;
    ListView1: TListView;
    procedure OnGameLoopTick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure chk_IsDoubleBufferedChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GameViewPortMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure mnitemLoadClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

const
  FPS_HISTORY_SIZE = 15;

var
  MainForm: TMainForm;
  currGameInput: SGameInput;
  fps: Double;
  fpsHistory: array[0..FPS_HISTORY_SIZE] of Double;
  fpsIdx: Integer;
  lastTime, currentTime, elapsedTime, lastFPSDisplayTime: System.Cardinal;
  GameObjList: TObjectList<TRectangle>;

{ module procs and functions since they are app-wide unique anyway }
{ if they should be obj-bound, a kind of Main-Class-Obj have to be invented }
procedure startGame();
procedure stopGame();

implementation

{$R *.fmx}

var
  IsGameRunning: Boolean;

procedure InitGame;
begin
  { ameObjList := TObjectList<TRectangle>.Create;
  (check if they are contigous in memory layout) }
end;

function getMeanFPS: Double;
var
  i: Integer;
  sum: Double;
begin
  sum := 0;
  for i := 0 to FPS_HISTORY_SIZE-1 do begin
    sum := sum + fpsHistory[i];
  end;
  Result := sum / FPS_HISTORY_SIZE;
end;

procedure startGame();
begin
  IsGameRunning := True;
  lastTime := TThread.GetTickCount;
end;

procedure stopGame();
begin
  IsGameRunning := False;

end;


{--- START  Win event handlers  ---}

procedure TMainForm.chk_IsDoubleBufferedChange(Sender: TObject);
begin
  {if chk_IsDoubleBuffered.IsChecked then
    DoubleBuffered := True
  else
    DoubleBuffered := False;}
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  lastTime := TThread.GetTickCount;
  Fillchar(fpsHistory, SizeOf(fpsHistory), 0);
  fpsIdx := 0;
  lastFPSDisplayTime := TThread.GetTickCount;
  InitGame;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  {
  GameObjList.Clear;
  GameObjList.Free;
  }
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    vkLeft: begin
      currGameInput.LeftButtonPressed := True;
      currGameInput.RightButtonPressed := False;
    end;
    vkRight: begin
      currGameInput.LeftButtonPressed := False;
      currGameInput.RightButtonPressed := True;
    end;
    vkUp: begin
      currGameInput.UpButtonPressed := True;
      currGameInput.DownButtonPressed := False;
    end;
    vkDown: begin
      currGameInput.UpButtonPressed := False;
      currGameInput.DownButtonPressed := True;
    end;
  end;
  case KeyChar of
  'P', 'p': if IsGameRunning then IsGameRunning := False else IsGameRunning := True;
  end;

end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
  vkLeft: currGameInput.LeftButtonPressed := False;
  vkRight: currGameInput.RightButtonPressed := False;
  vkUp: currGameInput.UpButtonPressed := False;
  vkDown: currGameInput.DownButtonPressed := False;
  end;

end;

procedure TMainForm.GameViewPortMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
Var
  newObject: TRectangle;
begin
  newObject := TRectangle.Create(MainForm.GameViewPort);
  { GameObjList.Add(newObject); }
  MainForm.AddObject(newObject);
  newObject.Position.X := X;
  newObject.Position.Y := Y;
end;

procedure TMainForm.mnitemLoadClick(Sender: TObject);
var
  tmpFilePath : string;
  HousingCSVdata : TStringList;
  tmpStrAry : TArray<string>;
  tmpRecord : TDistrictRecord;
  targetArray: array of TDistrictRecord;
  I, J: Integer;
  tmpListItem : TListViewItem;
  myFormatSettings : TFormatSettings;
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
        total_bedrooms := StrToFloatDef(tmpStrAry[J], 0.0, myFormatSettings);
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

procedure TMainForm.OnGameLoopTick(Sender: TObject);
begin
  if IsGameRunning then begin
    currentTime := TThread.GetTickCount;
    elapsedTime := currentTime - lastTime;    { will be used for update() }
    if fpsIdx > FPS_HISTORY_SIZE - 1 then
      fpsIdx := 0
    else
      fpsIdx := fpsIdx + 1;
    fpsHistory[fpsIdx] := (1000.0 / Double(elapsedTime));

    lastTime := currentTime;

    GameViewPort.BeginUpdate;

    { if its time to update our fps-Display Counter }
    if currentTime > lastFPSDisplayTime + 1000 then begin
      lblFPS_Counter.Text := Format('%.2f', [getMeanFPS]);
      lastFPSDisplayTime := currentTime;
    end;

    { process the Input-Info for actions/changed settings }


    { change state because of game rules, physics... }


    { render ?? implicit }
    GameViewPort.EndUpdate;
  end;

end;

initialization
begin
  IsGameRunning := True;
end;

end.
