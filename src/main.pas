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
    procedure OnGameLoopTick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;
  currGameInput: SGameInput;

{ module procs and functions since they are app-wide unique anyway }
{ if they should be obj-bound, a kind of Main-Class-Obj have to be invented }
procedure startGame();
procedure stopGame();

implementation

{$R *.fmx}

var
  IsGameRunning: Boolean;


procedure startGame();
begin
  IsGameRunning := True;
end;

procedure stopGame();
begin
  IsGameRunning := False;
end;


{--- START  Win event handlers  ---}

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
      gameobj1.Position.Y := gameobj1.Position.Y - 2.0;
    if (currGameInput.DownButtonPressed) then
      gameobj1.Position.Y := gameobj1.Position.Y + 2.0;


    { change state because of game rules, physics... }


    { render ?? implicit }
  end;

end;

initialization
begin
  IsGameRunning := True;
end;

end.
