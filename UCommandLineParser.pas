unit UCommandLineParser;

interface
uses
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  Types.Base;
type
  TCommands = (Help);

  TCommandsHelper = record helper for TCommands
    class function InType(ACommand: string): bool; static;
    class function AsCommand(ACommand: string): TCommands; static;
  end;

  ICommand = interface
    procedure Run;
  end;

  THelpCommand = class(TInterfacedObject, ICommand)
  public
    procedure Run;
    constructor Create(const AName: string);
    destructor Destroy; override;
  end;

  TCommandLinePattern = class
    strict private
      FName: string;
      FParametrs: TList<string>;
      FOptions: TList<string>;
      function TryParse(Args: strings;out Return: ICommand): bool; virtual;
    public
      property Name: string read FName write FName;
      property Parametrs: TList<string> read FParametrs write FParametrs;
      property Options: TList<string> read FOptions write FOptions;
      function HasParameter(const AValue: string): TCommandLinePattern;
      function HasOption(const AValue: string): TCommandLinePattern;
      function Parse(args: strings): ICommand;virtual;
      constructor Create(const AName: string);
      destructor Destroy; override;
  end;

  TCommand = class
    public
      class function WithName(const AName: string): TCommandLinePattern; static;
  end;

  TCommandsParser = class
    private
      Commands: TObjectDictionary<TCommands,TCommandLinePattern>;
    public
      procedure TryParse(const args: strings);
      constructor Create;
      destructor Destroy; override;
  end;
implementation

{$Region 'TCommand'}

class function TCommand.WithName(const AName: string): TCommandLinePattern;
begin
  Result := TCommandLinePattern.Create(AName);
end;

{$ENDREGION}

{$Region 'TCommandLinePattern'}

constructor TCommandLinePattern.Create(const AName: string);
begin
  FName := '';
  FParametrs := TList<string>.Create;
  FOptions := TList<string>.Create;
end;

destructor TCommandLinePattern.Destroy;
begin
  FName := string.Empty;

  FParametrs.Clear;
  FParametrs.Free;

  FOptions.Clear;
  FOptions.Free;

  inherited;
end;

function TCommandLinePattern.HasOption(const AValue: string): TCommandLinePattern;
begin
  Self.Options.Add(AValue);
  Result := Self;
end;

function TCommandLinePattern.HasParameter(const AValue: string): TCommandLinePattern;
begin
  Self.Parametrs.Add(AValue);
  Result := Self;
end;

function TCommandLinePattern.Parse(args: strings): ICommand;
var
  Command: ICommand;
begin
  try
    if TryParse(args,Command) then
      Result:= Command;
  except
    raise Exception.Create('Exception: Incorrect format string!');
  end;

end;

function TCommandLinePattern.TryParse(Args: strings; out Return: ICommand): bool;
  procedure BadResult;
  begin
    Result := False;
    exit;
  end;

var
  Properties: TDictionary<string,string>;
  NextParameterIndex: int;
  Value,FirstParametr,SecondParametr,Name: string;
begin
  Return := nil;

  if Args.IsEmpty then
    BadResult;

  if not (Args[0] = FName) then
    BadResult;

  Properties := TDictionary<string,string>.Create;
  NextParameterIndex := 0;

  for Value in Args do
  begin
    if Value.StartsWith('-') then
    begin

    end
    else
    begin

    end;
  end;

end;

{$ENDREGION}

{$Region 'CommandsHelper'}

class function TCommandsHelper.AsCommand(ACommand: string): TCommands;
begin
  Result := TCommands(GetEnumValue(TypeInfo(TCommandsHelper),ACommand));
end;

class function TCommandsHelper.InType(ACommand: string): bool;
begin
  Result := GetEnumValue(TypeInfo(TCommandsHelper),ACommand).ToBoolean;
end;
{$ENDREGION}

{$Region 'TCommandsParser'}

constructor TCommandsParser.Create;
begin
  Commands := TObjectDictionary<TCommands,TCommandLinePattern>.Create;
  Commands.Add(TCommands(0),TCommand.WithName('Help').HasOption('Command'));
end;

destructor TCommandsParser.Destroy;
begin
  Commands.Free;
  inherited;
end;

procedure TCommandsParser.TryParse(const args: strings);
var
  PatternCommand: TCommandLinePattern;
begin
  if Commands.TryGetValue(TCommands.AsCommand(args[0]),PatternCommand) then
    PatternCommand.Parse(args).Run;
end;
{$ENDREGION}

{$Region 'THelpCommand'}

constructor THelpCommand.Create(const AName: string);
begin

end;

destructor THelpCommand.Destroy;
begin

  inherited;
end;

procedure THelpCommand.Run;
begin

end;
{$ENDREGION}
end.
