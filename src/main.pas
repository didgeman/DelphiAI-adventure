unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls;

type
  SGameInput = record
    LeftButtonPressed: boolean;
    RightButtonPressed: boolean;
    UpButtonPressed: boolean;
    DownButtonPressed: boolean;
  end;

  TMainForm = class(TForm)
    gameobj1: TRectangle;
    gameLoopTimer: TTimer;
    FrameLayout: TLayout;
    MenuPanel: TPanel;
    StatusPanel: TPanel;
    GameViewPort: TRectangle;
    chk_IsDoubleBuffered: TCheckBox;
    lblFPS_Counter: TLabel;
    procedure OnGameLoopTick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure chk_IsDoubleBufferedChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  GameObjList: TStringList;

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
  GameObjList := TStringList.Create;  {TODO: find place for the freeing or register it as approved leak.}
  { Create a bunch of TRectangle's (check if they are contigous in memory layout) }

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

    { process the Input-Info for player actions }
    if (currGameInput.LeftButtonPressed = True)
        {and (gameobj1.Position.X - 2 >= ClientLayout.Position.X)} then
     { gameobj1.Position.X := gameobj1.Position.X - 2;}
      gameobj1.RotationAngle := gameobj1.RotationAngle - 2.0;

    if (currGameInput.RightButtonPressed = True)
        {and (gameobj1.Position.X + 2 + gameobj1.Width <=
         ClientLayout.Position.X + ClientLayout.Width)} then
     { gameobj1.Position.X := gameobj1.Position.X + 2;}
      gameobj1.RotationAngle := gameobj1.RotationAngle + 2.0;
    if (currGameInput.UpButtonPressed) then
      gameobj1.Position.Y := gameobj1.Position.Y - (elapsedTime*200/1000);
    if (currGameInput.DownButtonPressed) then
      gameobj1.Position.Y := gameobj1.Position.Y + (elapsedTime*200/1000);


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
