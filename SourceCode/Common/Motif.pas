unit Motif;

interface

uses
  Motif.Types, System.Classes;

type
  TMotif = class (TInterfacedObject, IMotif)
  private
    fList: TStringList;
{$REGION 'Interface'}
    function add(const aPattern: string; const aReturn: string): IMotif;
    function prepareTag(const aPattern: string): string;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, ArrayHelper, System.Generics.Collections;

type
  TPatternItem = class
    Response: string;
  end;

constructor TMotif.Create;
begin
  inherited;
  fList:=TStringList.Create;
  fList.Sorted:=True;
  fList.OwnsObjects:=True;
end;

destructor TMotif.Destroy;
begin
  fList.Free;
  inherited;
end;

{ TMotif }

function TMotif.add(const aPattern, aReturn: string): IMotif;
var
  strArray: TArrayRecord<string>;
  item: string;
  arrStr: string;
  arrList: TList<string>;
  tag: string;
  index: Integer;
  patItem: TPatternItem;
begin
  prepareTag(aPattern);
  if not fList.Find(tag, index) then
  begin
    patItem:=TPatternItem.Create;
    patItem.Response:=aReturn;
    fList.AddObject(tag, patItem);
  end;
  arrList.Free;

  Result:=Self;
end;

function TMotif.prepareTag(const aPattern: string): string;
var
  strArray: TArrayRecord<string>;
  arrList: TList<string>;
  tag: string;
  index: Integer;
begin
  strArray:=TArrayRecord<string>.Create(aPattern.Split([',']));
  strArray.ForEach(procedure(var Value: string; Index: integer)
                   begin
                     Value:=Value.Trim.ToUpper;
                   end);

  arrList:=TList<string>.Create;
  strArray.List(arrList);
  result:=string.Join(',', arrList.ToArray);
end;

end.
