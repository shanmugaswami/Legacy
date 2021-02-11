program TSIReorderItems;

uses
  Vcl.Forms,
  CatalogList in 'CatalogList.pas' {frmCatalogList},
  uHelper in 'uHelper.pas',
  uBinaryUtils in 'uBinaryUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCatalogList, frmCatalogList);
  Application.Run;
end.
