unit UCommandLineParser;

interface
uses
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  Types.Base;
type
  ICommand = interface
    procedure Run;
  end;

  TCommandLinePattern = class
    strict private
      FName: string;
      FParametrs: TList<TPair<string,strings>>;
      FDelegate: TProc<strings>;
      function TryParse(Args: strings;out Return: ICommand): bool; virtual;
    public
      property Name: string read FName write FName;
      property Parametrs: TList<TPair<string,strings>> read FParametrs write FParametrs;
      function HasParameter(const AValue: string; AOptions: strings): TCommandLinePattern;
      function HasDelegate(ADelegate: TProc<strings>): TCommandLinePattern;
      function Parse(args: strings): ICommand;virtual;
      constructor Create(const AName: string);
      destructor Destroy; override;
  end;

  TCommand = class
  public
    class function WithName(const AName: string): TCommandLinePattern; static;
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
  FName := AName;
  FParametrs := TList<TPair<string,strings>>.Create;
end;

destructor TCommandLinePattern.Destroy;
begin
  FName := string.Empty;

  FParametrs.Clear;
  FParametrs.Free;
  inherited;
end;

function TCommandLinePattern.HasParameter(const AValue: string; AOptions: strings): TCommandLinePattern;
var
  Pair: TPair<string,strings>;
begin
  Pair := TPair<string,strings>.Create(AValue, AOptions);
  Self.Parametrs.Add(Pair);
  Result := Self;
end;

function TCommandLinePattern.HasDelegate(ADelegate: TProc<strings>): TCommandLinePattern;
begin
  Self.FDelegate := ADelegate;
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
var
  Value,Parametr,Option,Name: string;
  i: int;
begin
  Return := nil;

  if Args.IsEmpty then
  begin
    Result := False;
    exit;
  end;

  if not (Args[0] = FName) then
  begin
    Result := False;
    exit;
  end;

  i := 1;
  while i < Args.Length - 1 do
  begin
    if Args[i].StartsWith('-') then
    begin
      option := args[i]
    end
    else
      Parametr := args[i];

    inc(i);
  end;
end;

{$ENDREGION}
end.
