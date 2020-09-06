program Workbench;

uses
  Vcl.Forms,
  Views.MainForm in 'src\views\Views.MainForm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
