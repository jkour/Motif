unit Test.Motif;

interface
uses
  DUnitX.TestFramework, Motif;

type

  [TestFixture]
  TTestMotif = class(TObject)
  private
    fMotif: TMotif;
    procedure OnNewAdd(const aPattern: string; var aValue: string;
                                              var aContinue:Boolean);
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
  System.SysUtils, System.Generics.Collections;


{ TTestMotif }

procedure TTestMotif.basic;
begin
  fMotif.add('x:1', 'A')
        .add('x:1, y:1', 'B')
        .add('x:1, y:2', 'C')
        .add('x:1, y:2, z:3', 'D');

  /// This approach to use find generates mem leaks
  ///  the list received by find should be manually freed
  Assert.AreEqual('A', fMotif.findByPattern('x:1')[0], '1');
  Assert.AreEqual(0, fMotif.findByPattern('x:2').Count, '2');
  Assert.AreEqual('B', fMotif.findByPattern('x:1, y:1')[0], '3');

  Assert.AreEqual('C', fMotif.findByPattern('x:1, y:2')[0], '4');
  Assert.AreEqual('D', fMotif.findByPattern('x:1, y:2, z:3')[0], '5');


  Assert.AreEqual(0, fMotif.findByPattern('x:2, y:2').Count, '6');
  Assert.AreEqual(0, fMotif.findByPattern('y:1').Count, '7');

  fMotif.clear;
  fMotif.add('{x:1}', 'M')
        .add('{x:''John''}', 'John');
  Assert.AreEqual('M', fMotif.findByPattern('x:1')[0], '8');
  Assert.AreEqual('John', fMotif.findByPattern('x:John')[0], '9');

  fMotif.clear;
  fMotif.add('', 'R');
  Assert.AreEqual('R', fMotif.findByPattern('')[0]);

end;

procedure TTestMotif.delete;
begin
  fMotif.add('ABC: 1000', '1')
        .add('XYZ: 2000', '2');

  Assert.AreEqual('1', fMotif.findByPattern('ABC: 1000')[0]);
  Assert.AreEqual('2', fMotif.findByPattern('XYZ: 2000')[0]);

  fMotif.remove('ABC: 1000');
  Assert.AreEqual('2', fMotif.findByPattern('XYZ: 2000')[0]);
end;

procedure TTestMotif.deleteIntermediate;
begin
  fMotif.clear;
  fMotif.add('{a:1, b:2, d:4}', 'XX')
        .add('c:3, d:4', 'YY')
        .add('a:1, b:2', 'X')
        .add('c:3', 'Y');

  fMotif.remove('c:3');

  Assert.AreEqual(0, fMotif.findByPattern('c:3').Count, '1');

  fMotif.remove('a:1, b:2');

  Assert.AreEqual(0, fMotif.findByPattern('c:3').Count, '2');
  Assert.AreEqual(0, fMotif.findByPattern('a:1, b:2').Count, '3');
end;

procedure TTestMotif.glob;
begin
  fMotif.add('b:1,c:x*y', 'BC');

  Assert.AreEqual('BC', fMotif.findByPattern('b:1,c:xhy')[0]);
end;

procedure TTestMotif.globBack;
begin
  fMotif.clear;
  fMotif.add('a:1, b:2', 'X')
        .add('c:3', 'Y');
  Assert.AreEqual('X', fMotif.findByPattern('a:1, b:2')[0], '1');

  fMotif.add('a:1, b:2, d:4', 'XX')
        .add('{c:3, d:4 }', 'YY');

  Assert.AreEqual('XX', fMotif.findByPattern('a:1, b:2, d:4')[0], '3');
  Assert.AreEqual('X', fMotif.findByPattern('a:1, b:2')[0], '5');
end;

procedure TTestMotif.globFind;
var
  list: TList<string>;
begin
  fMotif.clear;
  fMotif.add('ABC: 100', '10');
  fMotif.add('ABC: 200', '20');
  fMotif.add('XYZ: 300', '30');

  list:=fMotif.findByPattern('ABC: *');
  Assert.AreEqual(2, list.count);
  Assert.AreEqual('10', list[0]);
  Assert.AreEqual('20', list[1]);
  list.Free;
end;

procedure TTestMotif.listAll;
var
  list: string;
begin
  fMotif.clear;
  fMotif.add('ABC: 1000', '1')
        .add('XYZ: 2000', '2');
  list:=fMotif.list('');
  Assert.AreEqual('ABC: 1000	 -> 	1'+sLineBreak+
                  'XYZ: 2000	 -> 	2', list.Trim);
  list:=fMotif.list('ABC: 1000');
  Assert.AreEqual('ABC: 1000	 -> 	1', list.Trim);
end;

procedure TTestMotif.multipleSimple;
var
  list: TList<string>;
begin
  fMotif.clear;
  fMotif.add('ABC: 100', '10');
  fMotif.add('ABC: 100', '20');
  fMotif.add('XYZ: 300', '30');

  list:=fMotif.findByPattern('ABC: 100');
  Assert.AreEqual(2, list.Count);
  Assert.AreEqual('10', list[0]);
  Assert.AreEqual('20', list[1]);
end;

procedure TTestMotif.OnNewAdd(const aPattern: string; var aValue: string;
  var aContinue: Boolean);
begin
  aValue:=aValue.ToUpper;
end;

procedure TTestMotif.countiesConvoluted;
begin
  fMotif.add<Double>('country:US, state:NY', function:Double
                                             begin
                                               result:=0.07;
                                             end)
        .add<Double>('country:US, state:NY, type:reduced',
                      function: double
                      var
                        list: TList<Double>;
                      begin
                        list:=fMotif.findClassByPattern<double>('country:US,state:NY');
                        result:=list[0];
                        list.free;
                      end);

  Assert.AreEqual(Double(0.07), fMotif.findClassByPattern<Double>('country:US,state:NY,type:reduced')[0]);

end;

procedure TTestMotif.countries(const aTag: string; const aRate, aExpected:
    Double);
var
  taxFunc: TFunc<Double, Double>;
  list: TList<Double>;
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
  list:= fMotif.findClassByPattern<Double>(aTag);
  Assert.AreEqual(aExpected, list[0]);
  list.Free;
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
begin
  fMotif.clear;
  fMotif.add('role','user');
  fMotif.OnBeforeAdd:=OnNewAdd;
  fMotif.add('cmd','login');

  Assert.AreEqual('user', fMotif.findByPattern('role')[0]);
  Assert.AreEqual('LOGIN', fMotif.findByPattern('cmd')[0]);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestMotif);
end.
