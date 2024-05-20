unit View.Pages.Principal;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, PQConnection, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, DBGrids, ActnList, Buttons,
  Controller.Entity.Interfaces, ZDataset, ZConnection, Controller.Entity.Locais;

type
  TOperacao = (toNone, toInsert, toUpdate, toView);

  { TForm1 }

  TForm1 = class(TForm)
    aclMenu: TActionList;
    acInsert: TAction;
    acDelete: TAction;
    acSearch: TAction;
    acClose: TAction;
    acSave: TAction;
    acCancel: TAction;
    acView: TAction;
    acUpdate: TAction;
    btnTestDB: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    dtsLista: TDataSource;
    DBGLista: TDBGrid;
    edtPesquisa: TEdit;
    ImageList1: TImageList;
    PCBase: TPageControl;
    pnlTop: TPanel;
    sbBase: TStatusBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    TSCadastro: TTabSheet;
    TSLista: TTabSheet;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    procedure acCancelExecute(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure acInsertExecute(Sender: TObject);
    procedure aclMenuUpdate(AAction: TBasicAction; var Handled: Boolean);
    procedure acSaveExecute(Sender: TObject);
    procedure acUpdateExecute(Sender: TObject);
    procedure acViewExecute(Sender: TObject);
    procedure btnTestDBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PQConnection1AfterConnect(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FOperacao: TOperacao;
    FCtrl : iLocaisController;
    procedure Status;
  public
    function doSave: boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnTestDBClick(Sender: TObject);
begin
   try
     //TDB.getInstance.Conexao.Connected := True;
     //TDB.getInstance.Conexao.Connected := False;
     ShowMessage('Database Conectado com sucesso !');
   except
     on E: exception do
        ShowMessage(E.Message);
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i : integer;
begin
  FOperacao := toNone;
  PCBase.ActivePage := TSLista;
  for i := 0 to PCBase.PageCount - 1 do
     PCBase.Page[i].TabVisible:=False;
  FCtrl:= TLocaisController.New(dtsLista);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  FCtrl.Locais(0);
end;

procedure TForm1.PQConnection1AfterConnect(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin

end;

procedure TForm1.Status;
begin
  acSearch.Enabled := FOperacao = toNone;
  acInsert.Enabled := FOperacao = toNone;
  acUpdate.Enabled := (FOperacao = toNone) and (dtsLista.DataSet <> nil) and (not dtsLista.DataSet.IsEmpty);
  acView.Enabled := (FOperacao = toNone) and (dtsLista.DataSet <> nil) and (not dtsLista.DataSet.IsEmpty);
  acDelete.Enabled := (FOperacao = toNone) and (dtsLista.DataSet <> nil) and (not dtsLista.DataSet.IsEmpty);
  acSave.Enabled := (FOperacao in [toInsert,toUpdate]);
  acCancel.Enabled := (FOperacao in [toInsert,toUpdate,toView]);
  acClose.Enabled := FOperacao = toNone;
end;

function TForm1.doSave: boolean;
begin
  Result := True;
end;

procedure TForm1.acCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.acCancelExecute(Sender: TObject);
begin
  FOperacao := toNone;
  PCBase.ActivePage := TSLista;
end;

procedure TForm1.acDeleteExecute(Sender: TObject);
begin
  //
end;

procedure TForm1.acInsertExecute(Sender: TObject);
begin
  FOperacao := toInsert;
  PCBase.ActivePage := TSCadastro;
end;

procedure TForm1.aclMenuUpdate(AAction: TBasicAction; var Handled: Boolean);
begin
  Status;
end;

procedure TForm1.acSaveExecute(Sender: TObject);
begin
  if doSave then
     Begin
       FOperacao := toNone;
       PCBase.ActivePage := TSLista;
     end;
end;

procedure TForm1.acUpdateExecute(Sender: TObject);
begin
  FOperacao := toUpdate;
  PCBase.ActivePage := TSCadastro;
end;

procedure TForm1.acViewExecute(Sender: TObject);
begin
  FOperacao := toView;
  PCBase.ActivePage := TSCadastro;
end;

end.

