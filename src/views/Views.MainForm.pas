unit Views.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.StdStyleActnCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Views.DrawFrame;

type
  /// represents top most window and therefore kind of view host
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    MnuFile: TMenuItem;
    StatusBar: TStatusBar;
    Panel1: TPanel;
    DrawFrame1: TDrawFrame;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

end.
