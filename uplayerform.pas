unit uplayerform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, MPlayerCtrl;

type

  { TPlayerForm }

  TPlayerForm = class(TForm)
    playerControl: TMPlayerControl;
    procedure FormCreate(Sender: TObject);
    procedure playerControlClick(Sender: TObject);
  private

  public

  end;

var
  PlayerForm: TPlayerForm;

implementation

{$R *.lfm}

{ TPlayerForm }

procedure TPlayerForm.FormCreate(Sender: TObject);
begin
  playerControl.MPlayerPath := 'D:\ver\skwugzi\mplayer\mplayer.exe';
end;

procedure TPlayerForm.playerControlClick(Sender: TObject);
begin
  if playerControl.playing then playerControl.Stop
  else playerControl.Play;
end;

end.

