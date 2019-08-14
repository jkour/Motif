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
  Motif in '..\SourceCode\Common\Motif.pas',
  flcUtils in '..\SourceCode\ThirdParty\flcUtils.pas',
  flcStrings in '..\SourceCode\ThirdParty\flcStrings.pas',
  flcStringPatternMatcher in '..\SourceCode\ThirdParty\flcStringPatternMatcher.pas',
  flcStdTypes in '..\SourceCode\ThirdParty\flcStdTypes.pas',
  flcASCII in '..\SourceCode\ThirdParty\flcASCII.pas',
  ArrayHelper in '..\SourceCode\ThirdParty\ArrayHelper.pas',
  Benchmarks.Remove in 'Benchmarks\Benchmarks.Remove.pas',
  Benchmarks.Find in 'Benchmarks\Benchmarks.Find.pas',
  Benchmarks.Find.Glob in 'Benchmarks\Benchmarks.Find.Glob.pas';

procedure loadbenchmarks (const aManager: TBenchmarkManager);
var
  benchMark: TBaseBenchmark;
begin
  // Add
  benchMark:=TBenchmarkAdd.Create('Add', '', 1000000);
  aManager.addBenchmark(benchMark);

  // Remove
  benchMark:=TBenchmarkRemove.Create('Remove', '', 1000000);
  aManager.addBenchmark(benchMark);

  // Find
  benchMark:=TBenchmarkFind.Create('Find', '', 1000000);
  aManager.addBenchmark(benchMark);

  // Find Glob
  benchMark:=TBenchmarkFindGlob.Create('Find Glob', '', 1000000);
  aManager.addBenchmark(benchMark);
end;

var
  benchmarkManager: TBenchmarkManager;
  resString: string;
begin
  try
    benchmarkManager:=TBenchmarkManager.Create;
    Writeln('Loading benchmarks...');
    loadbenchmarks(benchmarkManager);

    Writeln('Benchmarks started...');

    benchmarkManager.benchmark;

    Writeln;

    for resString in benchmarkManager.Results do
      Writeln(#9+resString);
    Writeln('Benchmark finished');

//    dir:=TPath.Combine(ExtractFilePath(ParamStr(0)), 'Results');
//    if not DirectoryExists(dir) then
//      CreateDir(dir);
//
//    benchmarkManager.Results.SaveToFile(TPath.Combine(dir,
//        'benchmark-'+FormatDateTime('ddmmyyyy-hhmm', Now)+'.txt'));
//    Writeln('Results saved');

    Write('Press Enter to exit');
    readln;

    benchmarkManager.Free;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
