program GUICentral;

uses
  System.StartUpCopy,
  FMX.Forms,
  main in 'src\main.pas' {ClientForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
