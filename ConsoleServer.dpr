program ConsoleServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Abstractions in 'AppCore\Abstractions.pas',
  App.Core in 'AppCore\App.Core.pas',
  GlobalsVariable in 'AppCore\GlobalsVariable.pas',
  Types.Base in 'AppCore\Types.Base.pas',
  ConsoleUI in 'AppCore\UICore\ConsoleUI.pas',
  GUI in 'AppCore\UICore\GUI.pas',
  UCommandLineParser in 'AppCore\UICore\UCommandLineParser.pas',
  UParserCommand in 'AppCore\UICore\UParserCommand.pas',
  Types.UI in 'AppCore\UICore\Types.UI.pas',
  IHandlerCore in 'AppCore\NetCore\IHandlerCore.pas',
  UAbstractClient in 'AppCore\NetCore\UAbstractClient.pas',
  UClient in 'AppCore\NetCore\UClient.pas',
  UConnectedClient in 'AppCore\NetCore\UConnectedClient.pas',
  UNetCore in 'AppCore\NetCore\UNetCore.pas',
  UServer in 'AppCore\NetCore\UServer.pas',
  BlockChainCore in 'AppCore\BlockChain\BlockChainCore.pas';

begin
  try
    AppCore := TAppCore.Create;
    AppCore.DoRun;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

//program ConsoleServer;
//
//{$APPTYPE CONSOLE}
//{$R *.res}
//
//uses
//  System.SysUtils,
//  GlobalsVariable in 'GlobalsVariable.pas',
//  Abstractions in 'Abstractions.pas',
//  ConsoleUI in 'ConsoleUI.pas',
//  GUI in 'GUI.pas',
//  App.Core in 'App.Core.pas';
//
//begin
//  try
//    AppCore := TAppCore.Create;
//    AppCore.DoRun;
//  except
//    on E: Exception do
//      Writeln(E.ClassName, ': ', E.Message);
//  end;
//
//end.
