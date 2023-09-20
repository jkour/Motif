unit Benchmarks.Remove;

interface

uses
  Core.Benchmark.Base, Motif;

type
  TBenchmarkRemove = class(TBaseBenchmark)
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

{ TBenchmarkRemove }

procedure TBenchmarkRemove.runBenchmark;
var
  num: integer;
  fact: integer;
begin
  inherited;
  for num:=0 to Operations - 1 do
  begin
    fMotif.remove('x: '+IntToStr(num));
    if num mod fact = 0 then
    begin
      Percentage:= num / Operations;
    end;
  end;
  Percentage:=100;
end;

procedure TBenchmarkRemove.setDown;
begin
  inherited;
  fMotif.Free;
end;

procedure TBenchmarkRemove.setUp;
var
  num: integer;
begin
  inherited;
  fMotif:=TMotif.Create;
  for num:=0 to 999 do
    fMotif.add('x: '+IntToStr(num), IntToStr(num));
end;

end.

