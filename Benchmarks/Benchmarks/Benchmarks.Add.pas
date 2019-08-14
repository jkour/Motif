unit Benchmarks.Add;

interface

uses
  Core.Benchmark.Base, Motif;

type
  TBenchmarkAdd = class (TBaseBenchmark)
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

{ TBenchmarkAdd }

procedure TBenchmarkAdd.runBenchmark;
var
  num: integer;
begin
  inherited;
  for num:=0 to 999 do
    fMotif.add('x: '+IntToStr(num), IntToStr(num));
end;

procedure TBenchmarkAdd.setDown;
begin
  inherited;
  fMotif.Free;
end;

procedure TBenchmarkAdd.setUp;
begin
  inherited;
  fMotif:=TMotif.Create;
end;

end.
