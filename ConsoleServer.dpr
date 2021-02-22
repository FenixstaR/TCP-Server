program ConsoleServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  UCommandLineParser in 'UCommandLineParser.pas',
  UHandlerResultComandLineParse in 'UHandlerResultComandLineParse.pas',
  Types.Base in 'Types.Base.pas';

begin
  try

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
