program MVVM_Minimal;

uses
  FastMM4 in 'src\FastMM4.pas',
  FastMM4DataCollector in 'src\FastMM4DataCollector.pas',
  FastMM4LockFreeStack in 'src\FastMM4LockFreeStack.pas',
  FastMM4Messages in 'src\FastMM4Messages.pas',
  Vcl.Forms,
  View in 'src\mvvm\View.pas' {MainView},
  Models.Model in 'src\mvvm\Models.Model.pas' {DataModel: TDataModule},
  Interfaces.IView in 'src\mvvm\Interfaces.IView.pas',
  ViewModels.ViewModel in 'src\mvvm\ViewModels.ViewModel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
