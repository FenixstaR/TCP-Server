unit UConnectedClient;

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
  TConnectedClient = class(TBaseTCPClient)
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

{$REGION 'TConnectedClient'}

constructor TConnectedClient.Create(ASocket: TSocket);
begin
  Socket := ASocket;
  DataSize := 0;
  SetLength(Data,DataSize);
  StartReceive;
end;

procedure TConnectedClient.Disconnect;
begin
  Socket.Close(True);
end;

procedure TConnectedClient.Connect(const AIP: string; APort: Word);
begin
  //
end;

{$ENDREGION}


end.
