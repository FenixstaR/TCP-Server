unit ConsoleUI;

interface
uses
  Abstractions;

type
  TConsoleUI = class(TBaseUI)
  private
    FVersion: string;
  public
    procedure DoRun;
    procedure DoTerminate;
  end;
implementation

{$REGION 'TConsoleUI'}
procedure TConsoleUI.DoRun;
begin

end;

procedure TConsoleUI.DoTerminate;
begin

end;
{$ENDREGION}

end.
