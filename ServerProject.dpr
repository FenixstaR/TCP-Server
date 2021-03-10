program ServerProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Server in 'Server.pas' {ServerForm},
  TestUConnectedClient in 'AutoTests\TestUConnectedClient.pas',
  IHandlerCore in 'AppCore\NetCore\IHandlerCore.pas',
  UAbstractClient in 'AppCore\NetCore\UAbstractClient.pas',
  UClient in 'AppCore\NetCore\UClient.pas',
  UConnectedClient in 'AppCore\NetCore\UConnectedClient.pas',
  UNetCore in 'AppCore\NetCore\UNetCore.pas',
  UServer in 'AppCore\NetCore\UServer.pas';

{$APPTYPE GUI}
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
