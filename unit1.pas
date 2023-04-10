unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LazFreeTypeFontCollection,
  BGRABitmap, BGRABitmapTypes, BGRATextFX,
  jlang, jkvm;

type

  { TForm1 }

  TForm1 = class(TForm)
    JKVM1: TJKVM;
    Timer1: TTimer;
    procedure JKVM1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.JKVM1Click(Sender: TObject);
begin
  Timer1.Enabled:= not Timer1.Enabled;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin Repaint;
end;

end.

