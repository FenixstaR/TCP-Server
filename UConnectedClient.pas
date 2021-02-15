unit UConnectedClient;

interface

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Threading,
  System.Net.Socket,
  System.Generics.Collections;

type
  TConnectedClient = class
  strict private
    Socket: TSocket;
    FHandle: TProc<TBytes>;
    Data: TBytes;
    DataSize: integer;
//    procedure CallBack(const ASyncResult: IAsyncResult);
//    procedure StartReceive;
  public
    property Handle: TProc<TBytes> read FHandle write FHandle;
    function Connected: Boolean;
    procedure CallBack(const ASyncResult: IAsyncResult);
    procedure StartReceive;
    procedure SendMessage(const AData: TBytes);
    constructor Create(ASocket: TSocket);
    destructor Destroy;
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

destructor TConnectedClient.Destroy;
begin
  Socket.Close(Connected);
  Socket.Destroy;
end;

procedure TConnectedClient.CallBack(const ASyncResult: IAsyncResult);
var
  Bytes: TBytes;
begin
  try
    Bytes := Socket.EndReceiveBytes(ASyncResult);
  except
    SetLength(Bytes,0);
  end;

  if Length(Bytes) > 0 then
  begin
    Data := Data + Bytes;
    while True do
    begin
      if DataSize > 0 then
      begin
        if Length(Data) >= DataSize then
        begin
          Handle(Copy(Data,0,DataSize));
          Data := Copy(Data,DataSize,Length(Data)-DataSize);
          DataSize := 0;
        end
        else
          break;
      end
      else
      begin
        if Length(Data)>=SizeOf(integer) then
        begin
          DataSize := Pinteger(@Data)^;
          Data := Copy(Data,SizeOf(DataSize),Length(Data)-SizeOf(DataSize));
        end
        else
          break;
      end;
    end;
    StartReceive;
  end
  else
    Free;
end;

procedure TConnectedClient.SendMessage(const AData: TBytes);
begin
  Socket.Send(AData,Length(AData));
end;

procedure TConnectedClient.StartReceive;
begin
  Socket.BeginReceive(CallBack);
end;

function TConnectedClient.Connected: Boolean;
begin
  try
    Result := TSocketState.Connected in Socket.State;
  finally
    Result := False;
  end;
end;
{$ENDREGION}


end.
