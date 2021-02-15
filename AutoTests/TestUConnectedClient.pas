unit TestUConnectedClient;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, System.Generics.Collections, System.SysUtils, System.Threading,
  UConnectedClient, System.Types, System.Net.Socket, System.Classes;

type
  TAsyncRes = class(TInterfacedObject, IAsyncResult)
    function GetAsyncContext: TObject;
    function GetAsyncWaitEvent: TMultiWaitEvent;
    function GetCompletedSynchronously: Boolean;
    function GetIsCompleted: Boolean;
    function GetIsCancelled: Boolean;
    function Cancel: Boolean;
    property AsyncContext: TObject read GetAsyncContext;
    property AsyncWaitEvent: TMultiWaitEvent read GetAsyncWaitEvent;
    property CompletedSynchronously: Boolean read GetCompletedSynchronously;
    property IsCompleted: Boolean read GetIsCompleted;
    property IsCancelled: Boolean read GetIsCancelled;
    constructor Create;
    destructor Destroy;
  end;

  TestTConnectedClient = class(TTestCase)
  strict private
    FConnectedClient: TConnectedClient;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestConnected;
    procedure TestCallBack;
    procedure TestStartReceive;
    procedure TestSendMessage;
  end;

var
  ClientSocket, ServerSocket: TSocket;

implementation

procedure TestTConnectedClient.SetUp;
begin
  ClientSocket := TSocket.Create(TSocketType.TCP);
  ServerSocket := TSocket.Create(TSocketType.TCP);
  FConnectedClient := TConnectedClient.Create(ClientSocket);
end;

procedure TestTConnectedClient.TearDown;
begin
  FConnectedClient.Free;
  FConnectedClient := nil;
end;

procedure TestTConnectedClient.TestConnected;
var
  ReturnValue: Boolean;
begin
  ReturnValue := FConnectedClient.Connected;
  // TODO: Validate method results
end;

procedure TestTConnectedClient.TestCallBack;
var
  ASyncResult: IAsyncResult;
begin
  ASyncResult := TAsyncRes.Create;
  FConnectedClient.CallBack(ASyncResult);
  // TODO: Validate method results
end;

procedure TestTConnectedClient.TestStartReceive;
begin
  FConnectedClient.StartReceive;
  // TODO: Validate method results
end;

procedure TestTConnectedClient.TestSendMessage;
var
  AData: TArray<System.Byte>;
begin
  // TODO: Setup method call parameters
  FConnectedClient.SendMessage(AData);
  // TODO: Validate method results
end;

{ TAsyncRes }

function TAsyncRes.Cancel: Boolean;
begin

end;

constructor TAsyncRes.Create;
begin

end;

destructor TAsyncRes.Destroy;
begin

end;

function TAsyncRes.GetAsyncContext: TObject;
begin

end;

function TAsyncRes.GetAsyncWaitEvent: TMultiWaitEvent;
begin

end;

function TAsyncRes.GetCompletedSynchronously: Boolean;
begin

end;

function TAsyncRes.GetIsCancelled: Boolean;
begin

end;

function TAsyncRes.GetIsCompleted: Boolean;
begin

end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTConnectedClient.Suite);
end.

