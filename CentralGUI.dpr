program CentralGUI;

uses
  Vcl.Forms,
  u_main in 'src\u_main.pas' {MainForm},
  frm_splash in 'src\frm_splash.pas' {frm_Login};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSplashForm, frm_Login);
  {Application.CreateForm(TMainForm, MainForm);}
  Application.Run;
end.
