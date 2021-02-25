unit Types.Base;

interface
uses
  System.StrUtils;
type
  int = integer;
  bool = boolean;
  Strings = TArray<string>;
  StringsHelper = record helper for Strings
    procedure SetStrings(const AValue: string);
    function Length: integer;
    function AsString(const Splitter: string): string;
    function IsEmpty:bool;
  end;

implementation


{ StringsHelper }

function StringsHelper.AsString(const Splitter: string): string;
var
  Value: string;
begin
  Result := '';
  for Value in Self do
    Result := Result + Splitter + Value;
end;

procedure StringsHelper.SetStrings(const AValue: string);
begin
  Self := SplitString(AValue,' ');
end;

function StringsHelper.IsEmpty: bool;
begin
  Result := Length = 0;
end;

function StringsHelper.Length: integer;
begin
  Result := System.Length(Self);
end;

end.
