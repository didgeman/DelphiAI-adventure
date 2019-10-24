unit frm_splash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  AdvGroupBox, Vcl.Imaging.pngimage, AdvEdit, AdvLUEd, Vcl.ExtCtrls,
  Vcl.StdCtrls, AdvGlowButton;

type
  TSplashForm = class(TForm)
    AdvGroupBox1: TAdvGroupBox;
    img1: TImage;
    edt2: TAdvLUEdit;
    lbl4: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl1: TLabel;
    lbl5: TLabel;
    btn3: TAdvGlowButton;
    btn4: TAdvGlowButton;
    edt1: TAdvLUEdit;
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure edt2KeyPress(Sender: TObject; var Key: Char);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    ULevel: integer;
    counter: integer;
    function checkPW: integer;
  public
    function execute(var level: integer; Aname: string; Version: string)
      : string; { Public-Deklarationen }
  end;

var
  frm_Login: TSplashForm;

implementation

{$R *.dfm}

procedure TSplashForm.btn3Click(Sender: TObject);
begin
 modalresult := mrcancel;
end;

procedure TSplashForm.btn4Click(Sender: TObject);
begin
  lbl4.caption := '';
  if Trim(edt1.Text) = '' then
    showmessage('bitte Usernamen eingeben')
  else
  begin
    if checkPW = -1 then
    begin
      lbl4.caption := 'falsches Passwort';
      edt2.Text := '';
      edt2.SetFocus;
      inc(counter);
    end
    else
    begin
      modalresult := mrok;
    end;
    if counter > 2 then
      modalresult := mrcancel; // mrok;
  end;

end;

function TSplashForm.checkPW: integer;
begin
  ULevel := 1;
  Result := ULevel;
end;

procedure TSplashForm.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    edt2.SetFocus;
end;

procedure TSplashForm.edt2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btn4Click(self);
end;

function TSplashForm.execute(var level: integer; Aname: string;
  Version: string): string;
begin

  level := -1;
  edt1.Text := Aname;
  lbl3.caption := Version;
  Result := '';
  showmodal;
  if frm_Login.modalresult = mrok then
  begin
    level := ULevel;
    Result := edt1.Text;
  end;
end;

end.  { implementation }
