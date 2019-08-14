unit Benchmarks.Find;

interface

uses
  Core.Benchmark.Base, Motif;

type
  TBenchmarkFind = class(TBaseBenchmark)
  private
    fMotif: TMotif;
  public
    procedure runBenchmark; override;
    procedure setDown; override;
    procedure setUp; override;
  end;

implementation

uses
  System.SysUtils,
  System.Classes;

{ TBenchmarkFind }

procedure TBenchmarkFind.runBenchmark;
var
  num: integer;
begin
  inherited;
  for num:=0 to 999 do
    fMotif.find('x: 500');
end;

procedure TBenchmarkFind.setDown;
begin
  inherited;
  fMotif.Free;
end;

procedure TBenchmarkFind.setUp;
var
  num: integer;
begin
  inherited;
  fMotif:=TMotif.Create;
  for num:=0 to 999 do
    fMotif.add('x: '+IntToStr(num), IntToStr(num));
end;

end.

