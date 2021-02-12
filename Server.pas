unit Server;

interface

uses
  UUI,System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.NET.Socket, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  FMX.Memo.Types, UServer;

type
  TServerForm = class(TForm)
    IPLabel: TLabel;
    PortLabel: TLabel;
    IPEdit: TEdit;
    PortEdit: TEdit;
    StartedCheckBox: TCheckBox;
    StartButton: TButton;
    MsgMemo: TMemo;
    StopButton: TButton;
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    { Public declarations }
  end;

  GUI = class(TInterfacedObject,IUI)
    procedure ShowMessage(AMessage: string);
    constructor Create;
    destructor Destroy; override;
  end;

  TConnect = class
  private
    Socket: TSocket;
    Buf: TFDSet;
    Name: String;
  public
    constructor Create(pSocket: TSocket);
    procedure Send(Msg: String);
    procedure Disconnect;
    function Receive: String;
  end;

  TMsgThread = class(TThread)
  private
    OwnerConnect: TConnect;
    IncomingMsg: String;
    procedure PrintMessage;
  protected
    procedure Execute; override;
  end;

  TAcceptThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  ServerForm: TServerForm;
  SSocket, HSocket: TSocket;
  MsgThread: TMsgThread;
  AcceptThread: TAcceptThread;
  ConList, MsgThreadList: TList;
  UI: GUI;

implementation

{$R *.fmx}

procedure TServerForm.FormCreate(Sender: TObject);
begin
  ConList := TList.Create;
  MsgThreadList := TList.Create;
end;

procedure TServerForm.StartButtonClick(Sender: TObject);
var
  IP: String;
  Port: Integer;
  serv: TNetCore;
begin
  UI := GUI.Create;
  serv := TNetCore.Create(UI);
//  if Assigned(SSocket) then
//    SSocket.Free;
//  SSocket := TSocket.Create(TSocketType.TCP);
//  IP := IPEdit.Text;
//  Port := StrToInt(PortEdit.Text);
//  SSocket.Listen(TNetEndPoint.Create(TIPAddress.Create(IP),Port));
//  StartedCheckBox.IsChecked := True;
//  MsgMemo.Lines.Add('Server started...');
//
//  AcceptThread := TAcceptThread.Create;            //поток дл€ прослушки на подключение
//  AcceptThread.Priority := tpNormal;
end;

{ TMsgThread }

procedure TMsgThread.Execute;
var
  IncomingMsg: String;
  i: Integer;
begin
  inherited;

  while True do
  begin
    if Self.Terminated then break;

    Self.OwnerConnect.Buf := TFDSet.Create(Self.OwnerConnect.Socket);
    SSocket.Select(Self.OwnerConnect.Buf,nil,nil,INFINITE);
    Self.IncomingMsg := TConnect(Self.OwnerConnect).Receive;

    ServerForm.MsgMemo.Lines.Add('From ' + Self.OwnerConnect.Name + ': ' + Self.IncomingMsg);
//    Synchronize(PrintMessage);      //тоже вариант, так даже правильнее, наверное

    Sleep(500);

    Self.OwnerConnect.Send('SERVER ECHO');
  end;
end;

procedure TServerForm.StopButtonClick(Sender: TObject);
var
  i: Integer;
begin
  AcceptThread.Terminate;
  for i := 0 to MsgThreadList.Count - 1 do
    TMsgThread(MsgThreadList[i]).Terminate;
  for i := 0 to ConList.Count - 1 do
  begin
    TConnect(ConList[i]).Socket.Close;
    TConnect(ConList[i]).Destroy;
  end;
  ConList.Clear;
  ServerForm.MsgMemo.Lines.Add('Server stoped');
end;

procedure TMsgThread.PrintMessage;
begin
  ServerForm.MsgMemo.Lines.Add('From ' + Self.OwnerConnect.Name + ': ' + Self.IncomingMsg);
end;

{ TAcceptThread }

procedure TAcceptThread.Execute;
var
  NewCon: TConnect;
  FD: TFDSet;
begin
  inherited;

  while True do
  begin
    if AcceptThread.Terminated then break;

    HSocket := SSocket.Accept();
    NewCon := TConnect.Create(HSocket);
    ConList.Add(NewCon);

    ServerForm.MsgMemo.Lines.Add(NewCon.Name + ' connected');
  end;
end;

{ TConnect }

constructor TConnect.Create(pSocket: TSocket);
var
  NewMsgThread: TMsgThread;
begin
  Self.Socket := pSocket;
  Self.Name := pSocket.RemoteAddress + ':' + IntToStr(pSocket.RemotePort);

  NewMsgThread := TMsgThread.Create;     //создаЄм поток дл€ прослушки вход€щих сообщений дл€ нового клиента
  NewMsgThread.OwnerConnect := Self;
  NewMsgThread.Priority := tpNormal;
  MsgThreadList.Add(NewMsgThread);
end;

procedure TConnect.Disconnect;
begin

end;

function TConnect.Receive: String;
begin
  Result := Self.Socket.ReceiveString;
end;

procedure TConnect.Send(Msg: String);
begin
  Self.Socket.Send(Msg);
end;

{ GUI }
constructor GUI.Create;
begin

end;

destructor GUI.Destroy;
begin

  inherited;
end;

procedure GUI.ShowMessage(AMessage: string);
begin
  TThread.Synchronize(nil,procedure begin FMX.Dialogs.ShowMessage(AMessage)end);
end;

end.
