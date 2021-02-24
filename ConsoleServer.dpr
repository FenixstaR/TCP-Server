//program ConsoleServer;
//
//{$APPTYPE CONSOLE}
//{$R *.res}
//
//uses
//  System.SysUtils,
//  GlobalsVariable in 'GlobalsVariable.pas',
//  UCommandLineParser in 'UCommandLineParser.pas',
//  UHandlerResultComandLineParse in 'UHandlerResultComandLineParse.pas',
//  Types.Base in 'Types.Base.pas',
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

program ConsoleServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  GlobalsVariable in 'GlobalsVariable.pas',
  Abstractions in 'Abstractions.pas',
  ConsoleUI in 'ConsoleUI.pas',
  GUI in 'GUI.pas',
  App.Core in 'App.Core.pas';

begin
  try
    AppCore := TAppCore.Create;
    AppCore.DoRun;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
