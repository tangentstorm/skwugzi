unit uaudioform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  EditBtn, acs_audio, acs_file, acs_mixer;

type

  { TAudioForm }

  TAudioForm = class(TForm)
    AcsAudioIn1: TAcsAudioIn;
    AcsAudioOut1: TAcsAudioOut;
    AcsFileIn1: TAcsFileIn;
    AcsFileOut1: TAcsFileOut;
    OutputDeviceCombo: TComboBox;
    FileNameEdit1: TFileNameEdit;
    InputDeviceCombo: TComboBox;
    StopButton: TButton;
    PlayButton: TButton;
    RecordButton: TButton;
    procedure FileNameEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OutputDeviceComboChange(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure RecordButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
  private

  public

  end;

var
  AudioForm: TAudioForm;

implementation

{$R *.lfm}

{ TAudioForm }

procedure TAudioForm.RecordButtonClick(Sender: TObject);
begin
  AcsFileOut1.Run;
end;

procedure TAudioForm.PlayButtonClick(Sender: TObject);
begin
  AcsAudioOut1.Run;
end;

procedure TAudioForm.FormCreate(Sender: TObject);
var i : integer;
begin
  for i := 0 to AcsAudioIn1.DeviceCount-1 do begin
    InputDeviceCombo.AddItem(AcsAudioIn1.DeviceInfo[i].DeviceName, Nil);
    if AcsAudioIn1.Device = i then InputDeviceCombo.ItemIndex := i;
  end;
  for i := 0 to AcsAudioOut1.DeviceCount-1 do begin
    OutputDeviceCombo.AddItem(AcsAudioOut1.DeviceInfo[i].DeviceName, Nil);
    if AcsAudioOut1.Device = i then OutputDeviceCombo.ItemIndex := i;
  end;
end;

procedure TAudioForm.OutputDeviceComboChange(Sender: TObject);
begin
  AcsAudioOut1.Device := OutputDeviceCombo.ItemIndex;
end;

procedure TAudioForm.FileNameEdit1Change(Sender: TObject);
begin
  AcsFileIn1.FileName:=FileNameEdit1.FileName;
  AcsFileOut1.FileName:=FileNameEdit1.FileName;
end;

procedure TAudioForm.StopButtonClick(Sender: TObject);
begin
  AcsFileOut1.Stop;
  AcsAudioOut1.Stop;
end;

end.

