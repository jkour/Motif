unit Motif;

interface

uses
  System.Classes, System.Rtti, System.Generics.Collections, Quick.Lists,
  System.SysUtils;

type
  TOnBeforeAdd = procedure (const aPattern: string; var aValue: string;
                                var aContinue:Boolean) of object;

implementation


end.
