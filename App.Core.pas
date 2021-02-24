unit App.Core;

interface
uses
  System.Classes,
  Abstractions,
  ConsoleUI,
  GUI;

type
  TAppCore = class(TInterfacedObject,IAppCore)
  private
    UI: TBaseUI;
  public
    procedure DoRun;
    procedure ShowMessage(AMessage: string);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TAppCore }

constructor TAppCore.Create;
begin
  UI := TConsoleUI.Create;
  UI.ShowMessage := ShowMessage;
end;

destructor TAppCore.Destroy;
begin
  UI.Free;
  inherited;
end;

procedure TAppCore.DoRun;
begin
  UI.ShowMessage('Hello World');
end;

procedure TAppCore.ShowMessage(AMessage: string);
var
  str: string;
begin
  WriteLn(AMessage);
  ReadLn(str);
end;

end.
