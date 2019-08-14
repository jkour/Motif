program Demo.Basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Motif in '..\SourceCode\Common\Motif.pas',
  flcUtils in '..\SourceCode\ThirdParty\flcUtils.pas',
  flcStrings in '..\SourceCode\ThirdParty\flcStrings.pas',
  flcStringPatternMatcher in '..\SourceCode\ThirdParty\flcStringPatternMatcher.pas',
  flcStdTypes in '..\SourceCode\ThirdParty\flcStdTypes.pas',
  flcASCII in '..\SourceCode\ThirdParty\flcASCII.pas',
  ArrayHelper in '..\SourceCode\ThirdParty\ArrayHelper.pas';

var
  taxFunc: TFunc<Double, Double>;
  motif: TMotif;
begin
  try
    motif:=TMotif.Create;
    taxFunc:=function (aRate: Double): Double
             begin
              // Some sort of calculations here
              // but we'll return the same rate
              // as example
              result:=aRate;
             end;

    motif.add<Double>('country: UK', function:double
                                     begin
                                       result:=taxFunc(0.19);
                                     end)
         .add<Double>('country: UK, type: food', function:double
                                     begin
                                       result:=taxFunc(0.00);
                                     end);

    Writeln('For an item with net value £100.00, the final price is: '+
              (100 + 100 * motif.find<double>('country: UK')).toString);

    Writeln('For food with net value £100.00, the final price is: '+
              (100 + 100 * motif.find<double>('country: UK, type: food')).toString);

    Readln;

    motif.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
