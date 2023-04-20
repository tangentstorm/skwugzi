unit ujlangform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StrUtils,
  Forms, Controls, Graphics, Dialogs, StdCtrls,
  ujlang;

type

  { TJLangForm }

  TJLangForm = class(TForm)
  published
    JLang1: TJLang;
    jPrompt: TEdit;
    jTerm: TListBox;
    function JLang1JWd(x: TJI; a: PJA; var res: PJA; const loc:String): TJI;
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

uses ujprezform, uaudioform;

{$R *.lfm}

{ TJLangForm }

procedure TJLangForm.FormCreate(Sender: TObject);
begin
  if not ujlang.InitFromEnv then begin
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

const
  WD_PLAYAUDIO = 8000;
  WD_OPEN_FILE = 8010;

function TJLangForm.JLang1JWd(x: TJI; a: PJA; var res: PJA; const loc:String): TJI;
  var s : String =''; pc : Pchar; i: integer;
begin
  { // debug print of the message sent with (11!:x)y from j
  WriteStr(s, 'JWd(x:', x,
     ', a:[k: ',a^.k, ' f: ',a^.flag, ' m: ',a^.m,
     ' t: ',a^.t, ' c: $',HexStr(a^.c,16), ' n: ',a^.n,
     ' r: $',HexStr(a^.r,16), '], loc:', QuotedStr(loc),')');
  res := nil; result := 0;
  AddLine(s);}
  { handler for literal string }
  if a^.t = JT_LIT then begin
    pc := pchar(@(a^.v));
    if a^.n > 0 then for i := 0 to a^.n-1 do begin
      s += pc^; inc(pc);
    end;
  end;
  { commands for this frontend }
  case x of
    // 0 :  // what to call this?
    //  if s='qwd' then result := @
    WD_PLAYAUDIO :
      begin
        AudioForm.WavePath.FileName:=s; AudioForm.PlayAudio
      end;
    WD_OPEN_FILE : JPrezForm.OpenDialog1.Execute;
  end;
  res := nil; result := 0;
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

