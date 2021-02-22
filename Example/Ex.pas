unit Ex;

interface

uses
  System.SysUtils, System.Math, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo, FMX.Edit;

type
  Commands = (Help);
  CommandsHelper = record helper for Commands
    function InArray(ACommand: string): boolean;
  end;

  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

type
   TMyClass = record
     payload: integer;
     class operator Add(a, b: TMyClass): TMyClass;      // Addition of two operands of type TMyClass
     class operator Subtract(a, b: TMyClass): TMyclass; // Subtraction of type TMyClass
     class operator Implicit(a: Integer): TMyClass;     // Implicit conversion of an Integer to type TMyClass
     class operator Implicit(a: TMyClass): Integer;     // Implicit conversion of TMyClass to Integer
     class operator Implicit(a: Double): TMyClass;
     class operator Implicit(a: TMyClass): Double;
     class operator Explicit(a: TMyClass): Double;
     class operator Explicit(a: TMyClass): Boolean;
     class operator Inc(a: TMyClass) : TMyClass;
     class operator Dec(a: TMyClass) : TMyClass;
     class operator Negative(a: TMyClass): TMyClass;
     class operator Positive(a: TMyClass): TMyClass;
     class operator LogicalNot(a: TMyClass) : TMyClass;
     class operator LogicalAnd(a: TMyClass; b: Boolean) : Boolean;
     class operator BitwiseAnd(a, b: TMyClass) : TMyClass;
     class operator Equal(a, b: TMyClass) : Boolean;
   end;

// Example implementation of Add
class operator TMyClass.Add(a, b: TMyClass): TMyClass;
var
  returnrec : TMyClass;
begin
  Form1.Memo1.Lines.Add('Add(a, b: TMyClass): TMyClass;');
  returnrec.payload := a.payload + b.payload;
  Result:= returnrec;
end;

// Example implementation of Subtract
class operator TMyClass.Subtract(a, b: TMyClass): TMyClass;
var
  returnrec : TMyClass;
begin
  Form1.Memo1.Lines.Add('Subtract(a, b: TMyClass): TMyClass;');
  returnrec.payload:= a.payload - b.payload;
  Result:= returnrec;
end;

class operator TMyClass.Implicit(a: Integer): TMyClass;
var
  returnrec : TMyClass;
begin
  Form1.Memo1.Lines.Add('Implicit(a: Integer): TMyClass;');
  returnrec.payload:= a;
  Result:= returnrec;
end;

class operator TMyClass.Implicit(a: TMyClass): Integer;
var
  myint : integer;
begin
  Form1.Memo1.Lines.Add('Implicit(a: TMyClass): Integer;');
  myint:= a.payload;
  Result:= myint;
end;

class operator TMyClass.Implicit(a: Double): TMyClass;
var
  returnrec : TMyClass;
begin
  Form1.Memo1.Lines.Add('Implicit(a: Double): TMyClass;');
  returnrec.payload:= Floor(a);
  Result:= returnrec;
end;

class operator TMyClass.Implicit(a: TMyClass): Double;
var
  b : Double;
begin
  Form1.Memo1.Lines.Add('Implicit(a: TMyClass): Double;');
  b:= a.payload;
  Result:= b;
end;

class operator TMyClass.Explicit(a: TMyClass): Double;
var
  b : Double;
begin
  Form1.Memo1.Lines.Add('Explicit(a: TMyClass): Double;');
  b:= a.payload;
  Result:= b;
end;

class operator TMyClass.Explicit(a: TMyClass): Boolean;
begin
  Form1.Memo1.Lines.Add('Explicit(a: TMyClass): Boolean;');
  Result:= True;
end;

class operator TMyClass.Inc(a: TMyClass) : TMyClass;
begin
  Form1.Memo1.Lines.Add('Inc(a: TMyClass) : TMyClass;');
  System.Inc(&a.payload);
  Result:= a;
end;

class operator TMyClass.Dec(a: TMyClass) : TMyClass;
begin
  Form1.Memo1.Lines.Add('Dec(a: TMyClass) : TMyClass;');
  System.Dec(&a.payload);
  Result:= a;
end;

class operator TMyClass.Negative(a: TMyClass): TMyClass;
var
  b : TMyClass;
begin
  Form1.Memo1.Lines.Add('Negative(a: TMyClass): TMyClass;');
  b:= -a.payload;  // Use the implicit conv here?
  Result:= b;
end;

class operator TMyClass.Positive(a: TMyClass): TMyClass;
var
  b : TMyClass;
begin
  Form1.Memo1.Lines.Add('Positive(a: TMyClass): TMyClass;');
  b:= abs(a.payload);  // Use the implicit conv here?
  Result:= b;
end;

class operator TMyClass.LogicalNot(a: TMyClass) : TMyClass;
var
  b : TMyClass;
begin
  Form1.Memo1.Lines.Add('LogicalNot(a: TMyClass): TMyClass;');
  b:= not a.payload;  // Bitwise not because it's an integer.
  Result:= b;
end;

class operator TMyClass.LogicalAnd(a: TMyClass; b: Boolean) : Boolean;
begin
  Form1.Memo1.Lines.Add('LogicalAnd(a: TMyClass; b: Boolean) : Boolean;');
  if (a.payload = 0) then Result:= False
  else Result:= b;
end;

class operator TMyClass.BitwiseAnd(a, b: TMyClass) : TMyClass;
begin
  Form1.Memo1.Lines.Add('BitwiseAnd(a, b: TMyClass): TMyClass;');
  Result:= a.payload and b.payload;  // Bitwise and because it's an integer.
end;

class operator TMyClass.Equal(a, b: TMyClass) : Boolean;
begin
  Form1.Memo1.Lines.Add('Equal(a, b: TMyClass) : Boolean;');
  Result:= (a.payload = b.payload);  // Bitwise and because it's an integer.
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  x, y: TMyClass;
  a, b: Double;
  myint: Integer;
  myBool: Boolean;
begin
  Memo1.Lines.Add('Test: x := 12;');
  x := 12;      // Implicit conversion from an Integer
  myint := x;
  Edit1.Text:= IntToStr(x.payload);
  Memo1.Lines.Add('Test: a: Integer := x;');
  myint := x;      // Implicit conversion to an Integer
  Edit7.Text:= IntToStr(x.payload);
  Memo1.Lines.Add('Test: b:= 12.34567; b := Double(x) + b;');
  b:= 12.34567;
  b := Double(x) + b;      // Explicit conversion from a Double
  Edit5.Text:= FloatToStr(b);
  Memo1.Lines.Add('Test: b:= 12.34567; b := x + b;');
  b:= 12.34567;
  b := x + b;      // Implicit conversion from a Double
  Edit6.Text:= FloatToStr(b);  // and Explicit to a Double
  Memo1.Lines.Add('Test: y := x + x;');
  y := x + x;   // Calls TMyClass.Add(a, b: TMyClass): TMyClass
  Edit2.Text:= IntToStr(y.payload);
  Memo1.Lines.Add('Test: x := x + 100;');
  x := x + 100; // Calls TMyClass.Add(b, TMyClass.Implicit(100))
  Edit3.Text:= IntToStr(x.payload);
  Memo1.Lines.Add('Test: Inc(x);');
  Inc(x); // Calls TMyClass.Inc(a: TMyClass) : TMyClass
  Edit4.Text:= IntToStr(x.payload);
  Memo1.Lines.Add('Test: Dec(x);');
  Dec(x); // Calls TMyClass.Dec(a: TMyClass) : TMyClass
  Edit11.Text:= IntToStr(x.payload);
  Memo1.Lines.Add('Test: y:= -x');
  y:= -x; // Calls TMyClass.Negative(a: TMyClass) : TMyClass
  Edit8.Text:= IntToStr(y.payload);
  Memo1.Lines.Add('Test: y:= +x');
  y:= +x; // Calls TMyClass.Positive(a: TMyClass) : TMyClass
  Edit9.Text:= IntToStr(y.payload);
  Memo1.Lines.Add('Test: y:= not x;');
  y:= not x; // Calls TMyClass.LogicalNot(a: TMyClass) : TMyClass;
  Edit10.Text:= IntToStr(y.payload);
  Memo1.Lines.Add('Test: mybool:= x and True;');
  mybool:= x and True; // Calls TMyClass.LogicalAnd(a: TMyClass; b: Boolean) : Boolean
  Edit12.Text:= BoolToStr(mybool, True);
  Memo1.Lines.Add('Test: y:= x and $1F;');
  y:= x and $1F; // Calls TMyClass.BitwiseAnd(a, b: TMyClass) : TMyClass;
  Edit13.Text:= IntToStr(y.payload);
  Memo1.Lines.Add('Test: BoolToStr(x = y, True);');
  Edit14.Text:= BoolToStr(x = y, True);  // Calls TMyClass.Equals(a, b: TMyClass) : Boolean;
end;
{ CommandsHelper }

function CommandsHelper.InArray(ACommand: string): boolean;
begin
  
end;

end.
