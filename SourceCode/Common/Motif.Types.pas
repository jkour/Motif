unit Motif.Types;

interface

type
  IMotif = interface
    ['{AC1B3778-3713-456E-8A9D-15062A6D60FB}']
    function add (const aPattern: string; const aReturn: string = ''):IMotif;
    procedure remove (const aPattern: string);
    function find (const aPattern: string; const aExact: Boolean = False): string;
  end;

implementation

end.
