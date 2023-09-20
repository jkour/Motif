unit Test.Motif;

interface
uses
  DUnitX.TestFramework, Motif;

type

  [TestFixture]
  TTestMotif = class(TObject)
  private
    fMotif: TMotif;
    procedure OnAdd(const aPattern: string; var aItem: TMotifItem);
  public
    [Setup]
    procedure setup;
    [TearDown]
    procedure tearDown;

    [Test]
    procedure basic;

    [Test]
    procedure multipleSimple;

    [Test]
    procedure delete;

    [Test]
    procedure deleteIntermediate;

    [Test]
    [TestCase ('IE', 'country:IE- 0.25- 0.25','-')]
    [TestCase ('UK', 'country:UK- 0.20- 0.20','-')]
    [TestCase ('DE', 'country:DE- 0.19- 0.19','-')]
    [TestCase ('IE-reduced', 'country:IE, type:reduced-0.135-0.135','-')]
    [TestCase ('IE-food', 'country:IE, type:food-0.048-0.048','-')]
    [TestCase ('UK-food', 'country:UK, type:food-0.0-0.0','-')]
    [TestCase ('DE-reduced', 'country:DE, type:reduced-0.07-0.07','-')]
    [TestCase ('US', 'country:US-0.0-0.0','-')]
    [TestCase ('US-AL', 'country:US, state:AL-0.04-0.04','-')]
    [TestCase ('US-AL', 'country:US, state:AL, city:Montgomery-0.10-0.10','-')]
    [TestCase ('US-NY', 'country:US, state:NY-0.07-0.07','-')]
    procedure countries(const aTag: string; const aRate, aExpected: Double);

    [Test]
    procedure countiesConvoluted;

    [Test]
    procedure glob;
    [Test]
    procedure globBack;
    [Test]
    procedure globFind;

    [Test]
    procedure toUpper;

    [Test]
    procedure listAll;
  end;

implementation

uses
  System.SysUtils, System.Generics.Collections, Quick.Arrays;


{ TTestMotif }

procedure TTestMotif.basic;
var
  x, y: TXArray<string>;
  num: integer;
  list:  TList<TMotifItem>;
begin
  x.Add('x:1');
  y.Add('A');

  x.Add('x:1, y:1');
  y.Add('B');

  x.Add('x:1, y:2');
  y.Add('C');

  x.Add('x:1, y:2, z:3');
  y.Add('D');

  for num:=0 to x.Count - 1 do
    fMotif.add(x[num], y[num]);

  list:=nil;
  for num:=0 to x.Count - 1 do
  begin
    list:=fMotif.find(x[num]);
    Assert.AreEqual(string(y[num]), list[0].Value.AsString, num.ToString);
    FreeAndNil(list);
  end;

  list:= fMotif.find('x:2');
  Assert.AreEqual(0, list.Count, (x.Count + 1).tostring);
  FreeAndNil(list);

  list:= fMotif.find('x:2, y:2');
  Assert.AreEqual(0, list.Count, (x.Count + 2).tostring);
  FreeAndNil(list);

  list:= fMotif.find('y:1');
  Assert.AreEqual(0, list.Count, (x.Count + 3).tostring);
  FreeAndNil(list);

  fMotif.clear;
  fMotif.add('{x:1}', 'M')
        .add('{x:''John''}', 'John');

  list:= fMotif.find('x:1');
  Assert.AreEqual('M', list[0].Value.AsString, '8');
  FreeAndNil(list);

  list:= fMotif.find('x:John');
  Assert.AreEqual('John', list[0].Value.AsString, '9');
  FreeAndNil(list);

  fMotif.clear;
  fMotif.add('', 'R');
  list:= fMotif.find('');
  Assert.AreEqual('R', list[0].Value.AsString, '10');
  FreeAndNil(list);
end;

procedure TTestMotif.delete;
var
  list: TList<TMotifItem>;
begin
  fMotif.add('ABC: 1000', '1')
        .add('XYZ: 2000', '2');

  fMotif.remove('ABC: 1000');

  list:= fMotif.find('XYZ: 2000');
  Assert.AreEqual('2', list[0].Value.AsString, 'remove');
  FreeAndNil(list);
end;

procedure TTestMotif.deleteIntermediate;
var
  list: TList<TMotifItem>;
begin
  fMotif.clear;
  fMotif.add('{a:1, b:2, d:4}', 'XX')
        .add('c:3, d:4', 'YY')
        .add('a:1, b:2', 'X')
        .add('c:3', 'Y');

  fMotif.remove('c:3');

  list:= fMotif.find('c:3');
  Assert.AreEqual(0, list.Count, 'remove - 1');
  FreeAndNil(list);

  fMotif.remove('a:1, b:2');
  list:= fMotif.find('c:3');
  Assert.AreEqual(0, list.Count, 'remove - 2');
  FreeAndNil(list);

  list:= fMotif.find('a:1, b:2');
  Assert.AreEqual(0, list.Count, 'remove - 3');
  FreeAndNil(list);

end;

procedure TTestMotif.OnAdd(const aPattern: string; var aItem: TMotifItem);
begin
  if aItem.Value.IsString then
    aItem.Value.AsString:=aItem.Value.AsString.ToUpper;
end;

procedure TTestMotif.glob;
var
  list: TList<TMotifItem>;
begin
  fMotif.add('b:1,c:x*y', 'BC');
  list:=fMotif.find('b:1,c:xhy');
  Assert.AreEqual('BC', list[0].Value.AsString);
  FreeAndNil(List);
end;

procedure TTestMotif.globBack;
var
  list: TList<TMotifItem>;
begin
  fMotif.clear;
  fMotif.add('a:1, b:2', 'X')
        .add('c:3', 'Y');
  list:=fMotif.find('a:1, b:2');
  Assert.AreEqual('X', list[0].Value.AsString, '1');
  FreeAndNil(list);

  fMotif.add('a:1, b:2, d:4', 'XX')
        .add('{c:3, d:4 }', 'YY');

  list:=fMotif.find('a:1, b:2, d:4');
  Assert.AreEqual('XX', list[0].Value.AsString, '3');
  FreeAndNil(list);

  list:=fMotif.find('a:1, b:2');
  Assert.AreEqual('X', list[0].Value.AsString, '5');
  FreeAndNil(list);
end;

procedure TTestMotif.globFind;
var
  list: TList<TMotifItem>;
begin
  fMotif.clear;
  fMotif.add('ABC: 100', '10');
  fMotif.add('ABC: 200', '20');
  fMotif.add('XYZ: 300', '30');

  list:=fMotif.find('ABC: *');
  Assert.AreEqual(2, list.count);
  Assert.AreEqual('10', list[0].Value.AsString);
  Assert.AreEqual('20', list[1].Value.AsString);
  list.Free;
end;

procedure TTestMotif.listAll;
var
  output: string;
begin
  fMotif.clear;
  fMotif.add('ABC: 1000', '1')
        .add('XYZ: 2000', '2');
  output:=fMotif.list;
  Assert.AreEqual('ABC: 1000 -> 1'+sLineBreak+
                  'XYZ: 2000 -> 2', output);
  output:=fMotif.list('ABC: 1000');
  Assert.AreEqual('ABC: 1000 -> 1', output);
end;

procedure TTestMotif.multipleSimple;
var
  list: TList<TMotifItem>;
begin
  fMotif.clear;
  fMotif.add('ABC: 100', '10');
  fMotif.add('ABC: 100', '20');
  fMotif.add('XYZ: 300', '30');
  fMotif.add('ABC: 100', '500');

  list:=fMotif.find('ABC: 100');
  Assert.AreEqual(3, list.Count);
  Assert.AreEqual('10', list[0].Value.AsString);
  Assert.AreEqual('20', list[1].Value.AsString);
  list.Free;
end;

procedure TTestMotif.countiesConvoluted;
var
  llist: TList<TMotifItem>;
begin
  fMotif.add<Double>('country:US, state:NY', function:Double
                                             begin
                                               result:=0.07;
                                             end)
        .add<Double>('country:US, state:NY, type:reduced',
                      function: double
                      var
                        list: TList<TMotifItem>;
                      begin
                        list:=fMotif.find('country:US, state:NY');
                        result:=list[0].Value.AsExtended + 1.43;
                        list.free;
                      end);
  llist:=fMotif.find('country:US, state:NY, type:reduced');
  Assert.AreEqual(Double(1.50), double(llist[0].Value.AsExtended));
  FreeAndNil(llist);
end;

procedure TTestMotif.countries(const aTag: string; const aRate, aExpected:
    Double);
var
  taxFunc: TFunc<Double, Double>;
  resFunc: TFunc<double>;
  list: TList<TMotifItem>;
  test: double;
begin
  taxFunc:=function (aRate: Double): Double
           begin
            // Some sort of calculations here
            // but we'll return the same rate
            // as example
            result:=aRate;
           end;
  fMotif.add<double>(aTag, function:double
                                   begin
                                     result:=taxFunc(aRate);
                                   end);
  list:= fMotif.find(aTag);
  test:=list[0].Value.AsExtended;
  Assert.AreEqual(aExpected, test);
  FreeAndNil(list);
end;

procedure TTestMotif.setup;
begin
  fMotif:=TMotif.Create;
end;

procedure TTestMotif.tearDown;
begin
  fMotif.Free;
end;

procedure TTestMotif.toUpper;
var
  list: TList<TMotifItem>;
begin
  fMotif.clear;
  fMotif.add('role','user');
  fMotif.OnAdd:=OnAdd;
  fMotif.add('cmd','login');

  list:= fMotif.find('role');
  Assert.AreEqual('user', list[0].Value.AsString);
  FreeAndNil(list);

  list:= fMotif.find('cmd');
  Assert.AreEqual('LOGIN', list[0].Value.AsString);
  Assert.IsTrue('login' <> list[0].Value.AsString);
  FreeAndNil(list);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestMotif);
end.
