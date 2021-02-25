unit App.Core;

interface
uses
  UCommandLineParser,
  Types.Base,
  System.SysUtils,
  System.Classes,
  Abstractions,
  ConsoleUI,
  GUI;

type
  TAppCore = class(TInterfacedObject,IAppCore)
  private
    isTerminate: bool;
    UI: TBaseUI;
    {Procedures}
    procedure AppException(Sender: TObject);
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
  ApplicationHandleException := AppException;
  UI.ShowMessage := ShowMessage;
end;

procedure TAppCore.AppException(Sender: TObject);
var O: TObject;
begin
  O:=ExceptObject;
  if O is Exception then
  begin
    if not (O is EAbort) then ShowMessage(Exception(O).Message)
  end else
    System.SysUtils.ShowException(O,ExceptAddr);
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
  TThread.Synchronize(nil,procedure begin WriteLn(AMessage)end);
end;

procedure TAppCore.Terminate;
begin
  isTerminate := True;
end;

end.
