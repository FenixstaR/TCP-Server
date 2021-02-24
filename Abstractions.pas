unit Abstractions;

interface
uses
  System.SysUtils,
  System.Classes;
type
  IAppCore = interface
    procedure DoRun;
  end;

  TBaseUI = class abstract
  private
    procedure EmptyProc;
    procedure EmtyProcStr(str: string);
  protected
    FShowMessage: TProc<string>;
  public
    property ShowMessage: TProc<string> read FShowMessage write FShowMessage;
    procedure DoRun; virtual; abstract;
    procedure DoTerminate;virtual; abstract;
    constructor Create;
    destructor Destroy;
  end;

implementation

{ TBaseUI }

constructor TBaseUI.Create;
begin
  ShowMessage := EmtyProcStr;
end;

destructor TBaseUI.Destroy;
begin
  FShowMessage := nil;
end;

procedure TBaseUI.EmptyProc;
begin

end;

procedure TBaseUI.EmtyProcStr(str: string);
begin

end;

end.
