unit IHandlerCore;

interface
uses
  System.SysUtils;

type
  IBaseHandler = interface
    procedure HandleReceiveData(const ABytes: TBytes);
  end;

implementation

end.
