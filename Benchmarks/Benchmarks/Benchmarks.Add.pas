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
  fact: integer;
begin
  inherited;

  fact:=random(5) * Factor;
  for num:=0 to Operations - 1 do
  begin
    fMotif.add('x: '+IntToStr(num), IntToStr(num));
    if num mod fact = 0 then
    begin
      Percentage:= num / Operations;
    end;
  end;
  Percentage:=100;
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
