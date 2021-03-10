unit Client;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Net.Socket,
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
  UConnectedClient;

type
  TClientForm = class(TForm)
    IPEdit: TEdit;
    IPLabel: TLabel;
    MsgMemo: TMemo;
    PortEdit: TEdit;
    PortLabel: TLabel;
    ConnectButton: TButton;
    SendEdit: TEdit;
    SendButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;
  ConClient: TConnectedClient;
  Socket: TSocket;

implementation

{$R *.fmx}

procedure TClientForm.ConnectButtonClick(Sender: TObject);
begin
  Socket.Connect('','127.0.0.1', '', 20000);
end;

procedure TClientForm.FormCreate(Sender: TObject);
begin
  Socket := TSocket.Create(TSocketType.TCP);
  ConClient := TConnectedClient.Create(Socket);
end;

procedure TClientForm.SendButtonClick(Sender: TObject);
var
  Bytes: TBytes;
begin
  Bytes := TEncoding.UTF8.GetBytes(SendEdit.Text);
  ConClient.SendMessage(Bytes);
end;

end.
