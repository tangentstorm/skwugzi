unit uwsdemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList,
  ExtCtrls, ssockets, wsmessages, wsstream, websocketsclient, uplayerform,
  fpjson, jsonparser;

type

  { TForm1 }

  TForm1 = class(TForm)
    filenameEdit: TEdit;
    recButton: TButton;
    stopButton: TButton;
    playButton: TButton;
    CloseButton: TButton;
    obsMessageBox: TComboBox;
    ConnectButton: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    outputMemo: TMemo;
    SendButton: TButton;
    inputMemo: TMemo;
    Timer1: TTimer;
    procedure CloseButtonClick(Sender: TObject);
    procedure obsMessageBoxChange(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure playButtonClick(Sender: TObject);
    procedure recButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure stopButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    ws: TWebsocketClient;
    com: TWebsocketCommunicator;
    procedure ReceiveMessage(Sender: TObject);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function makeObsRequest(requestType:String):String;
begin
  result := '{"op": 6, "d": {'
  + '"requestType": "' + requestType + '",'
  + '"requestId": "' + requestType + '",'
  + '"requestData": {}}}'
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  ws := TWebsocketClient.Create('localhost',4455,'/');
end;

procedure TForm1.playButtonClick(Sender: TObject);
begin
  uplayerform.PlayerForm.Show;
  with uplayerform.PlayerForm do begin
    vlc.play(StringReplace(filenameEdit.Text, '/', '\', [rfReplaceAll]));
  end;
end;

procedure TForm1.SendButtonClick(Sender: TObject);
begin
  com.WriteStringMessage(inputMemo.Text);
end;

procedure TForm1.stopButtonClick(Sender: TObject);
begin
  Timer1.Interval := 2000;
  Timer1.Enabled := true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  com.WriteStringMessage(makeObsRequest('StopRecord'));
end;

procedure TForm1.recButtonClick(Sender: TObject);
begin
  com.WriteStringMessage(makeObsRequest('StartRecord'));
end;

procedure TForm1.ReceiveMessage(Sender: TObject);
var
  msgs: TWebsocketMessageOwnerList;
  msg: TWebsocketMessage;
begin
  msgs := TWebsocketMessageOwnerList.Create;
  try
    com.GetUnprocessedMessages(msgs);
    for msg in msgs do begin
      if msg is TWebsocketStringMessage then begin
        outputMemo.text := TWebsocketStringMessage(msg).Data
      end
      // TODO: 'pong' msg
    end
  finally
    msgs.Free
  end
end;

procedure TForm1.ConnectButtonClick(Sender: TObject);
begin
  com := ws.Connect(TSocketHandler.Create);
  com.OnReceiveMessage := @ReceiveMessage;
  com.StartReceiveMessageThread;
  inputMemo.Text := '{"op": 1, "d": {"rpcVersion": 1,"eventSubscriptions": 33}}'
end;

procedure TForm1.obsMessageBoxChange(Sender: TObject);
begin
  inputMemo.text :=  makeObsRequest(obsMessageBox.Text)
end;

procedure TForm1.CloseButtonClick(Sender: TObject);
begin
  if assigned(com) then com.Close;
end;

end.

