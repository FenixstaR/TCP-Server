unit Types.Base;

interface

type
  int = integer;
  bool = boolean;
  Strings = TArray<string>;
  StringsHelper = record helper for Strings
    function Length: integer;
    function AsString: string;
    function IsEmpty:bool;
  end;

implementation


{ StringsHelper }

function StringsHelper.AsString: string;
var
  Value: string;
begin
  Result := '';
  for Value in Self do
    Result := Result + Value;
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
