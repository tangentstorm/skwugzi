unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LazFreeTypeFontCollection,
  BGRABitmap, BGRABitmapTypes, BGRATextFX;

type

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    bmp:TBGRABitmap;
    fnt:Array[byte] of TBGRABitmap;
  public

  end;

var
  Form1: TForm1;

const CW:byte=14; CH:byte=26; FH:byte=24;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i:byte;
begin
  bmp:= TBGRABitmap.Create(ClientWidth, ClientHeight, BGRAPixelTransparent);
  for i := 0 to 255 do fnt[i] := TBGRABitmap.Create(CW,CH, BGRAPixelTransparent);
  for i := 32 to 127 do with fnt[i] do begin
    FontName := 'Consolas';
    FontHeight := FH;
    FontQuality := fqSystemClearType;
    FontAntialias:= true;
    TextOut(1,0, chr(i), BGRAWhite);
  end;
end;

procedure TForm1.FormClick(Sender: TObject);
begin
  Timer1.Enabled:= not Timer1.Enabled;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  bmp.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
  var i,j,gh,gw,gx,gy:Integer;
begin
  bmp.FillRect(0, 0, ClientWidth, ClientHeight, BGRABlack, dmSet);
  gx := (ClientWidth  mod cw) div 2; gw := ClientWidth  div cw;
  gy := (ClientHeight mod ch) div 2; gh := ClientHeight div ch;
  for j := 0 to gh-1 do for i := 0 to gw-1 do begin
    bmp.FillRect(gx+i*CW, gy+j*CH, gx+(i+1)*CW, gy+(j+1)*CH, TColor($7f7f7f and Random($ffffff)));
    bmp.PutImage(gx+i*CW, gy+j*CH, fnt[33+byte(Random(94))], dmDrawWithTransparency);
  end;
  bmp.Draw(Canvas, 0, 0, true);
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Repaint;
end;

end.

