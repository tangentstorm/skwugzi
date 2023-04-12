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
    JLang1: TJLang;
    jPrompt: TEdit;
    jTerm: TListBox;
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
    JDo('ARGV_z_=:,<''''');
  end;
end;

procedure TJLangForm.JLang1JWr(s: PJS);
  var line : string;
begin
  for line in SplitString(string(s), #10) do with JLangForm do begin
    jTerm.AddItem(line, Nil);
    jTerm.ItemIndex := jTerm.Items.Count-1;
    jTerm.MakeCurrentVisible;
  end
end;

procedure TJLangForm.jPromptKeyPress(Sender: TObject; var Key: char);
begin
  case key of
    #27 : JPrezForm.ShowOnTop;
    #13 : begin
            jTerm.AddItem('  ' + jPrompt.Text, Nil);
            JLang1.JDo(jPrompt.Text);
          end
  end
end;

procedure TJLangForm.jTermKeyPress(Sender: TObject; var Key: char);
begin
  if key = #27 then JPrezForm.ShowOnTop;
end;

end.

