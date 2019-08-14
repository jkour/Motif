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
    procedure delete;
    [Test]
    procedure deleteIntermediate;

    [Test]
    [TestCase ('', '-0.0-0.0','-')]
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
    procedure toUpper;

    [Test]
    procedure listAll;
  end;

implementation

uses
  System.SysUtils;


{ TTestMotif }

procedure TTestMotif.basic;
begin
  fMotif.add('x:1', 'A')
        .add('x:1, y:1', 'B')
        .add('x:1, y:2', 'C')
        .add('x:1, y:2, z:3', 'D');

  Assert.AreEqual('A', fMotif.find('x:1'), '1');
  Assert.AreEqual('', fMotif.find('x:2'), '2');
  Assert.AreEqual('B', fMotif.find('x:1, y:1'), '3');

  Assert.AreEqual('C', fMotif.find('x:1, y:2'), '4');
  Assert.AreEqual('D', fMotif.find('x:1, y:2, z:3'), '5');


  Assert.AreEqual('', fMotif.find('x:2, y:2'), '6');
  Assert.AreEqual('', fMotif.find('y:1'), '7');

  fMotif.clear;
  fMotif.add('{x:1}', 'M')
        .add('{x:''John''}', 'John');
  Assert.AreEqual('M', fMotif.find('x:1'), '8');
  Assert.AreEqual('John', fMotif.find('x:John'), '9');

  fMotif.clear;
  fMotif.add('', 'R');
  Assert.AreEqual('R', fMotif.find(''));

end;

procedure TTestMotif.delete;
begin
  fMotif.add('ABC: 1000', '1')
        .add('XYZ: 2000', '2');

  Assert.AreEqual('1', fMotif.find('ABC: 1000'));
  Assert.AreEqual('2', fMotif.find('XYZ: 2000'));

  fMotif.remove('ABC: 1000');
  Assert.AreEqual('', fMotif.find('ABC: 1000'));
  Assert.AreEqual('2', fMotif.find('XYZ: 2000'));
end;

procedure TTestMotif.deleteIntermediate;
begin
  fMotif.clear;
  fMotif.add('{a:1, b:2, d:4}', 'XX')
        .add('c:3, d:4', 'YY')
        .add('a:1, b:2', 'X')
        .add('c:3', 'Y');

  fMotif.remove('c:3');

  Assert.AreEqual('', fMotif.find('c:3'), '1');

  fMotif.remove('a:1, b:2');

  Assert.AreEqual('', fMotif.find('c:3'), '2');
  Assert.AreEqual('', fMotif.find('a:1, b:2'), '3');
end;

procedure TTestMotif.glob;
begin
  fMotif.add('b:1,c:x*y', 'BC');

  Assert.AreEqual('BC', fMotif.Find('b:1,c:xhy'));
end;

procedure TTestMotif.globBack;
begin
  fMotif.clear;
  fMotif.add('a:1, b:2', 'X')
        .add('c:3', 'Y');
  Assert.AreEqual('X', fMotif.find('a:1, b:2'), '1');

  fMotif.add('a:1, b:2, d:4', 'XX')
        .add('{c:3, d:4 }', 'YY');

  Assert.AreEqual('XX', fMotif.find('a:1, b:2, d:4'), '3');
  Assert.AreEqual('X', fMotif.find('a:1, b:2'), '5');
end;

procedure TTestMotif.listAll;
var
  list: string;
begin
  fMotif.clear;
  fMotif.add('ABC: 1000', '1')
        .add('XYZ: 2000', '2');
  list:=fMotif.list('');
  Assert.AreEqual('Available Patterns:'+sLineBreak+
                  'Pattern: ABC: 1000: 1'+sLineBreak+
                  'Pattern: XYZ: 2000: 2', list.Trim);
  list:=fMotif.list('ABC: 1000');
  Assert.AreEqual('Available Patterns:'+sLineBreak+
                  'Pattern: ABC: 1000: 1', list.Trim);
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
                      begin
                        result:=fMotif.find<double>('country:US,state:NY');
                      end);
  Assert.AreEqual(Double(0.07), fMotif.find<Double>('country:US,state:NY,type:reduced'));

end;

procedure TTestMotif.countries(const aTag: string; const aRate, aExpected:
    Double);
var
  taxFunc: TFunc<Double, Double>;
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
  Assert.IsTrue(aExpected = fMotif.find<Double>(aTag));
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

  Assert.AreEqual('user', fMotif.find('role'));
  Assert.AreEqual('LOGIN', fMotif.find('cmd'));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestMotif);
end.
