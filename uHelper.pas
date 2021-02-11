unit uHelper;
//Unit that contains ini helper functions & classes

interface

uses
 Generics.Collections, System.IniFiles, Vcl.ComCtrls, System.Classes, SysUtils;

type

  TItem = class
    Name: String;
    Price: String;
    Description: String;
  end;


 //Class for Reading and writing to Inifile
 //In general below methods use TDictionary for storing / passing name value pairs read/written to ini files
 //TDictionary is used instead of Stringlist for performance.
 TIniFileUtility = class
 public
    //Function that reads ini file specified with inifilename and returns
    //TDictionary with section name and Item values (stored in TItem)
    class function ReadIniFile(iniFileName: string): TDictionary<string, TItem>;
     //Takes inifilename & and Dictionry with Items & creates Inifile
    class function WriteToIniFile(iniFileName : string; dictCatalog : TDictionary<string, TItem>): Boolean;
    //Write to IniFie, one section at a time
    class procedure WriteIniSection(iniFile : TIniFile; sSectionName: string; dictCatalog : TDictionary<string, string>);  overload;
 end;

 const
    ItemNameCaption = 'Name';
    PriceCaption = 'Price';
    DescriptionCaption = 'Description';

implementation

uses vcl.Dialogs;


class function TIniFileUtility.ReadIniFile(iniFileName: string): TDictionary<string, TItem>;
//Reads Ini file and returns back result as TDictionary < Ini file sectionname, TItem>
//For example <ITEM1, ITEM.Name Dell Laptops XPS
//                      Item.Price=799.99
//                      Item.description="XPS laptops and 2-in-1">

var
  ini : TIniFile;
  dictCatalog : TDictionary<string, TItem>;
  i: integer;
  slSections: TStringList;
  item: TItem;
begin
  ini := TIniFile.Create(iniFileName);
  try
    dictCatalog := TDictionary<string, TItem>.Create();
    slSections := TStringList.Create;
    try
      ini.ReadSections(slSections);
      for i := 0 to slSections.Count-1 do
       begin
         Item := TItem.Create;
         //ITEM1,ITEM2 etc are section names in Ini file
         Item.Name := ini.ReadString('ITEM'+inttostr(i+1), 'Name' ,'');
         Item.Price := ini.ReadString('ITEM'+ inttostr(i+1), 'Price' ,'');
         Item.Description := ini.ReadString('ITEM'+ inttostr(i+1), 'Description' ,'');
         //Add the object to dictionary with sectionname
         dictCatalog.Add('ITEM'+inttostr(i+1), Item);
        end;

     finally
       slSections.Free;
     end;

   finally
    ini.Free;
  end;
  Result := dictCatalog;
end;


class procedure TIniFileUtility.WriteIniSection(iniFile: TIniFile; sSectionName: string;
  dictCatalog: TDictionary<string, string>);

var
  sKey, sValue : string;
begin
  for sKey in dictCatalog.keys do
  begin
    sValue := dictCatalog.Items[skey];
    iniFile.WriteString( sSectionName, sKey, sValue );
  end;
end;



class function TIniFileUtility.WriteToIniFile(iniFileName : string; dictCatalog : TDictionary<string, TItem>): Boolean;
// Function that creates ini file and writes every item in TDictionary to ini file.
//Returns true if operation succeeds.
var
  iniFile : TIniFile;
  sKey : string;
  sValue: TITem;
  iItemCount: Integer;
begin
  //Create Ini file & write contents of Dictionary into int
  iniFile := TIniFile.Create(iniFileName);
  try
    try
      Result:= True;

      iItemCount := 1;
      // There is no ini. Write sections, so have to write each section individually
      for sKey in dictCatalog.keys do
      begin
        sValue := dictCatalog.Items[skey];
        iniFile.WriteString( 'ITEM'+inttoStr(iItemCount),ItemNameCaption, TItem(sValue).Name);
        iniFile.WriteString( 'ITEM'+inttoStr(iItemCount),PriceCaption, TItem(sValue).Price);
        iniFile.WriteString( 'ITEM'+inttoStr(iItemCount),DescriptionCaption, TItem(sValue).Description);
       inc(iItemCount);
      end;

    Except on E:Exception do
    begin
       Showmessage('Exception occured writing to ini file'+ E.Message);
       Result:= False;
    end;
    end;

  finally
     iniFile.Free;
  end;

end;

end.
