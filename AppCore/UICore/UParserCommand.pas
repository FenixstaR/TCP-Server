unit UParserCommand;

interface
uses
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  Types.Base,
  UCommandLineParser;

type
  TCommands = (help, node);

  TCommandsHelper = record helper for TCommands
    class function InType(ACommand: string): bool; static;
    class function AsCommand(ACommand: string): TCommands; static;
  end;

  TCommandsParser = class
    private
      FDelegate: TProc<strings>;
      Commands: TObjectDictionary<TCommands,TCommandLinePattern>;
    public
      procedure TryParse(const args: strings);
      constructor Create(GeneralDelegate: TProc<strings>);
      destructor Destroy; override;
  end;
implementation



{$Region 'CommandsHelper'}

class function TCommandsHelper.AsCommand(ACommand: string): TCommands;
begin
  Result := TCommands(GetEnumValue(TypeInfo(TCommands),ACommand));
end;

class function TCommandsHelper.InType(ACommand: string): bool;
begin
  Result := GetEnumValue(TypeInfo(TCommandsHelper),ACommand).ToBoolean;
end;
{$ENDREGION}

{$Region 'TCommandsParser'}

constructor TCommandsParser.Create(GeneralDelegate: TProc<strings>);
begin
  FDelegate := GeneralDelegate;
  Commands := TObjectDictionary<TCommands,TCommandLinePattern>.Create;
  Commands.Add(TCommands(0),TCommand.WithName('help').HasDelegate(FDelegate));
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
  case TCommands.AsCommand(LowerCase(args[0])) of
    TCommands.Help:
    begin
      if Commands.TryGetValue(TCommands.Help,PatternCommand) then
        PatternCommand.Parse(args).Run;
    end;
    TCommands.node:
    begin
      if Commands.TryGetValue(TCommands.node,PatternCommand) then
        PatternCommand.Parse(args).Run;
    end;
  end;
end;
{$ENDREGION}
end.
