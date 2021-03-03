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
  BlockChainCore in 'AppCore\BlockChain\BlockChainCore.pas',
  Types.Meta in 'AppCore\Types.Meta.pas',
  Crypto.RSA in 'AppCore\CryptoCore\Crypto.RSA.pas',
  CryptoEntity in 'AppCore\CryptoCore\CryptoEntity.pas',
  RSA.cEncrypt in 'AppCore\CryptoCore\RSA.cEncrypt.pas',
  RSA.cHash in 'AppCore\CryptoCore\RSA.cHash.pas',
  RSA.cHugeInt in 'AppCore\CryptoCore\RSA.cHugeInt.pas',
  RSA.cRandom in 'AppCore\CryptoCore\RSA.cRandom.pas',
  RSA.main in 'AppCore\CryptoCore\RSA.main.pas';

begin
  try
    AppCore := TAppCore.Create;
    AppCore.DoRun;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
