program Demo.Basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Generics.Collections,
  Motif;

var
  taxFunc: TFunc<Double, Double>;
  motif: TMotif;
  list: TList<TMotifItem>;
begin
  ReportMemoryLeaksOnShutdown:=true;
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

    list:=motif.find('country: UK');
    Writeln('For an item with net value £100.00, the final price is: '+
              (100 + 100 * list[0].Value.AsExtended).ToString);
    list.Clear;

    list:=motif.find('country: UK, type: food');
    Writeln('For food with net value £100.00, the final price is: '+
              (100 + 100 * list[0].Value.AsExtended).ToString);
    FreeAndNil(list);
    Readln;

    motif.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
