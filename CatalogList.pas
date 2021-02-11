unit CatalogList;

//Main Visual form to open items from Ini file and save.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, iniFiles,
  Vcl.ExtCtrls, Generics.Collections;

type
  TfrmCatalogList = class(TForm)
    pnlTop: TPanel;
    btnOpen: TButton;
    btnSaveAs: TButton;
    pnlBottom: TPanel;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    pnlCatalog: TPanel;
    LvwCatalog: TListView;
    btnConvertBinaryToIni: TButton;
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnConvertBinaryToIniClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
     procedure WMGetMinMaxInfo(var M: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;

     procedure LoadFromIniFile(AFileName: String);
     procedure SaveToIniFile(AFileName: String);

     procedure ExchangeItems(lvItem: TListView; const i, j: Integer);
     procedure PrepareListView;
  public
    { Public declarations }
  end;


var
  frmCatalogList: TfrmCatalogList;

implementation

uses
  uHelper,//Contains INI file utilities & classes used,
  uBinaryUtils,//Contains Binary related utilities;
  System.UITypes;

{$R *.dfm}

{ TForm1 }

procedure TfrmCatalogList.WMGetMinMaxInfo(var M: TWMGetMinMaxInfo);
var
  MinMaxInfo : PMinMaxInfo;
begin
  inherited;
  MinMaxInfo := M.MinMaxInfo;
  MinMaxInfo^.ptMaxTrackSize.X := 800; // Maximum Width
  MinMaxInfo^.ptMaxTrackSize.Y := 600; // Maximum Height
  MinMaxInfo^.ptMinTrackSize.X := 400; // Minimum Width
  MinMaxInfo^.ptMinTrackSize.Y := 300; // Minimum Height
end;

procedure TfrmCatalogList.btnOpenClick(Sender: TObject);
var
  OpenDialog1: TOpenDialog;
begin
   //Open File and load into list view
   OpenDialog1:= TOpenDialog.Create(Self);
   OpenDialog1.Filter := 'Ini files (*.initxt)|*.INI';

   if OpenDialog1.Execute then
   begin
     { First check if the file exists. }
     if FileExists(OpenDialog1.FileName) then
        LoadFrominiFile(OpenDialog1.FileName)
     else
        { Otherwise, raise an exception. }
        raise Exception.Create('File does not exist.');
   end;

end;


procedure TfrmCatalogList.btnSaveAsClick(Sender: TObject);
var
  SaveDialog1: TSaveDialog;
begin
  SaveDialog1:= TSaveDialog.Create(Self);
  SaveDialog1.Filter := 'Ini files (*.initxt)|*.INI';
  { Execute a save file dialog. }
  if SaveDialog1.Execute then
  begin
     SaveToIniFile(SaveDialog1.FileName);
     MessageDlg(' Catalog saved to file ' +   SaveDialog1.FileName,
         mtInformation, [mbOk], 0);
  end;
end;

procedure TfrmCatalogList.PrepareListView;
var
  lcColumn: TListColumn;
begin
   lcColumn := lvwCatalog.Columns.Add;
   lcColumn.Caption := ItemNameCaption;
   lcColumn.Alignment := taLeftJustify;
   lcColumn.Width := -1;

   lcColumn := lvwCatalog.Columns.Add;
   lcColumn.Caption := PriceCaption;
   lcColumn.Alignment := taRightJustify;
   lcColumn.Width :=-1;
   //No need to show desc colum, uncomment if needed
   lcColumn := lvwCatalog.Columns.Add;
   lcColumn.Caption :=  DescriptionCaption ;
   lcColumn.Alignment := taLeftJustify;
   lcColumn.Width := -1;
end;


procedure TfrmCatalogList.LoadFromIniFile(AFileName: String);
var
  LiItem: TListItem;
  i: integer;
  dictCatalog: TDictionary<string, TItem>;
  item: TItem;
begin
   PrepareListView;
   //Get the item catalog values from ini files
   dictCatalog:= TIniFileUtility.ReadIniFile(AFileName);

   if (dictCatalog = nil) or (dictCatalog.Count= 0) then
   begin
      ShowMessage('No items found in Ini File');
      Exit;
   end;

   //Parse thr' the returned dictionary and add to List view
   for i := 0 to dictCatalog.Count-1 do
   begin
     LiItem := lvwCatalog.Items.Add;
     //
     item:= Titem.Create;
     dictCatalog.TryGetValue('ITEM'+inttostr(i+1), item);

     LiItem.Caption :=  item.Name;
     LiItem.SubItems.Add(item.Price);
     LiItem.SubItems.Add(item.Description);

    item.Free;
   end;

end;


procedure TfrmCatalogList.SaveToIniFile(AFileName: String);
var
  ini : TIniFile;
  dictCatalog : TDictionary<string, string>;
  LiItem: TListItem;
  i: integer;
begin
  ini := TIniFile.Create(AFileName);
  try
    dictCatalog := TDictionary<string, string>.Create;
    try
     for i := 0 to lvwCatalog.Items.Count-1 do
       begin
          LiItem := lvwCatalog.Items[i];
          dictCatalog.Clear;
          dictCatalog.Add(lvwCatalog.Columns[0].Caption, LiItem.Caption );
          dictCatalog.Add(lvwCatalog.Columns[1].Caption, LiItem.SubItems[0]);
          dictCatalog.Add(lvwCatalog.Columns[2].Caption, LiItem.SubItems[1]);
          TIniFileUtility.WriteIniSection( ini, 'ITEM'+inttoStr(i+1), dictCatalog );
       end;
    finally
      dictCatalog.Free;
    end;
    // Save to ini file
  finally
    ini.Free;
  end;
end;

procedure TfrmCatalogList.ExchangeItems(lvItem: TListView; const i, j: Integer);
var
  tempLI: TListItem;
begin
  lvItem.Items.BeginUpdate;
  try
    tempLI := TListItem.Create(lvITem.Items);
    tempLI.Assign(lvITem.Items.Item[i]);
    lvITem.Items.Item[i].Assign(lvITem.Items.Item[j]);
    lvITem.Items.Item[j].Assign(tempLI);
    tempLI.Free;
  finally
    lvItem.Items.EndUpdate
  end;
end;

procedure TfrmCatalogList.FormCreate(Sender: TObject);
begin
   //Utility Button to convert a Binary file to Ini file available in DEv version only
   {$IFDEF DEVMODE}
     btnConvertBinaryToIni.Visible :=  True  ;
   {$ENDIF}
end;

procedure TfrmCatalogList.btnMoveDownClick(Sender: TObject);
begin
  //If there are more than one items in list and no items are selected to move, issue message
  if assigned(LvwCatalog.Items) and (LvwCatalog.Items.Count > 0 ) and (LvwCatalog.SelCount = 0)then
  begin
    Showmessage('Please select an item from Catalog to move');
    Exit;
  end
  else
    if not assigned(LvwCatalog.Items) or (LvwCatalog.Items.Count = 0 ) then
      exit;
    //If its not the last item, move down
  if LvwCatalog.Selected.Index <> LvwCatalog.Items.Count -1  then
     ExchangeItems(LvwCatalog, LvwCatalog.Selected.Index, LvwCatalog.Selected.Index+1);
end;

procedure TfrmCatalogList.btnMoveUpClick(Sender: TObject);
begin
  if assigned(LvwCatalog) and  (LvwCatalog.SelCount = 0)  and (LvwCatalog.Items.Count > 0 )then
  begin
    Showmessage('Please select an item from Catalog to move');
    Exit;
  end
  else
    if not assigned(LvwCatalog.Items) or (LvwCatalog.Items.Count = 0 ) then
      exit;
   //If not the first item move up
   if LvwCatalog.Selected.Index <> 0 then
     ExchangeItems(LvwCatalog, LvwCatalog.Selected.Index, LvwCatalog.Selected.Index-1);
end;

//----- DEV ONLY UTILITY FOR CONVERTING BIN TO INI
//ADD 'DEVMODE' in delphi compiler options, Conditional defines to see button to run the Bin to ini file conversion utility
procedure TfrmCatalogList.btnConvertBinaryToIniClick(Sender: TObject);
var
 OpenDialog1: TOpenDialog;
begin
  //Open available binary files to convert to ini
   OpenDialog1:= TOpenDialog.Create(Self);
   OpenDialog1.Filter := 'Bin files (*.bin)|*.BIN';

   if OpenDialog1.Execute then
   begin
     { First check if the file exists. }
     if FileExists(OpenDialog1.FileName) then
         ReadBinary(OpenDialog1.FileName)  //in uBinaryUtils file
     else
        { Otherwise, raise an exception. }
        raise Exception.Create('File does not exist.');
   end;
end;

end.
