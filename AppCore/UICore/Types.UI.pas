unit Types.UI;

interface
uses
  System.StrUtils,
  System.SysUtils,
  System.TypInfo,
  System.Generics.Collections,
  Types.Base;

type
  TCommandsNames = (help, node,check);
  TCommandsHelper = record helper for TCommandsNames
    class function InType(ACommand: string): bool; static;
    class function AsCommand(ACommand: string): TCommandsNames; static;
  end;

  TParametr = record
    Name: string;
    Value: string;
  end;
  TParametrs = TArray<TParametr>;

  TCommandData = record
    CommandName: TCommandsNames;
    Parametrs: TParametrs;
  end;

implementation

{$Region 'CommandsHelper'}

class function TCommandsHelper.AsCommand(ACommand: string): TCommandsNames;
begin
  Result := TCommandsNames(GetEnumValue(TypeInfo(TCommandsNames),ACommand));
end;

class function TCommandsHelper.InType(ACommand: string): bool;
begin
  Result := GetEnumValue(TypeInfo(TCommandsHelper),ACommand).ToBoolean;
end;
{$ENDREGION}
end.
