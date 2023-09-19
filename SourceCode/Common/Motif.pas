unit Motif;

interface

uses
  System.Classes, System.Rtti, System.Generics.Collections, Quick.Lists,
  Quick.Value, Quick.Arrays;

type
  TOnBeforeAdd = procedure (const aPattern: string; var aValue: string;
                                var aContinue:Boolean) of object;
  TMotifItem = class
  private
    fGUID: string;
    fTag: string;
    fValue: TFlexValue;
  public
    property GUID: string read fGUID write fGUID;
    property Tag: string read fTag write fTag;
    property Value: TFlexValue read fValue write fValue;
  end;

  TLocateItem = class
  private
    fGUIDS: TXArray<TGUID>;
    fTag: string;
  public
    property GUIDS: TXArray<TGUID> read fGUIDS write fGUIDS;
    property Tag: string read fTag write fTag;
  end;

  TMotif = class
  private
    fItemList: TIndexedObjectList<TMotifItem>;
    fLocatorList: TIndexedObjectList<TLocateItem>;

    function cleanTag(const aTag: string): string;
    function createItems(const aTag: string): TMotifItem;
    function tagContainsGblob(const aTag: string): boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function add(const aTag: string; const aReturn:string = ''):TMotif;
    function find(const aTag: string): TList<TMotifItem>;

    procedure clear;
    procedure remove(const aTag:string);
  end;
implementation

uses
  System.Hash, System.SysUtils;

function TMotif.add(const aTag, aReturn: string): TMotif;
var
  item: TMotifItem;
begin
  result:=self;
  item:=createItems(aTag);
  item.Value.AsString:=aReturn;
end;

constructor TMotif.Create;
begin
  inherited;
  fItemList:=TIndexedObjectList<TMotifItem>.Create(true);
  fItemList.Indexes.Add('GUID', 'GUID');

  fLocatorList:=TIndexedObjectList<TLocateItem>.Create(true);
  fLocatorList.Indexes.Add('Tag', 'Tag');

end;

function TMotif.createItems(const aTag: string): TMotifItem;
var
  item: TMotifItem;
  loc: TLocateItem;
  prepTag: string;
  arr: TXArray<string>;
  guid: TGUID;
begin
  prepTag:=cleanTag(aTag);

  loc:=fLocatorList.Get('Tag', prepTag);
  if not assigned(loc) then
  begin
    loc:=TLocateItem.Create;
    loc.Tag:=prepTag;
    fLocatorList.Add(loc);
  end;
  CreateGUID(guid);
  loc.GUIDS.Add(guid);

  result:=TMotifItem.Create;
  result.GUID:=GUIDToString(guid);
  result.Tag:=aTag;
  fItemList.Add(result);
end;

destructor TMotif.Destroy;
begin
  FreeAndNil(fItemList);
  FreeAndnil(fLocatorList);
  inherited;
end;

function TMotif.find(const aTag: string): TList<TMotifItem>;
var
  loc: TLocateItem;
  prepTag: string;
  guid: TGUID;
  list:TList<TMotifItem>;
begin
  list:=TList<TMotifItem>.Create;
  result:=list;

  prepTag:=cleanTag(aTag);

  if not tagContainsGblob(prepTag) then
  begin
    loc:=fLocatorList.Get('Tag', prepTag);
    if not assigned(loc) then
      Exit
    else
    begin
      for guid in loc.GUIDS do
        list.Add(fItemList.Get('GUID', GUIDToString(guid)));
    end;
  end;

end;

procedure TMotif.remove(const aTag: string);
var
  loc: TLocateItem;
  item: TMotifItem;
  guid: TGUID;
begin
  loc:=fLocatorList.Get('Tag', cleanTag(aTag));
  if assigned(loc) then
  begin
    for guid in loc.GUIDS do
    begin
      item:=fItemList.Get('GUID', GUIDToString(guid));
      fItemList.Remove(item);
    end;
    fLocatorList.Remove(loc);
  end;
end;

function TMotif.tagContainsGblob(const aTag: string): boolean;
var
  prepTag: string;
begin
  prepTag:=cleanTag(aTag);
  result:=prepTag.Contains('?') or prepTag.Contains('*') or
            prepTag.Contains('[') or prepTag.Contains(']');
end;

function TMotif.cleanTag(const aTag: string): string;
begin
  result:=aTag.Replace('{', '')
              .Replace('}', '')
              .Replace('''', '')
              .Trim
              .ToUpper;

end;

procedure TMotif.clear;
begin
  fLocatorList.Clear;
  fItemList.Clear;
end;

end.
