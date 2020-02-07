unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts;

type
  SGameInput = record
    LeftButtonPressed: boolean;
    RightButtonPressed: boolean;
    UpButtonPressed: boolean;
    DownButtonPressed: boolean;
  end;

  TClientForm = class(TForm)
    gameobj1: TRectangle;
    gameLoopTimer: TTimer;
    ClientLayout: TLayout;
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
  ClientForm: TClientForm;
  currGameInput: SGameInput;

implementation

{$R *.fmx}


procedure TClientForm.FormKeyDown(Sender: TObject; var Key: Word;
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

end;

procedure TClientForm.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
  vkLeft: currGameInput.LeftButtonPressed := False;
  vkRight: currGameInput.RightButtonPressed := False;
  vkUp: currGameInput.UpButtonPressed := False;
  vkDown: currGameInput.DownButtonPressed := False;
  end;

end;

procedure TClientForm.OnGameLoopTick(Sender: TObject);
begin
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

end.
