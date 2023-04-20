unit ujprezform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics,
  Dialogs, ExtCtrls,
  LazFreeTypeFontCollection, LCLType,
  BGRABitmap, BGRABitmapTypes, BGRATextFX,
  ujlangform, uaudioform,
  ujlang, ujkvm;

type

  { TJPrezForm }

  TJPrezForm = class(TForm)
  published
    JKVM1: TJKVM;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    procedure OnJLangReady;
    procedure JKVM1KeyDown(Sender: TObject; var Key: Word; {%H-}Shift: TShiftState);
    procedure JKVM1KeyPress(Sender: TObject; var Key: char);
    procedure JKVM1Click(Sender: TObject);
    procedure JKVM1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OpenDialog1SelectionChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  protected
    procedure DrawJPrezScreen;
    procedure SendKeyToJPrez(const ch, fns:string);
  end;

var
  JPrezForm: TJPrezForm;


implementation

{$R *.lfm}

var XTermColors : Array of TColor;

procedure MakeXTermColors;
  var i,r,g,b:integer; ramp : Array of integer; color:TColor;
begin
  { ansi colors, but in bgr layout }
  XTermColors := [
    $000000, // black
    $0000aa, // red
    $00aa00, // green
    $00aaaa, // dark yellow ( note: not vga brown! )
    $aa0000, // blue
    $aa00aa, // magenta
    $aaaa00, // cyan
    $aaaaaa, // gray
    $555555, // dark gray
    $5555ff, // light red
    $55ff55, // light green
    $55ffff, // yellow
    $ff5555, // light blue
    $ff55ff, // light magenta
    $ffff55, // light cyan
    $ffffff];// white
  i := Length(XTermColors);
  // colors 16..231 are a color cube:
  ramp := [ $00, $5F, $87, $AF, $D7, $FF ];
  for b in ramp do for g in ramp do for r in ramp do begin
    color := (r shl 16) xor (g shl 8) xor b;
    Insert(color, XTermColors, i); inc(i);
  end;
  // 232..255 are a black to gray gradiant:
  ramp := [$00, $12, $1C, $26, $30, $3A, $44, $4E,
	   $58, $62, $6C, $76, $80, $8A, $94, $9E,
	   $A8, $B2, $BC, $C6, $D0, $DA, $E4, $EE];
  for i in ramp do begin
    color := (i shl 16) xor (i shl 8) xor i;
    Insert(color, XTermColors, 256); // append to end
  end;
end;

function FixColor(x:int32):TColor;
begin
  if x < 0 then result := XTermColors[-x]
  else result :=  ((x and $000000ff) shl 16)
              xor ((x and $0000ff00))
              xor ((x and $00ff0000) shr 16);
end;

{ TJPrezForm }

procedure TJPrezForm.DrawJPrezScreen;
  var jtype,jrank: TJI; jshape:PJI=nil; jdata:PJI=nil;
      gw,gh,y,x : integer; fg,bg : uint32; ch:WideChar; wp:string;
begin
  JLangForm.JLang1.JDo('render__app _');
  with JLangForm do begin
    JLang1.JDo('XX =: ,(,3 u: CHB__B__app),.(,FGB__B__app),.(,BGB__B__app)');
    JLang1.JGetM(PJS('XX'), jtype,jrank,jshape,jdata);
    gh := JKVM1.GridH;
    gw := JKVM1.GridW;
    for y := 0 to gh-1 do for x := 0 to gw-1 do begin
      // hack for half-box for j-kvm/vm
      ch := widechar(jdata^); inc(jdata);
      fg := FixColor(jdata^); inc(jdata);
      bg := FixColor(jdata^); inc(jdata);
      JKVM1.DrawChar(x,y,ch,fg,bg);
    end;
    if Assigned(AudioForm) then begin
      JLang1.JDo('wp =: wavpath _'); wp := JLang1.JGetStr('wp');
      if AudioForm.WavePath.FileName <> wp then AudioForm.WavePath.FileName := wp;
    end;
  end;
  JKVM1.Repaint;
end;

{ fns should be a j boxed list of names. ex: `'k_x';'k_any'`
   ch is the actual character as a string (or empty string) }
procedure TJPrezForm.SendKeyToJPrez(const ch, fns:string);
begin
  with JLangForm.JLang1 do begin
    JDo('fn =: > {. (#~ 3 = 4!:0) (' + fns + QuotedStr('k_any') + ')');
    JDo('0 0$(fn~)' + QuotedStr(ch));
  end;
end;


procedure TJPrezForm.JKVM1Click(Sender: TObject);
begin
end;


procedure TJPrezForm.JKVM1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key = VK_INSERT) then with AudioForm do begin
    // my keyboard is mechanical and therefore noisy, so use a slight
    // delay to avoid recording the sound of the key going down.
    if OkToRecord then RecordAudioAfter(400)
  end
end;

procedure TJPrezForm.JKVM1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  var fns : string = ''; kept : boolean = false;
  procedure keep(s:string);
  begin kept := true; fns += QuotedStr(s) + ';'; end;
begin
  case key of
    VK_A .. VK_Z :
      if ssCtrl in Shift then keep('kc_' + lowercase(chr(byte(key))))
      else if ssAlt in Shift then keep('ka_' + lowercase(chr(byte(key))));
    VK_F1: keep('k_f1');
    VK_F2: keep('k_f2');
    VK_F3: keep('k_f3');
    VK_F4: keep('k_f4');
    VK_F5: keep('k_f5');
    VK_F6: keep('k_f6');
    VK_F7: keep('k_f7');
    VK_F8: keep('k_f8');
    VK_F9: keep('k_f9');
    VK_F10: keep('k_f10');
    VK_F11: keep('k_f11');
    VK_F12: keep('k_f12');
    VK_RETURN: keep('kc_m');
    VK_BACK: keep('k_bsp');
    VK_TAB: keep('kc_i');
    VK_UP: keep('k_arup');
    VK_DOWN: keep('k_ardn');
    VK_RIGHT: keep('k_arrt');
    VK_LEFT: keep('k_arlf');
    // stop audio recording immediately. it's no good to use the delay
    // trick here because (at least on my keyboard) you hear the click
    // of the key coming up. so you just have to train yourself to not
    // lift your finger until you're done talking.
    VK_INSERT: AudioForm.StopAudio;
    VK_PAUSE: AudioForm.PlayAudio;
  end;
  if kept then begin keep('k_any'); SendKeyToJPrez(' ', fns); end
end;

procedure TJPrezForm.OpenDialog1SelectionChange(Sender: TObject);
begin
  with JLangForm do begin
    // TODO: check for unsaved file.
    AddLine('open file: ' + OpenDialog1.FileName);
    JLang1.JDo('ORG_PATH =: ' + QuotedStr(OpenDialog1.FileName));
    JLang1.JDo('reopen _');
  end;
end;


procedure TJPrezForm.JKVM1KeyPress(Sender: TObject; var Key: char);
  var fns : string = ''; kept : bool = false;
  procedure keep(s:string);
  begin fns += QuotedStr(s) + ';'; kept := true;
  end;
begin
  //   a.{~32+i.3 32  NB. printable ascii characters:
  // !"#$%&'()*+,-./0123456789:;<=>?
  // @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_
  // `abcdefghijklmnopqrstuvwxyz{|}~
  if key = #27 { escape } then begin
    AudioForm.ShowOnTop; JLangForm.ShowOnTop end
  else case key of
    ' ': keep('k_spc');
   // '+': keep('k_plus');
   // '''': keep('k_quote');
    'a'..'z', 'A'..'Z', '0'..'1': keep('k_' + key);
  end;
  // these don't yet have special names in jkvm:
  if (key>#32) and (key<#127) then kept := true;
  if kept then begin keep('k_asc'); SendKeyToJPrez(key, fns); end
end;

procedure TJPrezForm.OnJLangReady;
begin
  with JLangForm.JLang1 do begin
    JDo('load ''tangentstorm/j-kvm/vid''');
    JDo('coinsert ''kvm''');
    JDo('1!:44 ''d:/ver/jprez''');
    with JKVM1 do JDo(Format('gethw_vt_ =: {{ %d %d }}', [GridH, GridW]));
    JDo('load ''jprez.ijs''');
    JDo('goto 0');
  end;
  Timer1.Enabled:=true;
end;

procedure TJPrezForm.Timer1Timer(Sender: TObject);
begin
  JLangForm.JLang1.JDo('step__app _');
  DrawJPrezScreen;
end;

begin
  MakeXTermColors
end.

