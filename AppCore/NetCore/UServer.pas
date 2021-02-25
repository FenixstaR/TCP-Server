unit UServer;

interface

uses
  UConnectedClient,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections,
  System.SyncObjs;

type
  TServer = class
  strict private
    FAcceptHandle: TProc<TConnectedClient>;
    HideActiveStatus: boolean;
    Socket: TSocket;
    ServerStoped: TEvent;
    procedure AcceptCallback(const ASyncResult: IAsyncResult);
    procedure DoWaitStopServer;
  public
    property isActive: boolean read HideActiveStatus;
    property AcceptHandle: TProc<TConnectedClient> read FAcceptHandle write FAcceptHandle;
    procedure Start(const AIP: string = '127.0.0.1';APort: Word = 20000);
    procedure Stop;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{$REGION 'TServer'}

constructor TServer.Create;
begin
  Socket := TSocket.Create(TSocketType.TCP);
  ServerStoped:=TEvent.Create;
end;

destructor TServer.Destroy;
begin
  try
    if isActive then
    begin
      DoWaitStopServer;
      Socket.Close(True);
    end;
  finally
    Socket.Free;
  end;
end;

procedure TServer.DoWaitStopServer; //�������� ���� ����������� ����� �����������, ��� ����������� �� ������ ����� ��������� ������.
begin
  HideActiveStatus := False;
  if not (ServerStoped.WaitFor(1000) = TWaitResult.wrSignaled) then
    ServerStoped.SetEvent;
end;

procedure TServer.Start(const AIP: string = '127.0.0.1';APort: Word = 20000);
begin
  ServerStoped.ResetEvent;
  HideActiveStatus := True;

  Socket.Listen(AIP,'',APort);
  Socket.BeginAccept(AcceptCallback,100);
end;

procedure TServer.Stop;
begin
  if isActive then
  begin
    DoWaitStopServer;
    Socket.Close(True)
  end;
end;

procedure TServer.AcceptCallback(const ASyncResult: IAsyncResult);  //������� � ������� ����� ������ ����������� ����� �������� �����������
var
  AcceptedSocket: TSocket;
  ConnectedClient: TConnectedClient;
begin
  if not HideActiveStatus then
  begin
    ServerStoped.SetEvent;
    Exit;
  end;

  AcceptedSocket := nil;
  AcceptedSocket := Socket.EndAccept(ASyncResult);
  if AcceptedSocket <> nil then
  begin
    ConnectedClient := TConnectedClient.Create(AcceptedSocket);
    FAcceptHandle(ConnectedClient);
  end;
  Socket.BeginAccept(AcceptCallback,100);
end;
{$ENDREGION}


end.
