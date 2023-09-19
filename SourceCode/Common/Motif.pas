unit Motif;

interface

uses
  System.Classes, System.Rtti, System.Generics.Collections, Quick.Lists,
  Quick.Value, Quick.Arrays;

type
  TMotifItem = class;
  TOnAdd = procedure (const aPattern: string; var aItem: TMotifItem) of object;
  TMotifItem = class
  private
    fGUID: string;
    fTag: string;
    fValue: TFlexValue;
  public
    property GUID: string read fGUID;
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
    fOnAdd: TOnAdd;
    fWildcardsNum: UInt32;

    function cleanTag(const aTag: string): string;
    function createItems(const aTag: string): TMotifItem;
    function strContainsGblob(const aTag: string): boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function add(const aTag: string; const aReturn:string = ''):TMotif;
    function find(const aTag: string): TList<TMotifItem>;

    procedure clear;
    procedure remove(const aTag:string);
    function list(const aPattern:string = ''):string;
  published
    /// <summary>
    ///   Called after the item is created
    /// </summary>
    property OnAdd: TOnAdd read fOnAdd write fOnAdd;
  end;
implementation

uses
  System.Hash, System.SysUtils, flcStringPatternMatcher;

function TMotif.add(const aTag, aReturn: string): TMotif;
var
  item: TMotifItem;
begin
  result:=self;
  // item is created in createItems and here we change the Return value
  item:=createItems(aTag);
  item.Value.AsString:=aReturn;

  if strContainsGblob(aTag) then
    Inc(fWildcardsNum);

  if Assigned(fOnAdd) then
    fOnAdd(aTag, item);
end;

constructor TMotif.Create;
begin
  inherited;
  fItemList:=TIndexedObjectList<TMotifItem>.Create(true);
  fItemList.Indexes.Add('GUID', 'GUID');

  fLocatorList:=TIndexedObjectList<TLocateItem>.Create(true);
  fLocatorList.Indexes.Add('Tag', 'Tag');

  fOnAdd:=nil;
  fWildcardsNum:=0;
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
  result.fGUID:=GUIDToString(guid);
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
  list:TList<TMotifItem>;
  needsGlob: boolean;
  locItem: TLocateItem;
  num: integer;

  procedure extractItems(const aTag: string);
  var
    guid: TGUID;
  begin
    loc:=fLocatorList.Get('Tag', aTag);
    if not assigned(loc) then
      Exit
    else
    begin
      for guid in loc.GUIDS do
        list.Add(fItemList.Get('GUID', GUIDToString(guid)));
    end;
  end;

begin
  list:=TList<TMotifItem>.Create;
  result:=list;

  prepTag:=cleanTag(aTag);

  needsGlob:= strContainsGblob(prepTag) or (fWildcardsNum > 0);

  if (not needsGlob) then
  begin
    extractItems(prepTag);
  end
  else
  begin
    if prepTag = '*' then
    begin
      for locItem in fLocatorList do
        extractItems(locItem.Tag);
    end
    else
    begin
      for locItem in fLocatorList do
      begin
        if (fWildcardsNum > 0) then
          num:=StrZMatchPatternW(PWideChar(locItem.Tag), PWideChar(prepTag))
        else
          num:=StrZMatchPatternW(PWideChar(prepTag), PWideChar(locItem.Tag));

        if num > 0 then
          extractItems(locItem.Tag);
      end;
    end;
  end;
end;

function TMotif.list(const aPattern: string): string;
var
  list: TList<TMotifItem>;
  item: TMotifItem;
  patt: string;
begin
  if aPattern.IsEmpty then
    patt:='*'
  else
    patt:=aPattern;
  list:=find(patt);
  result:='';
  for item in list do
    result:=result + item.Tag + ' -> ' + item.Value.AsString + sLineBreak;
  result:=result.Trim;
  FreeAndNil(list);
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
    if strContainsGblob(aTag) then
      Dec(fWildcardsNum);
  end;
end;

function TMotif.strContainsGblob(const aTag: string): boolean;
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
