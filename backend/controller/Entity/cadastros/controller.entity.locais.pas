unit Controller.Entity.Locais;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controller.Entity.Interfaces, Model.Entity.Interfaces, Dao.Entity.Interfaces,
  db;

type

  { TLocaisController }

  TLocaisController = class(TInterfacedObject, iLocaisController)
  private
    FModel : iLocaisModel;
    FDao : iLocaisDao;
    FDataSource : TDataSource;
  public
    constructor Create(aDataSource : TDataSource);
    destructor destroy; override;
    class function New(aDataSource : TDataSource = nil): iLocaisController;
    function Locais(aId: integer): iLocaisController;
    function Locais: iLocaisController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
  end;

implementation

uses Model.Entity.Locais, Dao.Locais;
{ TLocaisController }

constructor TLocaisController.Create(aDataSource : TDataSource);
begin
  FDataSource := aDataSource;
  FModel := TLocaisModel.New;
  FDao := TLocaisDao.New;
end;

destructor TLocaisController.destroy;
begin
  inherited destroy;
end;

class function TLocaisController.New(aDataSource : TDataSource = nil): iLocaisController;
begin
  Result := Self.Create(aDataSource);
end;

function TLocaisController.Locais(aId: integer): iLocaisController;
begin
  Result := Self;
  if Assigned(FDataSource) then;
     FDataSource.DataSet := FDao.Locais(aID);
end;

function TLocaisController.Locais: iLocaisController;
begin
  Result := Self;
  FDao.Locais(FModel.Id,FModel);
end;

function TLocaisController.Delete: Boolean;
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

function TLocaisController.Save: Boolean;
begin
  if FDataSource <> nil then
     Begin
       FModel.Descricao(FDataSource.DataSet.FieldByName('descricao').AsString);
       FModel.Endereco(FDataSource.Dataset.FieldByName('endereco').AsString);
       if FDataSource.Dataset.FindField('id') <> nil then
          FModel.Id(FDataSource.Dataset.FieldByName('id').AsInteger)
       else
          FModel.Id(0);
     end;
  Result := FDao.Save(FModel);
end;

function TLocaisController.Id: integer;
begin
  Result := FModel.Id;
end;


end.

