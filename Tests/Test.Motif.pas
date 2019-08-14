unit Test.Motif;

interface
uses
  DUnitX.TestFramework, Motif;

type

  [TestFixture]
  TTestMotif = class(TObject)
  private
    fMotif: TMotif;
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
        .add('x:1, y:2, z:3', 'D')
        .add('x:1, y:1', 'F'); // This is ignored

  Assert.AreEqual('A', fMotif.find('x:1'), '1');
  Assert.AreEqual('', fMotif.find('x:2'), '2');
  Assert.AreEqual('B', fMotif.find('x:1, y:1'), '3');

  Assert.AreEqual('C', fMotif.find('x:1, y:2'), '4');
  Assert.AreEqual('D', fMotif.find('x:1, y:2, z:3'), '4');


  Assert.AreEqual('', fMotif.find('x:2, y:2'), '5');
  Assert.AreEqual('', fMotif.find('y:1'), '6');
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

procedure TTestMotif.countiesConvoluted;
begin
//  .add({ country:'US', state:'NY', type:'reduced' }, function under110(net){
//    return net < 110 ? 0.0 : salestax.find( {country:'US', state:'NY'} )
//  })
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

initialization
  TDUnitX.RegisterTestFixture(TTestMotif);
end.
