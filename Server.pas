unit Server;

interface

uses
  UUICore,System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.NET.Socket, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  FMX.Memo.Types, UNetCore;

type
  TServerForm = class(TForm)
    IPLabel: TLabel;
    PortLabel: TLabel;
    IPEdit: TEdit;
    PortEdit: TEdit;
    StartedCheckBox: TCheckBox;
    StartButton: TButton;
    MsgMemo: TMemo;
    StopButton: TButton;
  private

  public
    { Public declarations }
  end;

var
  ServerForm: TServerForm;
  SSocket, HSocket: TSocket;
  ConList, MsgThreadList: TList;
  serv: TNetCore;

implementation

{$R *.fmx}

end.
