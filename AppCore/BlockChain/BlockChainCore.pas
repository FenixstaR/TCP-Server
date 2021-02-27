unit BlockChainCore;

interface
uses
  Types.Base,
  Types.Meta,
  System.SysUtils,
  System.Hash;
type
  TKey = array [0..31] of Byte;
  TTransactionType = (RegestrationWallet);

  TIndexData = record
    Index: Int64;
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
  end;

  TChainBase<T: record> = record
  private
    Blocks: TArray<T>;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TBlockChainCore = class

  end;

implementation


{ TChainBase<T> }

constructor TChainBase<T>.Create;
begin
  inherited;

end;

destructor TChainBase<T>.Destroy;
begin

  inherited;
end;

end.
