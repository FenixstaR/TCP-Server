program ServerProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  UNetCore in 'UNetCore.pas',
  UUICore in 'UUICore.pas',
  IHandlerCore in 'IHandlerCore.pas',
  UServer in 'UServer.pas',
  UConnectedClient in 'UConnectedClient.pas',
  Server in 'Server.pas' {ServerForm},
  TestUConnectedClient in 'AutoTests\TestUConnectedClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
