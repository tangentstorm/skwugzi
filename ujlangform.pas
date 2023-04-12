unit ujlangform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StrUtils,
  Forms, Controls, Graphics, Dialogs, StdCtrls,
  jlang;

type

  { TJLangForm }

  TJLangForm = class(TForm)
  published
    JLang1: TJLang;
    jPrompt: TEdit;
    jTerm: TListBox;
    procedure jTermSelectionChange(Sender: TObject; User: boolean);
    procedure AddLine(s:String);
    procedure JLang1JWr(s: PJS);
    procedure FormCreate(Sender: TObject);
    procedure jPromptKeyPress(Sender: TObject; var Key: char);
    procedure jTermKeyPress(Sender: TObject; var Key: char);
  end;

var
  JLangForm: TJLangForm;

implementation

uses ujprezform;

{$R *.lfm}

{ TJLangForm }

procedure TJLangForm.FormCreate(Sender: TObject);
begin
  if not jlang.InitFromEnv then begin
    ShowMessage('Unable to load J: missing or invalid J_HOME environment variable.');
    Halt;
  end;
  with jlang1 do begin
    JInit;
    JDo('9!:7 [ (16+i.11){a.  NB. box drawing characters');
  end;
end;

procedure TJLangForm.jTermSelectionChange(Sender: TObject; User: boolean);
  var line:string;
begin
  if user then begin
    line := JTerm.Items[JTerm.ItemIndex];
    jPrompt.Text :=  line.trim(' ');
    ActiveControl := jPrompt;
  end;
end;

procedure TJLangForm.AddLine(s: String);
begin
  with JLangForm.JTerm do begin
    AddItem(s, Nil);
    ItemIndex := Items.Count-1;
    MakeCurrentVisible;
  end
end;

procedure TJLangForm.JLang1JWr(s: PJS);
  var line : string;
begin
  for line in SplitString(string(s), #10) do AddLine(line)
end;

procedure TJLangForm.jPromptKeyPress(Sender: TObject; var Key: char);
begin
  case key of
    #27 : JPrezForm.ShowOnTop;
    #13 : begin AddLine('  ' + jPrompt.Text); JLang1.JDo(jPrompt.Text) end;
  end
end;

procedure TJLangForm.jTermKeyPress(Sender: TObject; var Key: char);
begin
  if key = #27 then JPrezForm.ShowOnTop;
end;

end.

