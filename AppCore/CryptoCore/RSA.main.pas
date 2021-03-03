unit RSA.main;

interface
  uses
    System.SysUtils
    , RSA.cEncrypt
    , RSA.cHugeInt
    ;

type
  TPrivateKey = TRSAPrivateKey;
  TPublicKey = TRSAPublicKey;

const
  errPrivKeyChSm = 'Checksum does not match';
  errHexToByte = 'Invalid hex string';
  errInvalidKeySize = 'Invalid key size';

//******************************************************************************
procedure GenPrivKey(const KeySize: Integer; var PrK: TPrivateKey);
procedure FinalizePrivKey(var PrK: TPrivateKey);

procedure PrivKeyToBytes(const PrK: TPrivateKey; var b: TBytes);
procedure BytesToPrivKey(const b: TBytes; var PrK: TPrivateKey);

procedure PrivKeyToBytes_lt(const PrK: TPrivateKey; var b: TBytes);
procedure BytesToPrivKey_lt(const b: TBytes; var PrK: TPrivateKey);

//******************************************************************************
procedure GenPubKey(const PrK: TPrivateKey; var PbK: TPublicKey);
procedure FinalizePubKey(var PbK: TPublicKey);
procedure PubKeyToBytes(const PbK: TPublicKey; var b: TBytes);
procedure BytesToPubKey(const b: TBytes; var PbK: TPublicKey);
//******************************************************************************
procedure RSAPrKEncrypt(const PrK: TPrivateKey; const Data: TBytes; var Res: TBytes);
procedure RSAPbKEncrypt(const PbK: TRSAPublicKey; const Data: TBytes; var Res: TBytes);

procedure RSAPrKDecrypt(const PrK: TPrivateKey; const Data: TBytes; var Res: TBytes);
procedure RSAPbKDecrypt(const PbK: TPublicKey; const Data: TBytes; var Res: TBytes);
//******************************************************************************
//function HugeWordToBytes(const hw: HugeWord; var Res: TBytes): Integer;
procedure HugeWordToBytes(const hw: HugeWord; var Res: TBytes);
procedure BytesToHugeWord(const Data: TBytes; var Res: HugeWord);
//******************************************************************************
function BytesToHex(const dat: TBytes):string;
function xHexToBin(const HexStr: String): TBytes;
//******************************************************************************
function Checksum(const dat: TBytes):Word;
//******************************************************************************

implementation

function Checksum(const dat: TBytes):Word;
const
  m = 64;
var
  tmp, res: Word;
  i: Integer;
begin
  res:= 0;
  tmp:= 0;
  for i:= 0 to Length(dat) - 1 do
    begin
      if (i mod m = 0) then
      begin
        res:= res xor tmp;
        //res:= res + tmp;
        tmp:= 0;
      end
      else
      begin
        tmp:= tmp + dat[i] * (i mod m + 1);
      end;
    end;
  res:= res xor tmp;
  //res:= res + tmp;
  Result:= res;
end;

function ByteToHex(InByte:byte):string;
const
  Digits: array[0..15] of char = '0123456789ABCDEF';
begin
  result := digits[InByte shr 4] + digits[InByte and $0F];
end;

function BytesToHex(const dat: TBytes):string;
var
  i,len: Integer;
begin
  Result:= '';
  len:= Length(dat);
  for i:= 0 to len - 1 do Result:=Result + ByteToHex(dat[i]);
end;

function xHexToBin(const HexStr: String): TBytes;
const HexSymbols = '0123456789ABCDEF';
var i, J, k: integer;
    B: Byte;
begin

  {$IFDEF POSIX}
    k:= 0;
  {$ELSE}
    k:=1;
  {$ENDIF}
  SetLength(Result, (Length(HexStr) + 1) shr 1);
  B:= 0;
  if Length(HexStr) < 2 then
  begin
    SetLength(Result, 0);
    //raise ERSA.Create(errHexToByte);
    Exit;
  end;
  i :=  0;
  //while I < Length(HexStr) - (1 - k) do begin
  while i < Length(HexStr) do begin
    J:= 0;
    while J < Length(HexSymbols) do begin
      if HexStr[i + k] = HexSymbols[J + k] then Break;
      Inc(J);
    end;
    if J = Length(HexSymbols) - (1 - k) then ; // error
    if Odd(i) then
      Result[i shr 1]:= B shl 4 + J
    else
      B:= J;
    Inc(i);
  end;
  if Odd(i) then Result[i shr 1]:= B;
end;

//******************************************************************************
procedure GenPrivKey(const KeySize: Integer; var PrK: TPrivateKey);
begin
  try
    RSAPrivateKeyInit(PrK);
  except
    on e:Exception do
    begin
      exit;
    end;
  end;
  try
    RSAGeneratePrivateKeys(KeySize,PrK);
  except
    on e:Exception do
    begin
      exit;
    end;
  end;
end;

procedure FinalizePrivKey(var PrK: TPrivateKey);
begin
  RSAPrivateKeyFinalise(PrK);
end;

procedure FinalizePubKey(var PbK: TRSAPublicKey);
begin
  RSAPublicKeyFinalise(PbK);
end;

procedure PrivKeyToBytes(const PrK: TPrivateKey; var b: TBytes);
{
var
  i,k: Integer;
  Res: TBytes;
  tmp: HugeWord;
begin
  //
  HugeWordInit(tmp);
  try

  finally
    SecureHugeWordFinalise(tmp);
  end;
}
var
  s,pos,cnt: Integer;
  tmp: TBytes;
begin
  //
  pos:= 0;
  s:= SizeOf(PrK.KeySize);

  SetLength(b,s);

  Move(PrK.KeySize,b[pos],SizeOf(PrK.KeySize));
  Inc(pos,SizeOf(PrK.KeySize));

  //------------------------------------------
  HugeWordToBytes(PrK.Modulus,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.Exponent,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.PublicExponent,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.Prime1,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.Prime2,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.Phi,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.Exponent1,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.Exponent2,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------

  HugeWordToBytes(PrK.Coefficient,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));

end;

procedure PrivKeyToBytes_lt(const PrK: TPrivateKey; var b: TBytes);
var
  s,pos,cnt: Integer;
  tmp: TBytes;
  chsm: Word;
begin
  //
  pos:= 0;
  s:= SizeOf(PrK.KeySize);

  SetLength(b,s);

  Move(PrK.KeySize,b[pos],SizeOf(PrK.KeySize));
  Inc(pos,SizeOf(PrK.KeySize));

  //------------------------------------------
  HugeWordToBytes(PrK.Modulus,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.Exponent,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  HugeWordToBytes(PrK.PublicExponent,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);
  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));
  //------------------------------------------
  chsm:= Checksum(b);
  Inc(s,SizeOf(Word));
  SetLength(b,s);
  Move(chsm,b[pos],SizeOf(Word));

//  HugeWordToBytes(PrK.Coefficient,tmp);
//  Inc(s,Length(tmp) + SizeOf(cnt));
//  SetLength(b,s);
//  cnt:= Length(tmp);
//  Move(cnt,b[pos],SizeOf(cnt));
//  Inc(pos,SizeOf(cnt));
//  Move(tmp[0],b[pos],Length(tmp));

end;

procedure BytesToPrivKey(const b: TBytes; var PrK: TPrivateKey);
var
  s,pos,cnt,ks: Integer;
  tmp: TBytes;
begin

  if Length(b) < 16 then
    Exit;
  RSAPrivateKeyInit(PrK);

  pos:= 0;

  Move(b[pos],PrK.KeySize,SizeOf(PrK.KeySize));
  Inc(pos,SizeOf(PrK.KeySize));

  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Modulus);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Exponent);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.PublicExponent);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Prime1);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Prime2);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Phi);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Exponent1);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Exponent2);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Coefficient);
end;

procedure BytesToPrivKey_lt(const b: TBytes; var PrK: TRSAPrivateKey);
var
  s,pos,cnt,ks: Integer;
  tmp: TBytes;
begin

  if Length(b) < 16 then
    Exit;
  RSAPrivateKeyInit(PrK);

  pos:= 0;

  Move(b[pos],PrK.KeySize,SizeOf(PrK.KeySize));
  if PrK.KeySize<>512 then raise Exception.Create(errInvalidKeySize);
  Inc(pos,SizeOf(PrK.KeySize));

  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Modulus);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Exponent);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.PublicExponent);
  //------------------------------------------
//  Move(b[pos],cnt,SizeOf(cnt));
//  Inc(pos,SizeOf(cnt));
//  SetLength(tmp,cnt);
//  Move(b[pos],tmp[0],cnt);
//  Inc(pos,cnt);
//  BytesToHugeWord(tmp, PrK.Prime1);
  //------------------------------------------
//  Move(b[pos],cnt,SizeOf(cnt));
//  Inc(pos,SizeOf(cnt));
//  SetLength(tmp,cnt);
//  Move(b[pos],tmp[0],cnt);
//  Inc(pos,cnt);
//  BytesToHugeWord(tmp, PrK.Prime2);
  //------------------------------------------
//  Move(b[pos],cnt,SizeOf(cnt));
//  Inc(pos,SizeOf(cnt));
//  SetLength(tmp,cnt);
//  Move(b[pos],tmp[0],cnt);
//  Inc(pos,cnt);
//  BytesToHugeWord(tmp, PrK.Phi);
  //------------------------------------------
//  Move(b[pos],cnt,SizeOf(cnt));
//  Inc(pos,SizeOf(cnt));
//  SetLength(tmp,cnt);
//  Move(b[pos],tmp[0],cnt);
//  Inc(pos,cnt);
//  BytesToHugeWord(tmp, PrK.Exponent1);
  //------------------------------------------
//  Move(b[pos],cnt,SizeOf(cnt));
//  Inc(pos,SizeOf(cnt));
//  SetLength(tmp,cnt);
//  Move(b[pos],tmp[0],cnt);
//  Inc(pos,cnt);
//  BytesToHugeWord(tmp, PrK.Exponent2);
  //------------------------------------------
//  Move(b[pos],cnt,SizeOf(cnt));
//  Inc(pos,SizeOf(cnt));
//  SetLength(tmp,cnt);
//  Move(b[pos],tmp[0],cnt);
//  Inc(pos,cnt);
//  BytesToHugeWord(tmp, PrK.Coefficient);
end;
//******************************************************************************
procedure BytesToPrivKey_lt2(const b: TBytes; var PrK: TPrivateKey);
var
  s,pos,cnt,ks: Integer;
  tmp: TBytes;
  chsm,chsm2: Word;
begin

  if Length(b) < 16 then
  begin
    RSAPrivateKeyFinalise(PrK);
    Exit;
  end;

  SetLength(tmp,Length(b) - SizeOf(Word));
  Move(b[0],tmp[0],Length(b) - SizeOf(Word));
  chsm:= Checksum(tmp);
  Move(b[Length(b) - SizeOf(Word)],chsm2,SizeOf(Word));

  if chsm <> chsm2 then
  begin
    RSAPrivateKeyFinalise(PrK);
    raise Exception.Create(errPrivKeyChSm);
  end;

  RSAPrivateKeyFinalise(PrK);
  RSAPrivateKeyInit(PrK);

  pos:= 0;

  Move(b[pos],PrK.KeySize,SizeOf(PrK.KeySize));
  Inc(pos,SizeOf(PrK.KeySize));

  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Modulus);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.Exponent);
  //------------------------------------------
  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);
  BytesToHugeWord(tmp, PrK.PublicExponent);
  //------------------------------------------


end;
//******************************************************************************
procedure GenPubKey(const PrK: TPrivateKey; var PbK: TPublicKey);
begin
  RSAPublicKeyInit(PbK);
  RSAGeneratePublicKeys(PrK,PbK);
end;

procedure PubKeyToBytes(const PbK: TPublicKey; var b: TBytes);
var
  s,pos,cnt: Integer;
  tmp: TBytes;
begin
  //
  pos:= 0;
  s:= SizeOf(PbK.KeySize);

  SetLength(b,s);

  Move(PbK.KeySize,b[pos],SizeOf(PbK.KeySize));
  Inc(pos,SizeOf(PbK.KeySize));


  HugeWordToBytes(PbK.Modulus,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));

  SetLength(b,s);

  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));
  Inc(pos,Length(tmp));

  HugeWordToBytes(PbK.Exponent,tmp);
  Inc(s,Length(tmp) + SizeOf(cnt));
  SetLength(b,s);


  cnt:= Length(tmp);
  Move(cnt,b[pos],SizeOf(cnt));
  Inc(pos,SizeOf(cnt));
  Move(tmp[0],b[pos],Length(tmp));

end;

procedure BytesToPubKey(const b: TBytes; var PbK: TPublicKey);
var
  pos,cnt: Integer;
  tmp: TBytes;
begin
  if Length(b) < 16 then
    Exit;
//  RSAPublicKeyFinalise(PbK);
  RSAPublicKeyInit(PbK);

  pos:= 0;

  Move(b[pos],PbK.KeySize,SizeOf(PbK.KeySize));
  Inc(pos,SizeOf(PbK.KeySize));

  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(PbK.KeySize));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);

  BytesToHugeWord(tmp, PbK.Modulus);

  Move(b[pos],cnt,SizeOf(cnt));
  Inc(pos,SizeOf(PbK.KeySize));
  SetLength(tmp,cnt);
  Move(b[pos],tmp[0],cnt);
  Inc(pos,cnt);

  BytesToHugeWord(tmp, PbK.Exponent);

end;

//******************************************************************************
procedure RSAPrKEncrypt(const PrK: TPrivateKey; const Data: TBytes; var Res: TBytes);
var
  L,L2:integer;
begin
  //
  L:= Length(Data);
  L2 := RSACipherMessageBufSize(PrK.KeySize);
  SetLength(Res, L2);
  RSAEncrypt(rsaetPKCS1, PrK, Pchar(Data)^,L,Pchar(Res)^,L2);
end;

procedure RSAPbKEncrypt(const PbK: TRSAPublicKey; const Data: TBytes; var Res: TBytes);
var
  L,L2:integer;
begin
  //
  L:= Length(Data);
  L2 := RSACipherMessageBufSize(PbK.KeySize);
  SetLength(Res, L2);
  RSAEncrypt_PbK(rsaetPKCS1, PbK, Pchar(Data)^,L,Pchar(Res)^,L2);
end;

procedure RSAPrKDecrypt(const PrK: TPrivateKey; const Data: TBytes; var Res: TBytes);
var
  i, L, N: Integer;
begin
  //
  L := Length(Data);
  N := RSACipherMessageBufSize(PrK.KeySize);
  SetLength(Res, N);
  N := RSADecrypt_PrK(rsaetPKCS1, PrK, PChar(Data)^, L, PChar(Res)^, N);
  SetLength(Res, N);
end;

procedure RSAPbKDecrypt(const PbK: TPublicKey; const Data: TBytes; var Res: TBytes);
var
  i, L, N: Integer;
begin
  //
  L := Length(Data);
  N := RSACipherMessageBufSize(PbK.KeySize);
  SetLength(Res, N);
  N := RSADecrypt(rsaetPKCS1, PbK, PChar(Data)^, L, PChar(Res)^, N);
  SetLength(Res, N);
end;

//******************************************************************************
procedure HugeWordToBytes(const hw: HugeWord; var Res: TBytes);
//function HugeWordToBytes(const hw: HugeWord; var Res: TBytes): Integer;
var i, j, L, pos : Integer;
    P : PLongWord;
    F : LongWord;
begin
  Pos:= 0;
  if HugeWordIsZero(hw) then
    begin
      SetLength(Res,1);
      Res[0] := 0;
      exit;
    end;
  L := hw.Used;
  //SetLength(Res, SizeOf(Integer)*2 + L * 8);
  SetLength(Res, SizeOf(Integer)*2 + L * SizeOf(F));

  Move(hw.Used,Res[pos],SizeOf(Integer));
  Inc(Pos, SizeOf(hw.Used));
  Move(hw.Alloc,Res[pos],SizeOf(Integer));
  Inc(Pos, SizeOf(hw.Alloc));

  Move(hw.Data^, Res[pos], L * HugeWordElementSize);
  {
  P := hw.Data;
  //Inc(P, L - 1);
  for I := 0 to L - 1 do
    begin
      F := P^;

      Move(F,Res[pos],SizeOf(F));

      Inc(Pos, SizeOf(F));
      Inc(P);
    end;
  }
  //Result:= Pos;
end;

procedure BytesToHugeWord(const Data: TBytes; var Res: HugeWord);
var i, j, L, pos : Integer;
    P : PLongWord;
    F : LongWord;
begin
  Pos:= 0;

  Move(Data[pos],Res.Used,SizeOf(Integer));
  Inc(Pos, SizeOf(Res.Used));
  Move(Data[pos],Res.Alloc,SizeOf(Integer));
  Inc(Pos, SizeOf(Res.Alloc));

  //GetMem(Res.Data, Res.Used * HugeWordElementSize);
  HugeWordAlloc(Res,Res.Used);

  L := Res.Used;

  Move(Data[pos], Res.Data^, L * HugeWordElementSize);
  {
  P := Res.Data;
  //Inc(P, L - 1);
  for I := 0 to L - 1 do
    begin
      F := P^;

      Move(Data[pos],F,SizeOf(F));

      Inc(Pos, SizeOf(F));
      Inc(P);
    end;
  }
end;

end.
