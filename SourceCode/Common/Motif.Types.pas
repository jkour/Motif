unit Motif.Types;

interface

type
  IMotif = interface
    ['{AC1B3778-3713-456E-8A9D-15062A6D60FB}']
    function add(const aPattern: string; const aReturn: string):IMotif;
  end;

implementation

end.
