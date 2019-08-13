unit Motif;

interface

uses
  Motif.Types, System.Classes;

type
  TMotif = class (TInterfacedObject, IMotif)
  private
    fList: TStringList;
{$REGION 'Interface'}
    function add(const aPattern: string; const aReturn: string = ''): IMotif;
    function find (const aPattern: string; const aExact: Boolean = False): string;
    procedure remove (const aPattern: string);
{$ENDREGION}
    function prepareTag(const aPattern: string): string;
    function getPatternItemResponse(const index: integer): string;
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

function TMotif.find(const aPattern: string; const aExact: Boolean): string;
var
  tag: string;
  index: integer;
  arrStr: TArrayRecord<string>;
  arrList: TList<string>;
begin
  Result:='';
  tag:=prepareTag(aPattern);
  if fList.Find(tag, index) then
    Result:=getPatternItemResponse(index);
  if aExact or (Result<>'') then
    Exit;
  arrStr:=TArrayRecord<string>.Create(tag.Split([',']));
  while arrStr.Count > 0 do
  begin
    arrStr.Delete(arrStr.Count - 1);

    arrList:=TList<string>.Create;
    arrStr.List(arrList);
    tag:=string.Join(',', arrList.ToArray);
    arrList.Free;

    if fList.Find(tag,index) then
    begin
      Result:=getPatternItemResponse(index);
      Break;
    end;
  end;
end;

{ TMotif }

function TMotif.add(const aPattern: string; const aReturn: string = ''): IMotif;
var
  strArray: TArrayRecord<string>;
  item: string;
  arrStr: string;
  arrList: TList<string>;
  tag: string;
  index: Integer;
  patItem: TPatternItem;
begin
  tag:=prepareTag(aPattern);
  if not fList.Find(tag, index) then
  begin
    patItem:=TPatternItem.Create;
    patItem.Response:=aReturn;
    fList.AddObject(tag, patItem);
  end;
  Result:=Self;
end;

function TMotif.getPatternItemResponse(const index: integer): string;
begin
  Result:='';
  if (index>=0) and (index<=fList.Count - 1) and Assigned(fList.Objects[index]) then
    Result := (fList.Objects[index] as TPatternItem).Response;
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
  arrList.Free;
end;

procedure TMotif.remove(const aPattern: string);
var
  index: integer;
begin
  if fList.Find(prepareTag(aPattern), index) then
    fList.Delete(index);
end;

end.
