unit UUICore;

interface
type
  TShortCommands = (start, stop, re, ch, i, h);

  TLongCommands = (change, info, help);

  IUICore = interface
    procedure ShowMessage(AMessage: string);
  end;

implementation

{ TUI }

end.
