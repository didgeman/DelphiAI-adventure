program Workbench;

uses
  Vcl.Forms,
  Views.MainForm in 'src\views\Views.MainForm.pas' {MainForm},
  Views.DrawFrame in 'src\views\Views.DrawFrame.pas' {DrawFrame: TFrame},
  Controller.DrawingCtrl in 'src\Controller\Controller.DrawingCtrl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
