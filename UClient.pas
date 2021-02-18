unit UClient;

interface
uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections,
  UAbstractClient;
type
  TClient = class(TBaseTCPClient)
  strict private
    Socket: TSocket;
    FHandle: TProc<TBytes>;
    Data: TBytes;
    DataSize: integer;
  public
    property Handle: TProc<TBytes> read FHandle write FHandle;
    procedure Connect(const AIP: string; APort: Word);
    procedure Disconnect;
    constructor Create(ASocket: TSocket);
  end;

implementation

constructor TClient.Create(ASocket: TSocket);
begin
  Socket := TSocket.Create(TSocketType.TCP,TEncoding.UTF8);
  DataSize := 0;
  SetLength(Data,DataSize);
  StartReceive;
end;

procedure TClient.Disconnect;
begin
  Socket.Close(True);
end;

procedure TClient.Connect(const AIP: string; APort: Word);
begin
  Socket.Connect('',AIP,'',APort);
end;

end.
