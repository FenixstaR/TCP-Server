unit App.Core;

interface
uses
  UCommandLineParser,
  Types.Base,
  System.Classes,
  Abstractions,
  ConsoleUI,
  GUI;

type
  TAppCore = class(TInterfacedObject,IAppCore)
  private
    isTerminate: bool;
    UI: TBaseUI;
  public
    procedure Terminate;
    procedure DoRun;
    procedure ShowMessage(AMessage: string);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TAppCore }

constructor TAppCore.Create;
begin
{$IFDEF CONSOLE}
  UI := TConsoleUI.Create;
{$ENDIF}
{$IFDEF GUI}
  UI := TGUI.Create;
{$ENDIF}
  UI.ShowMessage := ShowMessage;
end;

destructor TAppCore.Destroy;
begin
  UI.Free;
  inherited;
end;

procedure TAppCore.DoRun;
begin
  TConsoleUI(UI).DoRun;
end;

procedure TAppCore.ShowMessage(AMessage: string);
begin
  WriteLn(AMessage);
end;

procedure TAppCore.Terminate;
begin
  isTerminate := True;
end;

end.
