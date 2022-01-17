program GUICentral;

uses
  FastMM4 in 'src\FastMM4.pas',
  {$IFDEF DEBUG}
  FastMM4DataCollector in 'src\FastMM4DataCollector.pas',
  FastMM4LockFreeStack in 'src\FastMM4LockFreeStack.pas',
  FastMM4Messages in 'src\FastMM4Messages.pas',
  {$ENDIF }
  System.StartUpCopy,
  FMX.Forms,
  main in 'src\main.pas' {MainForm},
  u_Game in 'src\u_Game.pas',
  RegularPolygon in 'src\gui\RegularPolygon.pas',
  frmHousingUseCase in 'src\gui\frmHousingUseCase.pas' {HousingForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
