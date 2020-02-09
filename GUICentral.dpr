program GUICentral;

uses
  System.StartUpCopy,
  FMX.Forms,
  main in 'src\main.pas' {MainForm},
  u_Game in 'src\u_Game.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
