unit UServer;

interface
uses
  UUI,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections;
type
  TDelegate = reference to procedure(AMessage: string);

  TConnectedClient = class
    strict private
      Socket: TSocket;
      FHandle: TProc<string>;
      procedure CallBack(const ASyncResult: IAsyncResult);
      procedure StartReceive;
    public
      property Handle: TProc<string> read FHandle write FHandle;
      function Connected: Boolean;
      procedure SendMessage(const AMessage: string);
      constructor Create(ASocket: TSocket);
      destructor Destroy;
  end;

  TServer = class
  strict private
    FAcceptHandle: TProc<TConnectedClient>;
    Socket: TSocket;
    procedure AcceptCallback(const ASyncResult: IAsyncResult);
  public
    property AcceptHandle: TProc<TConnectedClient> read FAcceptHandle write FAcceptHandle;
    procedure Start;
    constructor Create;
    destructor Destroy;
  end;

  TNetCore = class
  private
    Server: TServer;
    ConnectedClients: TArray<TConnectedClient>;
    MonitorConnectedClients: TMonitor;
    FUI: IUI;
    procedure SendToUI(AMsg: string);
  public
    property UI: IUI read FUI write FUI;
    procedure Start;
    constructor Create(AUI: IUI);
    destructor Destroy;
  end;

implementation

{$REGION 'TConnectedClient'}

constructor TConnectedClient.Create(ASocket: TSocket);
begin
  Socket := ASocket;
  StartReceive;
end;

destructor TConnectedClient.Destroy;
begin
  Socket.Close(Connected);
  Socket.Destroy;
end;

procedure TConnectedClient.CallBack(const ASyncResult: IAsyncResult);
var
  Msg: TArray<Byte>;
begin
  Msg := Socket.EndReceiveBytes(ASyncResult);
  Handle(TEncoding.UTF8.GetString(MSG));
  StartReceive;
end;

procedure TConnectedClient.SendMessage(const AMessage: string);
begin
  Socket.Send(AMessage);
end;

procedure TConnectedClient.StartReceive;
begin
  Socket.BeginReceive(CallBack);
end;

function TConnectedClient.Connected: Boolean;
begin
  Result := TSocketState.Connected in Socket.State;
end;
{$ENDREGION}

{$REGION 'TServer'}

constructor TServer.Create;
begin
  Socket := TSocket.Create(TSocketType.TCP);
end;

destructor TServer.Destroy;
begin
  Socket.Free;
end;


procedure TServer.Start;
begin
  Socket.Listen('127.0.0.1','',50000);
  Socket.BeginAccept(AcceptCallback,100);
end;

procedure TServer.AcceptCallback(const ASyncResult: IAsyncResult);
var
  sock: TSocket;
  cli: TConnectedClient;
begin
  sock := nil;
  sock := Socket.EndAccept(ASyncResult);
  if sock <> nil then
  begin
    cli := TConnectedClient.Create(sock);
    FAcceptHandle(cli);
  end;
  Socket.BeginAccept(AcceptCallback,100);
end;
{$ENDREGION}

{$REGION 'TNetCore'}

constructor TNetCore.Create(AUI: IUI);
begin
  SetLength(ConnectedClients,0);
  Server := TServer.Create;
  FUI := AUI;
  Server.AcceptHandle := (procedure (ConnectedCli: TConnectedClient)
  begin
    ConnectedCli.Handle := SendToUI;
    ConnectedClients := ConnectedClients + [ConnectedCli];
  end);
  Server.Start;
end;

destructor TNetCore.Destroy;
begin
  SetLength(ConnectedClients,0);
end;

procedure TNetCore.SendToUI(AMsg: string);
begin
  FUI.ShowMessage(AMsg);
end;

procedure TNetCore.Start;
begin
  Server.Start;
end;
{$ENDREGION}

end.
