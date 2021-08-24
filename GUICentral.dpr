program GUICentral;

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF}
  System.StartUpCopy,
  FMX.Forms,
  main {MainForm},
  u_Game;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
