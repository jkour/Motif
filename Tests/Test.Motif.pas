unit Test.Motif;

interface
uses
  DUnitX.TestFramework, Motif;

type

  [TestFixture]
  TTestMotif = class(TObject)
  private
    fMotif: TMotif;
//    procedure OnNewAdd(const aPattern: string; var aValue: string;
//                                              var aContinue:Boolean);
  public
    [Setup]
    procedure setup;
    [TearDown]
    procedure tearDown;

    [Test]
    procedure basic;

//    [Test]
//    procedure multipleSimple;
//
    [Test]
    procedure delete;

    [Test]
    procedure deleteIntermediate;

//    [Test]
//    [TestCase ('IE', 'country:IE- 0.25- 0.25','-')]
//    [TestCase ('UK', 'country:UK- 0.20- 0.20','-')]
//    [TestCase ('DE', 'country:DE- 0.19- 0.19','-')]
//    [TestCase ('IE-reduced', 'country:IE, type:reduced-0.135-0.135','-')]
//    [TestCase ('IE-food', 'country:IE, type:food-0.048-0.048','-')]
//    [TestCase ('UK-food', 'country:UK, type:food-0.0-0.0','-')]
//    [TestCase ('DE-reduced', 'country:DE, type:reduced-0.07-0.07','-')]
//    [TestCase ('US', 'country:US-0.0-0.0','-')]
//    [TestCase ('US-AL', 'country:US, state:AL-0.04-0.04','-')]
//    [TestCase ('US-AL', 'country:US, state:AL, city:Montgomery-0.10-0.10','-')]
//    [TestCase ('US-NY', 'country:US, state:NY-0.07-0.07','-')]
//    procedure countries(const aTag: string; const aRate, aExpected: Double);
//
//    [Test]
//    procedure countiesConvoluted;
//
//    [Test]
//    procedure glob;
//    [Test]
//    procedure globBack;
//    [Test]
//    procedure globFind;
//
//    [Test]
//    procedure toUpper;
//
//    [Test]
//    procedure listAll;
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

//procedure TTestMotif.glob;
//begin
//  fMotif.add('b:1,c:x*y', 'BC');
//  var list:TList<String>;
//  list:=fMotif.findByPattern('b:1,c:xhy');
//  Assert.AreEqual('BC', fMotif.findByPattern('b:1,c:xhy')[0]);
//end;
//
//procedure TTestMotif.globBack;
//begin
//  fMotif.clear;
//  fMotif.add('a:1, b:2', 'X')
//        .add('c:3', 'Y');
//  Assert.AreEqual('X', fMotif.findByPattern('a:1, b:2')[0], '1');
//
//  fMotif.add('a:1, b:2, d:4', 'XX')
//        .add('{c:3, d:4 }', 'YY');
//
//  Assert.AreEqual('XX', fMotif.findByPattern('a:1, b:2, d:4')[0], '3');
//  Assert.AreEqual('X', fMotif.findByPattern('a:1, b:2')[0], '5');
//end;
//
//procedure TTestMotif.globFind;
//var
//  list: TList<string>;
//begin
//  fMotif.clear;
//  fMotif.add('ABC: 100', '10');
//  fMotif.add('ABC: 200', '20');
//  fMotif.add('XYZ: 300', '30');
//
//  list:=TList<string>.Create;
//  list:=fMotif.findByPattern('ABC: *');
//  Assert.AreEqual(2, list.count);
//  Assert.AreEqual('10', list[0]);
//  Assert.AreEqual('20', list[1]);
//  list.Free;
//end;
//
//procedure TTestMotif.listAll;
//var
//  list: string;
//begin
//  fMotif.clear;
//  fMotif.add('ABC: 1000', '1')
//        .add('XYZ: 2000', '2');
//  list:=fMotif.list('');
////  Assert.AreEqual('ABC: 1000 -> 1'+sLineBreak+
////                  'XYZ: 2000 -> 2', list.Trim);
//  list:=fMotif.list('ABC: 1000');
//  Assert.AreEqual('ABC: 1000 -> 1', list.Trim);
//end;
//
//procedure TTestMotif.multipleSimple;
//var
//  list: TList<string>;
//begin
//  fMotif.clear;
//  fMotif.add('ABC: 100', '10');
//  fMotif.add('ABC: 100', '20');
//  fMotif.add('XYZ: 300', '30');
//  fMotif.add('ABC: 100', '500');
//
//  list:=fMotif.findByPattern('ABC: 100');
//  Assert.AreEqual(3, list.Count);
//  Assert.AreEqual('10', list[0]);
//  Assert.AreEqual('20', list[1]);
//end;
//
//procedure TTestMotif.OnNewAdd(const aPattern: string; var aValue: string;
//  var aContinue: Boolean);
//begin
//  aValue:=aValue.ToUpper;
//end;
//
//procedure TTestMotif.countiesConvoluted;
//begin
//  fMotif.add<Double>('country:US, state:NY', function:Double
//                                             begin
//                                               result:=0.07;
//                                             end)
//        .add<Double>('country:US, state:NY, type:reduced',
//                      function: double
//                      var
//                        list: TList<Double>;
//                      begin
//                        list:=fMotif.findClassByPattern<double>('country:US,state:NY');
//                        result:=list[0];
//                        list.free;
//                      end);
//
//  Assert.AreEqual(Double(0.07), fMotif.findClassByPattern<Double>('country:US,state:NY,type:reduced')[0]);
//
//end;
//
//procedure TTestMotif.countries(const aTag: string; const aRate, aExpected:
//    Double);
//var
//  taxFunc: TFunc<Double, Double>;
//  list: TList<Double>;
//begin
//  taxFunc:=function (aRate: Double): Double
//           begin
//            // Some sort of calculations here
//            // but we'll return the same rate
//            // as example
//            result:=aRate;
//           end;
//  fMotif.add<double>(aTag, function:double
//                                   begin
//                                     result:=taxFunc(aRate);
//                                   end);
//  list:= fMotif.findClassByPattern<Double>(aTag);
//  Assert.AreEqual(aExpected, list[0]);
//  list.Free;
//end;

procedure TTestMotif.setup;
begin
  fMotif:=TMotif.Create;
end;

procedure TTestMotif.tearDown;
begin
  fMotif.Free;
end;

//procedure TTestMotif.toUpper;
//begin
//  fMotif.clear;
//  fMotif.add('role','user');
//  fMotif.OnBeforeAdd:=OnNewAdd;
//  fMotif.add('cmd','login');
//
//  Assert.AreEqual('user', fMotif.findByPattern('role')[0]);
//  Assert.AreEqual('LOGIN', fMotif.findByPattern('cmd')[0]);
//end;

initialization
  TDUnitX.RegisterTestFixture(TTestMotif);
end.
