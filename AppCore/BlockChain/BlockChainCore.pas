unit BlockChainCore;

interface
uses
  Types.Base,
  Types.Meta,
  System.SysUtils,
  System.Hash;
type
  TTransactionType = (RegestrationWallet);

  TIndexData = record
    Index: Int64;
    Vesion: TVersion;
    Size: integer;
  end;

  TWallet = record
    WalletName: array [0..31] of byte;
    WalletPasswordHash: array [0..31] of byte;
  end;

  TTransaction<T: record> = record
    TransactionType: TTransactionType;
    TimeStamp: TDateTime;
    Data: T;
    Signature: TBytes;
  end;

  TBlockHeader = record
    Version: TVersion;
    PreviosBlockHash: THashSHA2;
    ThisBlockHash: THashSHA2;
    TimeStamp: TDateTime;
  end;

  TBaseBlock<T:record> = record
    Size: integer;
    Header: TBlockHeader;
    Transaction: T;
    SignedIt: TBytes;
    Signature: TBytes;
    ValidatorSignature: array of TBytes;
  end;

  TBaseBlock1<T:record> = record
    Size: integer;
    Header: TBlockHeader;
    Transaction: T;
    SignedIt: TBytes;
    Signature: TBytes;
    ValidatorSignature: array of TBytes;
  end;


  TChainBase<T,T1: record> = class
  private
    Name: string;
    Path: string;
    IndexFile:TIndexData;
    ArrayOfIndexData: array of TIndexData;
  public
    function GetBlock(Index: integer): T; overload;
    constructor Create;
    destructor Destroy; override;
  end;

  TChainBase1 = class
  private
    Name: string;
    Path: string;
    IndexFile:TIndexData;
    BaseBlock:TBaseBlock;
    BaseBlock1:TBaseBlock1;

    ArrayOfIndexData: array of TIndexData;
  public
    function GetBlock(Index: integer): T; overload;
    constructor Create;
    destructor Destroy; override;
  end;

  TBlockChainCore = class

  end;

implementation


{ TChainBase<T> }

{ TChainBase<T, T1> }

constructor TChainBase<T, T1>.Create;
begin

end;

destructor TChainBase<T, T1>.Destroy;
begin

  inherited;
end;

function TChainBase<T, T1>.GetBlock(Index: integer): T;
begin

end;

end.
