program Benchmarks.Motif;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  Core.Benchmark.Base in 'Core\Core.Benchmark.Base.pas',
  Core.BenchmarkManager in 'Core\Core.BenchmarkManager.pas',
  Benchmarks.Add in 'Benchmarks\Benchmarks.Add.pas',
  Benchmarks.Remove in 'Benchmarks\Benchmarks.Remove.pas',
  Benchmarks.Find in 'Benchmarks\Benchmarks.Find.pas',
  Benchmarks.Find.Glob in 'Benchmarks\Benchmarks.Find.Glob.pas',
  Quick.Console;

procedure loadbenchmarks (const aManager: TBenchmarkManager);
var
  benchMark: TBaseBenchmark;
const
  OPS = 1000000;
  FACTOR = 1;
var
  finalOPS: integer;
begin
  finalOps:=round(OPS * FACTOR);
  // Add
  benchMark:=TBenchmarkAdd.Create('Add', '', finalOps);
  aManager.addBenchmark(benchMark);

  // Remove
  benchMark:=TBenchmarkRemove.Create('Remove', '', finalOps);
  aManager.addBenchmark(benchMark);

  // Find
  benchMark:=TBenchmarkFind.Create('Find', '', finalOps);
  aManager.addBenchmark(benchMark);

  // Find Glob
  benchMark:=TBenchmarkFindGlob.Create('Find Glob', '', finalOps);
  aManager.addBenchmark(benchMark);
end;

var
  benchmarkManager: TBenchmarkManager;
  resString: string;
begin
  ReportMemoryLeaksOnShutdown:=true;
  try
    benchmarkManager:=TBenchmarkManager.Create;
    cout('Loading benchmarks...', ccWhite);
    loadbenchmarks(benchmarkManager);

    cout('Benchmarks started...', ccBlue);

    benchmarkManager.benchmark;

    Writeln;

    for resString in benchmarkManager.Results do
      cout(#9 + resString, ccGreen);
    cout('Benchmark finished', ccYellow);

//    dir:=TPath.Combine(ExtractFilePath(ParamStr(0)), 'Results');
//    if not DirectoryExists(dir) then
//      CreateDir(dir);
//
//    benchmarkManager.Results.SaveToFile(TPath.Combine(dir,
//        'benchmark-'+FormatDateTime('ddmmyyyy-hhmm', Now)+'.txt'));
//    Writeln('Results saved');
//
    cout('Press Enter to exit', ccWhite);
    ConsoleWaitForEnterKey;

    benchmarkManager.Free;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
