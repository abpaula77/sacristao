unit Controller.Entity.Horarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controller.Entity.Interfaces, Model.Entity.Interfaces, Dao.Entity.Interfaces,
  db;

type

  { THorariosController }

  THorariosController = class(TInterfacedObject, iHorariosController)
  private
    FModel : iHorariosModel;
    FDao : iHorariosDao;
    FDataSource : TDataSource;
  public
    constructor Create(aDataSource : TDataSource);
    destructor destroy; override;
    class function New(aDataSource : TDataSource = nil): iHorariosController;
    function Horarios(aId: integer): iHorariosController;
    function Horarios: iHorariosController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
  end;

implementation

uses Model.Entity.Horarios, Dao.Horarios;
{ TLocaisController }

constructor THorariosController.Create(aDataSource : TDataSource);
begin
  FDataSource := aDataSource;
  FModel := THorariosModel.New;
  FDao := THorariosDao.New;
end;

destructor THorariosController.destroy;
begin
  inherited destroy;
end;

class function THorariosController.New(aDataSource : TDataSource = nil): iHorariosController;
begin
  Result := Self.Create(aDataSource);
end;

function THorariosController.Horarios(aId: integer): iHorariosController;
begin
  Result := Self;
  if Assigned(FDataSource) then;
     FDataSource.DataSet := FDao.Horarios(aID);
end;

function THorariosController.Horarios: iHorariosController;
begin
  Result := Self;
  FDao.Horarios(FModel.Id,FModel);
end;

function THorariosController.Delete: Boolean;
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

function THorariosController.Save: Boolean;
begin
  if FDataSource <> nil then
     Begin
       FModel.Descricao(FDataSource.DataSet.FieldByName('descricao').AsString);
       FModel.Local_Id(FDataSource.DataSet.FieldByName('localid').AsInteger);
       FModel.Hora_Inicio(FDataSource.DataSet.FieldByName('horainicio').AsString);
       FModel.Segunda(FDataSource.DataSet.FieldByName('segunda').AsBoolean);
       FModel.Terca(FDataSource.DataSet.FieldByName('terca').AsBoolean);
       FModel.Quarta(FDataSource.DataSet.FieldByName('quarta').AsBoolean);
       FModel.Quinta(FDataSource.DataSet.FieldByName('quinta').AsBoolean);
       FModel.Sexta(FDataSource.DataSet.FieldByName('sexta').AsBoolean);
       FModel.Sabado(FDataSource.DataSet.FieldByName('sabado').AsBoolean);
       FModel.Domingo(FDataSource.DataSet.FieldByName('domingo').AsBoolean);
       if FDataSource.Dataset.FindField('id') <> nil then
          FModel.Id(FDataSource.Dataset.FieldByName('id').AsInteger)
       else
          FModel.Id(0);
     end;
  Result := FDao.Save(FModel);
end;

function THorariosController.Id: integer;
begin
  Result := FModel.Id;
end;


end.

