unit ConsoleUI;

interface
uses
  System.SysUtils,
  UParserCommand,
  Types.Base,
  System.Classes,
  Abstractions,
  GUI,
  Types.UI;

type
  TConsoleUI = class(TBaseUI)
  private
    {Fields}
    fversion: string;
    isTerminate: bool;
    {Instances}
    parser: TCommandsParser;
  public
    procedure DoRun;
    procedure DoTerminate;
    procedure RunCommand(Data: TCommandData);
    constructor Create; override;
    destructor Destroy; override;
  end;
implementation

{$REGION 'TConsoleUI'}

constructor TConsoleUI.Create;
begin
  inherited;
  isTerminate := False;
  parser := TCommandsParser.Create;
end;

destructor TConsoleUI.Destroy;
begin
  parser.Free;
  inherited;
end;

procedure TConsoleUI.RunCommand(Data: TCommandData);
begin
  case Data.CommandName of
    TCommandsNames.help:
    begin
    end;
    TCommandsNames.node:
    begin
    end;
  end;
end;

procedure TConsoleUI.DoRun;
var
  inputString: string;
  args: strings;
begin
  TThread.CreateAnonymousThread(procedure
  begin
    while not isTerminate do
    begin
      readln(inputString);
      args.SetStrings(inputString);
      RunCommand(parser.TryParse(args));
    end;
  end).Start;

  while not isTerminate do
  begin
    CheckSynchronize(100);
  end;
end;

procedure TConsoleUI.DoTerminate;
begin
  isTerminate := True;
end;
{$ENDREGION}

end.
