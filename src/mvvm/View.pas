unit View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Data.Bind.Components, Data.Bind.DBScope,
  ViewModels.ViewModel, Data.Bind.Controls, Data.Bind.EngExt, Vcl.Bind.DBEngExt,
  Vcl.Bind.Grid, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Data.Bind.Grid, Vcl.Buttons, Vcl.Bind.Navigator, Data.DB, Interfaces.IView;

type
  TMainView = class(TForm, IView)  { TForm inherits from TInterfacedObject (checked)}
    StringGrid1: TStringGrid;
    Image1: TImage;
    Edit1: TEdit;
    Memo1: TMemo;
    BindSourceDB1: TBindSourceDB;
    NavigatorBindSourceDB1: TBindNavigator;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BindSourceDB1SubDataSourceDataChange(Sender: TObject;
      Field: TField);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FViewModel: TViewModel;
  public
    { Public-Deklarationen }
    procedure UpdateData;
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

{ TMainView }

procedure TMainView.BindSourceDB1SubDataSourceDataChange(Sender: TObject;
  Field: TField);
begin
  UpdateData;
end;

procedure TMainView.Button1Click(Sender: TObject);
begin
  FViewModel.DataButton;
end;

procedure TMainView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FViewModel.BioLifeCDS.Close;
  FViewModel.Free;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  FViewModel := TViewModel.Create(self);
  BindSourceDB1.DataSet := FViewModel.BioLifeCDS;
  FViewModel.BioLifeCDS.Open;
end;

procedure TMainView.UpdateData;
begin
  Edit1.Text := FViewModel.Name;
  Memo1.Text := FViewModel.Notes;
  Image1.Picture.Graphic := FViewModel.FishPicture;
end;

end.
