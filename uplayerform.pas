unit uplayerform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, EditBtn,
  PasLibVlcPlayerUnit;

type

  { TPlayerForm }

  TPlayerForm = class(TForm)
    FileNameEdit1: TFileNameEdit;
    vlc: TPasLibVlcPlayer;
    procedure FileNameEdit1AcceptFileName(Sender: TObject; var Value: String);
    procedure FileNameEdit1Change(Sender: TObject);
    procedure FileNameEdit1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  PlayerForm: TPlayerForm;

implementation

{$R *.lfm}

{ TPlayerForm }

procedure TPlayerForm.FileNameEdit1Change(Sender: TObject);
begin

end;

procedure TPlayerForm.FileNameEdit1EditingDone(Sender: TObject);
begin
  vlc.Play(fileNameEdit1.FileName);
end;

procedure TPlayerForm.FileNameEdit1AcceptFileName(Sender: TObject;
  var Value: String);
begin
  vlc.Play(value)
end;

procedure TPlayerForm.FormCreate(Sender: TObject);
begin

end;

end.

