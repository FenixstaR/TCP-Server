unit UParserCommand;

interface
uses
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  UCommandLineParser,
  Types.Base,
  Types.UI;

type
  TCommandsParser = class
    private
      FDelegate: TProc<strings>;
      Commands: TObjectDictionary<TCommandsNames,TCommandLinePattern>;
    public
      function TryParse(const args: strings): TCommandData;
      constructor Create;
      destructor Destroy; override;
  end;
implementation


{$Region 'TCommandsParser'}

constructor TCommandsParser.Create;
begin
  Commands := TObjectDictionary<TCommandsNames,TCommandLinePattern>.Create;
  Commands.Add(TCommandsNames(0),TCommand.WithName('help').HasParameter('commandname',''));
end;

destructor TCommandsParser.Destroy;
begin
  Commands.Free;
  inherited;
end;

function TCommandsParser.TryParse(const args: strings): TCommandData;
var
  PatternCommand: TCommandLinePattern;
begin
  case TCommandsNames.AsCommand(LowerCase(args[0])) of
    TCommandsNames.help:
    begin
      if Commands.TryGetValue(TCommandsNames.Help,PatternCommand) then
        Result := PatternCommand.Parse(args);
    end;
    TCommandsNames.node:
    begin
      if Commands.TryGetValue(TCommandsNames.node,PatternCommand) then
        Result := PatternCommand.Parse(args);
    end
    else
     TThread.Synchronize(TThread.Current,procedure begin raise Exception.Create('Error syntax command! No command with name: ' + quotedstr(args[0]))end);
  end;
end;
{$ENDREGION}
end.
