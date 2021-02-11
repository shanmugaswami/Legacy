unit uBinaryUtils;
//Unit that contains utility for converting Bin faile to ini file

interface

uses
  SysUtils, Classes, System.IniFiles;

  Type

   //Record structure for Item
   TBinItemRecord = record
     ItemLength: Word;
     ItemNameLength: Word;
     ItemName: array of ansichar;
     ItemPriceLength: Word;
     ItemPrice: array of ansichar;
     ItemDescLength: Word;
     ItemDesc:array of ansichar;
   end;

   //Record structure for Binary file header
   TBinHeaderRecord =  record
     HeaderLength: Word;
     FileTitleLength: Word;
     FileTitle: array of ansichar;
     ItemCount:  Word;
   end;


  procedure ReadBinary(filename: string);

implementation

uses
  vcl.Dialogs, uhelper,  Generics.Collections, System.UITypes;

// Using BinaryReader
procedure ReadBinary(filename: string);
var
  dictCatalog: TDictionary<string, string>;
  //File Declaration
  ini : TIniFile;
  fBinaryFile: File;
  //Record declaration
  BinHeader:  TBinHeaderRecord;
  ABinItems: array of TBinItemRecord;
  //Counters
   i, j: integer;
  sItemName, sItemPrice, sItemDesc: string;
  //Byte & word
  oneByte: Byte;
begin
   MessageDlg(' Starting Binary to Ini convertion for ' +   FileName,
         mtInformation, [mbOk], 0);
  dictCatalog := TDictionary<string, string>.Create();
  try
    // Open file & read all data
    AssignFile(fBinaryFile, filename);
    FileMode := fmOpenRead;
    //-----Read Header-------

    Reset(fBinaryFile, 1);
    //Set file to be read in 1
    BlockRead(fBinaryFile, BinHeader.HeaderLength, 2);
    BlockRead(fBinaryFile, BinHeader.FileTitleLength, 2);
     //Header code for ascii characters
    SetLength(BinHeader.FileTitle,BinHeader.FileTitleLength ) ;
    //Read title 1 ascii char at a time
    for i:= 1 to BinHeader.FileTitleLength do
    begin
       BlockRead(fBinaryFile,oneByte, 1);
       BinHeader.FileTitle[i]:=AnsiChar(OneByte);
    end;
    BlockRead(fBinaryFile, BinHeader.ItemCount, 2);

     //Below code handles ITem section of Binary file
    SetLength(ABinItems, BinHeader.ItemCount ) ;

    for i:= 1 to  BinHeader.ItemCount do
    begin
      BlockRead(fBinaryFile, ABinItems[i].ItemLength, 2);
      BlockRead(fBinaryFile, ABinItems[i].ItemNameLength, 2);
      SetLength(ABinItems[i].ItemName, ABinItems[i].ItemNameLength ) ;
      for j:= 0 to ABinItems[i].ItemNameLength-1 do
      begin
         BlockRead(fBinaryFile,oneByte, 1);
         ABinItems[i].ItemName[j]:=AnsiChar(OneByte);
      end;
      BlockRead(fBinaryFile, ABinItems[i].ItemPriceLength, 2);
      SetLength(ABinItems[i].ItemPrice, ABinItems[i].ItemPriceLength ) ;
      for j:= 0 to ABinItems[i].ItemPriceLength-1 do
      begin
         BlockRead(fBinaryFile,oneByte, 1);
         ABinItems[i].ItemPrice[j]:=AnsiChar(OneByte);
      end;
      BlockRead(fBinaryFile, ABinItems[i].ItemDescLength, 2);
      SetLength(ABinItems[i].ItemDesc, ABinItems[i].ItemDescLength ) ;
       for j:= 0 to ABinItems[i].ItemDescLength -1 do
      begin
         BlockRead(fBinaryFile,oneByte, 1);
         ABinItems[i].ItemDesc[j]:=AnsiChar(OneByte);
      end;

    end;

    //Feed the datadictionay with items

     ini := TIniFile.Create(ChangeFileExt(filename, '.ini'));
     if FileExists(filename) then
       DeleteFile(filename);

     try
       for i:= 1 to BinHeader.ItemCount do
        begin
           dictCatalog.Clear;

           sItemDesc:='';
           SetString(sItemDesc, PAnsiChar(@ABinItems[i].ItemDesc[0]), Length(ABinItems[i].ItemDesc));
           dictCatalog.Add(DescriptionCaption,sItemDesc);

           sItemPrice:= '';
           SetString(sItemPrice, PAnsiChar(@ABinItems[i].ItemPrice[0]), Length(ABinItems[i].ItemPrice));
           dictCatalog.Add(PriceCaption, sItemPrice);

           sItemName:= '';
           SetString(sItemName, PAnsiChar(@ABinItems[i].ItemName[0]), Length(ABinItems[i].ItemName));
           dictCatalog.Add(ItemNameCaption, sItemName);

           TIniFileUtility.WriteIniSection( ini, 'ITEM'+inttoStr(i), dictCatalog );
        end;
     finally
       ini.Free;
        dictCatalog.Free
     end;

    CloseFile(fBinaryFile);

    MessageDlg(' Completed Binary to Ini convertion ',
         mtInformation, [mbOk], 0);

  except on E: Exception do
    Showmessage('Error reading Binary file '+ #13#10+
      E.Message);
  end;
end;



end.
