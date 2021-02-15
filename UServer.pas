unit UServer;

interface

uses
  UConnectedClient,
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections;

type
  TServer = class
  strict private
    FAcceptHandle: TProc<TConnectedClient>;
    Socket: TSocket;
    procedure AcceptCallback(const ASyncResult: IAsyncResult);
  public
    property AcceptHandle: TProc<TConnectedClient> read FAcceptHandle write FAcceptHandle;
    procedure Start(const AIP: string = '127.0.0.1';APort: Word = 20000);
    procedure Stop;
    constructor Create;
    destructor Destroy;
  end;

implementation

{$REGION 'TServer'}

constructor TServer.Create;
begin
  Socket := TSocket.Create(TSocketType.TCP);
end;

destructor TServer.Destroy;
begin
  Try
    Socket.Close(True);
  Finally
    Socket.Free;
  End;
end;

procedure TServer.Start(const AIP: string = '127.0.0.1';APort: Word = 20000);
begin
  Socket.Listen(AIP,'',APort);
  Socket.BeginAccept(AcceptCallback,100);
end;

procedure TServer.Stop;
begin
  if TSocketState.Connected in Socket.State then
    Socket.Close(True)
end;

procedure TServer.AcceptCallback(const ASyncResult: IAsyncResult);
var
  Sock: TSocket;
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


end.
