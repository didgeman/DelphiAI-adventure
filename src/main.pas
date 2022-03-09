unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Generics.Collections,
  System.Classes, System.Variants, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.Objects, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Calendar, RegularPolygon,
  FMX.Menus, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

type
  SGameInput = record
    LeftButtonPressed: boolean;
    RightButtonPressed: boolean;
    UpButtonPressed: boolean;
    DownButtonPressed: boolean;
  end;

  TMainForm = class(TForm)
    gameLoopTimer: TTimer;
    FrameLayout: TLayout;
    MenuPanel: TPanel;
    StatusPanel: TPanel;
    chk_IsDoubleBuffered: TCheckBox;
    lblFPS_Counter: TLabel;
    GameViewPort: TPanel;
    menuBar: TMenuBar;
    mnitemData: TMenuItem;
    mnitemLoad: TMenuItem;
    memStatus: TMemo;
    pnlPlayArea: TPanel;
    PlayAreaBck: TRectangle;
    Ship: TRectangle;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PlayAreaBckMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ShipClick(Sender: TObject);
  private
    { Private-Deklarationen }
    FObjList: TList<TRectangle>;
    FCurrSelObj: TRectangle;
  public
    { Public-Deklarationen }
  end;

const
  FPS_HISTORY_SIZE = 50;
  RotationSpeed = 10;
  velocity_x = 20;        { means 20 Pixels per second }
  velocity_y = 20;

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
{$R *.Windows.fmx MSWINDOWS}

uses frmHousingUseCase;

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

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FObjList.Clear;
  FObjList.Free;
  Application.Terminate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  lastTime := TThread.GetTickCount;
  Fillchar(fpsHistory, SizeOf(fpsHistory), 0);
  fpsIdx := 0;
  lastFPSDisplayTime := TThread.GetTickCount;
  FObjList := TList<TRectangle>.Create;
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
  newObject.Opacity := 0.3;
  { GameObjList.Add(newObject); }
  MainForm.AddObject(newObject);
  newObject.Position.X := X;
  newObject.Position.Y := Y;
end;

procedure TMainForm.mnitemLoadClick(Sender: TObject);
var
  dummy: string;
  modalHouseUC: THousingForm;
begin
  modalHouseUC := THousingForm.Create(Self);
  try
    modalHouseUC.showModal();
  finally
    modalHouseUC.Free;
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
    {
    if currGameInput.LeftButtonPressed = True then
      Player.RotationAngle := Player.RotationAngle - RotationSpeed;

    if currGameInput.RightButtonPressed = True then
      Player.RotationAngle := Player.RotationAngle + RotationSpeed;
    }

    { change state because of game rules, physics = moving... }
    {
    Player.Position.X := Player.Position.X + (elapsedTime * velocity_x / 1000.0);
    Player.Position.Y := Player.Position.Y + (elapsedTime * velocity_y / 1000.0);


    if Player.Position.X >= pnlPlayArea.Size.Width then
      Player.Position.X := pnlPlayArea.Size.Width - 1;

    if Player.Position.Y >= pnlPlayArea.Size.Height then
      Player.Position.Y := pnlPlayArea.Size.Height - 1;
    }

    { render ?? implicit }
    GameViewPort.EndUpdate;
  end
  else
    lastTime := TThread.GetTickCount;

end;

procedure TMainForm.PlayAreaBckMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
Var
  newObject: TRectangle;
begin
  memStatus.Lines.Add('X: ' + FloatToStr(X) + '; Y: ' + FloatToStr(Y));
  newObject := TRectangle.Create(MainForm.PlayAreaBck);
  { GameObjList.Add(newObject); }
  newObject.Position.X := X;
  newObject.Position.Y := Y;
  newObject.Stroke.Kind := TBrushKind.Solid;
  newObject.Fill.Kind := TBrushKind.Bitmap;
  newObject.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
  newObject.Fill.Bitmap.Bitmap.LoadFromFile('ship.png');
  newObject.OnClick := ShipClick;
  PlayAreaBck.AddObject(newObject);
  FObjList.Add(newObject);
end;

procedure TMainForm.ShipClick(Sender: TObject);
begin
  if Assigned(FCurrSelObj) then
    FCurrSelObj.Stroke.Color := TAlphaColorRec.Black;
  FCurrSelObj := Sender as TRectangle;
  FCurrSelObj.Stroke.Color := TAlphaColorRec.Red;
end;

initialization
begin
  IsGameRunning := True;
end;

end.
