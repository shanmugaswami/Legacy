object frmCatalogList: TfrmCatalogList
  Left = 0
  Top = 0
  Caption = 'Catalog '
  ClientHeight = 464
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 21
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 594
    Height = 65
    Align = alTop
    BevelEdges = []
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 751
    object btnOpen: TButton
      Left = 17
      Top = 19
      Width = 100
      Height = 30
      Caption = 'Open Ini File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnOpenClick
    end
    object btnSaveAs: TButton
      Left = 131
      Top = 19
      Width = 100
      Height = 30
      Caption = 'Save to File'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnSaveAsClick
    end
  end
  object pnlBottom: TPanel
    Left = 467
    Top = 65
    Width = 127
    Height = 399
    Align = alRight
    BevelEdges = []
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = 424
    ExplicitTop = -247
    ExplicitHeight = 496
    object btnMoveUp: TButton
      Left = 14
      Top = 24
      Width = 100
      Height = 30
      Caption = 'Move Up'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnMoveUpClick
    end
    object btnMoveDown: TButton
      Left = 14
      Top = 72
      Width = 100
      Height = 30
      Caption = 'Move Down'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnMoveDownClick
    end
    object btnConvertBinaryToIni: TButton
      Left = 5
      Top = 336
      Width = 116
      Height = 49
      Caption = 'Run utility (Binary To Ini)'
      TabOrder = 2
      WordWrap = True
      OnClick = btnConvertBinaryToIniClick
    end
  end
  object pnlCatalog: TPanel
    Left = 0
    Top = 65
    Width = 467
    Height = 399
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 624
    ExplicitHeight = 496
    object LvwCatalog: TListView
      Left = 1
      Top = 1
      Width = 465
      Height = 397
      Align = alClient
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Columns = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitWidth = 622
      ExplicitHeight = 494
    end
  end
end
