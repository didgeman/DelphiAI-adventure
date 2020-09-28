unit Models.MainModel;

interface

uses
  System.SysUtils, System.Classes;

type


  TMainModel = class(TDataModule)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainModel: TMainModel;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
