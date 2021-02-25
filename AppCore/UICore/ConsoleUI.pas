unit ConsoleUI;

interface
uses
  UCommandLineParser,
  UParserCommand,
  Types.Base,
  System.Classes,
  Abstractions,
  GUI;

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
    procedure DoCommand(Args: strings);
    constructor Create; override;
    destructor Destroy; override;
  end;
implementation

{$REGION 'TConsoleUI'}
constructor TConsoleUI.Create;
begin
  inherited;
  isTerminate := False;
  parser := TCommandsParser.Create(DoCommand);
end;

destructor TConsoleUI.Destroy;
begin
  parser.Free;
  inherited;
end;

procedure TConsoleUI.DoCommand(Args: strings);
begin

end;

procedure TConsoleUI.DoRun;
var
  inputString: string;
  args: strings;
begin
  while not isTerminate do
  begin
    readln(inputString);
    args.SetStrings(inputString);
    parser.TryParse(args);
  end;
end;

procedure TConsoleUI.DoTerminate;
begin
  isTerminate := True;
end;
{$ENDREGION}

end.
