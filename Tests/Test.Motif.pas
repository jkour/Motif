unit Test.Motif;

interface
uses
  DUnitX.TestFramework, Motif.Types;

type

  [TestFixture]
  TMyTestObject = class(TObject) 
  private
    fMotif: IMotif;
  public
    [Setup]
    procedure setup;

    [Test]
    procedure basic;
    [Test]
    procedure delete;
  end;

implementation

uses
  Motif;


{ TMyTestObject }

procedure TMyTestObject.basic;
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

procedure TMyTestObject.delete;
begin
  fMotif.add('ABC: 1000', '1')
        .add('XYZ: 2000', '2');

  Assert.AreEqual('1', fMotif.find('ABC: 1000'));
  Assert.AreEqual('2', fMotif.find('XYZ: 2000'));

  fMotif.remove('ABC: 1000');
  Assert.AreEqual('', fMotif.find('ABC: 1000'));
  Assert.AreEqual('2', fMotif.find('XYZ: 2000'));
end;

procedure TMyTestObject.setup;
begin
  fMotif:=TMotif.Create;
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
