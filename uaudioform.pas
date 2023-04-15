unit uaudioform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  EditBtn, ExtCtrls, acs_audio, acs_file, acs_mixer, acs_classes;

type

  { TAudioForm }

  TAudioForm = class(TForm)
    AcsAudioIn1: TAcsAudioIn;
    AcsAudioOut1: TAcsAudioOut;
    AcsFileIn1: TAcsFileIn;
    AcsFileOut1: TAcsFileOut;
    FileExistsCB: TCheckBox;
    Messages: TListBox;
    OutputDeviceCombo: TComboBox;
    WaitToStop: TTimer;
    WaitToRecord: TTimer;
    WavePath: TFileNameEdit;
    InputDeviceCombo: TComboBox;
    StopButton: TButton;
    PlayButton: TButton;
    RecordButton: TButton;
    procedure AcsAudioOut1Done(Sender: TComponent);
    procedure AcsAudioOut1Progress(Sender: TComponent);
    procedure AcsAudioOut1ThreadException(Sender: TComponent; E: Exception);
    procedure AcsFileOut1Done(Sender: TComponent);
    procedure AcsFileOut1ThreadException(Sender: TComponent; E: Exception);
    procedure WaitToRecordTimer(Sender: TObject);
    procedure WaitToStopTimer(Sender: TObject);
    procedure WavePathChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OutputDeviceComboChange(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure RecordButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
  private
    procedure EnableUI(b:boolean);
    procedure LogMsg(const s:String);

  public
    function OkToRecord:boolean;
    procedure PlayAudio;
    procedure RecordAudio;
    procedure RecordAudioAfter(ms:integer);
    procedure StopAudio;
    procedure StopAudioAfter(ms:integer);

  end;

var
  AudioForm: TAudioForm;

implementation

uses ujprezform;

{$R *.lfm}

{ TAudioForm }

procedure TAudioForm.RecordButtonClick(Sender: TObject);
begin
  RecordAudio;
end;

procedure TAudioForm.PlayButtonClick(Sender: TObject);
begin
  PlayAudio;
end;

procedure TAudioForm.StopButtonClick(Sender: TObject);
begin
  StopAudio;
end;

procedure TAudioForm.EnableUI(b:boolean);
begin
  PlayButton.Enabled := b;
  RecordButton.Enabled := b;
  // important! we have to disable the timer because it can
  // reset the filename on every step, breaking the audio chain.
  JPrezForm.Timer1.Enabled:=b;
end;

procedure TAudioForm.LogMsg(const s:String);
begin
  Messages.AddItem(s, nil);
  Messages.MakeCurrentVisible;
end;

procedure TAudioForm.PlayAudio;
begin
  EnableUI(false);
  AcsAudioOut1.Run;
end;

function TAudioForm.OkToRecord:boolean;
begin
  result := not AcsFileOut1.Active;
end;

procedure TAudioForm.RecordAudio;
begin
  LogMsg('Recording.');
  EnableUI(false);
  AcsFileOut1.Run;
end;

procedure TAudioForm.RecordAudioAfter(ms: integer);
   var s : String;
begin
  WriteStr(s, 'Waiting to record (', ms, ' ms)');
  LogMsg(s);
  EnableUI(false);
  WaitToRecord.Interval:=ms;
  WaitToRecord.Enabled:=true;
end;

procedure TAudioForm.StopAudio;
begin
  AcsFileOut1.Stop;
  AcsAudioOut1.Stop;
  EnableUI(true);
end;

procedure TAudioForm.StopAudioAfter(ms: integer);
  var s : String;
begin
  WriteStr(s, 'Stopping in ', ms, ' ms.');
  LogMsg(s);
  WaitToStop.Interval:=ms;
  WaitToStop.Enabled:=true;
end;


procedure TAudioForm.FormCreate(Sender: TObject);
var i : integer;
begin
  //for i := 0 to AcsAudioIn1.DriversCount-1 do begin
  //  Messages.AddItem(AcsAudioIn1.Drivers[i], nil);
  //end;
  for i := 0 to AcsAudioIn1.DeviceCount-1 do begin
    InputDeviceCombo.AddItem(AcsAudioIn1.DeviceInfo[i].DeviceName, Nil);
    if AcsAudioIn1.Device = i then InputDeviceCombo.ItemIndex := i;
  end;
  //AcsAudioIn1.InBitsPerSample := 16;
  for i := 0 to AcsAudioOut1.DeviceCount-1 do begin
    OutputDeviceCombo.AddItem(AcsAudioOut1.DeviceInfo[i].DeviceName, Nil);
    if AcsAudioOut1.Device = i then OutputDeviceCombo.ItemIndex := i;
  end;
end;

procedure TAudioForm.OutputDeviceComboChange(Sender: TObject);
begin
  AcsAudioOut1.Device := OutputDeviceCombo.ItemIndex;
end;

procedure TAudioForm.WavePathChange(Sender: TObject);
begin
  AcsFileIn1.FileName:=WavePath.FileName;
  AcsFileOut1.FileName:=WavePath.FileName;
  FileExistsCB.Checked:=FileExists(WavePath.FileName);
end;

procedure TAudioForm.AcsAudioOut1Progress(Sender: TComponent);
begin
  // LogMsg('audio out progress')
end;

procedure TAudioForm.AcsAudioOut1Done(Sender: TComponent);
begin
  LogMsg('audio out done');
  EnableUI(true);
end;

procedure TAudioForm.AcsAudioOut1ThreadException(Sender: TComponent; E: Exception);
begin
  LogMsg('EAudioOut: ' + E.message);
end;

procedure TAudioForm.AcsFileOut1Done(Sender: TComponent);
begin
  LogMsg('file out done')
end;

procedure TAudioForm.AcsFileOut1ThreadException(Sender: TComponent; E: Exception);
begin
  Messages.AddItem('EFileOut: ' + E.message, nil);
  Messages.MakeCurrentVisible;
end;

procedure TAudioForm.WaitToRecordTimer(Sender: TObject);
begin
  WaitToRecord.Enabled := False;
  RecordAudio;
end;

procedure TAudioForm.WaitToStopTimer(Sender: TObject);
begin
  WaitToStop.Enabled:= False;
  StopAudio;
end;

end.

