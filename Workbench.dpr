program Workbench;

uses
  FastMM4,
  Vcl.Forms,
  Views.MainForm in 'src\views\Views.MainForm.pas' {MainForm},
  Views.DrawFrame in 'src\views\Views.DrawFrame.pas' {DrawFrame: TFrame},
  Controller.DrawingCtrl in 'src\Controller\Controller.DrawingCtrl.pas',
  Models.MainModel in 'src\models\Models.MainModel.pas' {MainModel: TDataModule},
  ShapeCHierarch in 'src\models\ShapeCHierarch.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainModel, MainModel);
  Application.Run;
end.
