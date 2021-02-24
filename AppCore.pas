unit AppCore;

interface

type
  TConsoleReader = class

  end;

  IAppCore = interface
    procedure DoWork(Args: string);
  end;

  TAppCore = class(TInterfacedObject,IAppCore)
    private

    public
      procedure DoWork(Args: string);
  end;

implementation

{ TAppCore }

procedure TAppCore.DoWork(Args: string);
begin

end;

end.
