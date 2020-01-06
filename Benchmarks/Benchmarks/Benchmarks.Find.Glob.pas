unit Benchmarks.Find.Glob;

interface

uses
  Core.Benchmark.Base, Motif;

type
  TBenchmarkFindGlob = class(TBaseBenchmark)
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

{ TBenchmarkFindGlob }

procedure TBenchmarkFindGlob.runBenchmark;
var
  num: integer;
begin
  inherited;
  for num:=0 to 999 do
    fMotif.findByPattern('x: AZB, y: 500');
end;

procedure TBenchmarkFindGlob.setDown;
begin
  inherited;
  fMotif.Free;
end;

procedure TBenchmarkFindGlob.setUp;
var
  num: integer;
begin
  inherited;
  fMotif:=TMotif.Create;
  for num:=0 to 999 do
    fMotif.add('x: A*B, y: '+IntToStr(num), IntToStr(num));
end;

end.

