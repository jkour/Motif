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
    procedure Basic;
  end;

implementation

uses
  Motif;


{ TMyTestObject }

procedure TMyTestObject.Basic;
begin
  fMotif.add('x:1', 'A')
        .add('x:1, y:1', 'B')
        .add('x:1, y:2', 'C')
        .add('x:1, y:1', 'F'); // This is ignored
end;

procedure TMyTestObject.setup;
begin
  fMotif:=TMotif.Create;
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
