unit ujprezform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics,
  Dialogs, ExtCtrls,
  LazFreeTypeFontCollection,
  BGRABitmap, BGRABitmapTypes, BGRATextFX,
  jkvm, ujlangform;

type

  { TJPrezForm }

  TJPrezForm = class(TForm)
    JKVM1: TJKVM;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure JKVM1KeyPress(Sender: TObject; var Key: char);
    procedure JKVM1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  end;

var
  JPrezForm: TJPrezForm;


implementation

{$R *.lfm}

{ TJPrezForm }

procedure TJPrezForm.JKVM1Click(Sender: TObject);
begin Timer1.Enabled:= not Timer1.Enabled;
end;

procedure TJPrezForm.JKVM1KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #27 { escape } then JLangForm.ShowOnTop;
end;

procedure TJPrezForm.FormCreate(Sender: TObject);
begin
  with JLangForm.JLang1 do begin
    JDo('load ''tangentstorm/j-kvm/vid''');
    JDo('coinsert ''kvm''');
    JDo('1!:44 ''d:/ver/jprez''');
    with JKVM1 do JDo(Format('gethw_vt_ =: {{ %d %d }}', [GridH, GridW]));
    JDo('load ''jprez.ijs''');
  end

end;


procedure TJPrezForm.Timer1Timer(Sender: TObject);
begin Repaint;
end;

end.

