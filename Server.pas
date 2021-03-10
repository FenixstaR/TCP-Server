unit Server;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Controls.Presentation,
  FMX.Edit,
  UNetCore,
  IHandlerCore,
  UConnectedClient;

type
  TServerForm = class(TForm)
    IPEdit: TEdit;
    IPLabel: TLabel;
    MsgMemo: TMemo;
    PortEdit: TEdit;
    PortLabel: TLabel;
    StartButton: TButton;
    StopButton: TButton;
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TEchoHandler = class(TInterfacedObject,IBaseHandler)
    procedure HandleReceiveData(const ABytes: TBytes);
  end;

var
  ServerForm: TServerForm;
  EchoHandler: TEchoHandler;
  NC: TNetCore;

implementation

{$R *.fmx}

procedure TServerForm.FormCreate(Sender: TObject);
begin
  EchoHandler := TEchoHandler.Create;
  NC := TNetCore.Create(EchoHandler);
end;

procedure TServerForm.StartButtonClick(Sender: TObject);
begin
  NC.Start;
  MsgMemo.Lines.Add('Server started...');
end;

procedure TServerForm.StopButtonClick(Sender: TObject);
begin
  NC.Stop;
  MsgMemo.Lines.Add('Server stoped');
end;

{ TEchoHandler }

procedure TEchoHandler.HandleReceiveData(const ABytes: TBytes);
var
  Msg: String;
begin
  Msg := TEncoding.UTF8.GetString(ABytes);
  ServerForm.MsgMemo.Lines.Add(Msg);
end;

end.
