program ServerProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  Server in 'Server.pas' {ServerForm},
  UServer in 'UServer.pas',
  UUI in 'UUI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
