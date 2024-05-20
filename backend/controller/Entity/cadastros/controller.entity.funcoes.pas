unit Controller.Entity.Funcoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controller.Entity.Interfaces, Model.Entity.Interfaces, Dao.Entity.Interfaces,
  db;

type

  { TLocaisController }

  TFuncoesController = class(TInterfacedObject, iFuncoesController)
  private
    FModel : iFuncoesModel;
    FDao : iFuncoesDao;
    FDataSource : TDataSource;
  public
    constructor Create(aDataSource : TDataSource);
    destructor destroy; override;
    class function New(aDataSource : TDataSource = nil): iFuncoesController;
    function Funcoes(aId: integer): iFuncoesController;
    function Funcoes: iFuncoesController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
  end;

implementation

uses Model.Entity.Funcoes, Dao.Funcoes;
{ TLocaisController }

constructor TFuncoesController.Create(aDataSource : TDataSource);
begin
  FDataSource := aDataSource;
  FModel := TFuncoesModel.New;
  FDao := TFuncoesDao.New;
end;

destructor TFuncoesController.destroy;
begin
  inherited destroy;
end;

class function TFuncoesController.New(aDataSource : TDataSource = nil): iFuncoesController;
begin
  Result := Self.Create(aDataSource);
end;

function TFuncoesController.Funcoes(aId: integer): iFuncoesController;
begin
  Result := Self;
  if Assigned(FDataSource) then;
     FDataSource.DataSet := FDao.Funcoes(aID);
end;

function TFuncoesController.Funcoes: iFuncoesController;
begin
  Result := Self;
  FDao.Funcoes(FModel.Id,FModel);
end;

function TFuncoesController.Delete: Boolean;
begin
  if FDataSource <> nil then
     Begin
       if FDataSource.Dataset.FindField('id') <> nil then
          FModel.Id(FDataSource.Dataset.FieldByName('id').AsInteger)
       else
          FModel.Id(0);
     end;
  Result := FDao.Delete(FModel.Id);
end;

function TFuncoesController.Save: Boolean;
begin
  if FDataSource <> nil then
     Begin
       FModel.Descricao(FDataSource.DataSet.FieldByName('descricao').AsString);
       if FDataSource.Dataset.FindField('id') <> nil then
          FModel.Id(FDataSource.Dataset.FieldByName('id').AsInteger)
       else
          FModel.Id(0);
     end;
  Result := FDao.Save(FModel);
end;

function TFuncoesController.Id: integer;
begin
  Result := FModel.Id;
end;


end.

