unit Controller.Entity.UsuariosLocais;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controller.Entity.Interfaces, Model.Entity.Interfaces, Dao.Entity.Interfaces,
  db, Horse.JWT;

type

  { TUsuariosLocaisController }

  TUsuariosLocaisController = class(TInterfacedObject, iUsuariosLocaisController)
  private
    FModel : iUsuariosLocaisModel;
    FDao : iUsuariosLocaisDao;
    FDataSource : TDataSource;
  public
    constructor Create(aDataSource : TDataSource);
    destructor destroy; override;
    class function New(aDataSource : TDataSource = nil): iUsuariosLocaisController;
    function UsuariosLocais(aId: integer): iUsuariosLocaisController;
    function UsuariosLocais: iUsuariosLocaisController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
    function ValidarUsuariosLocais(aUsuario: integer; aLocal: integer): boolean;
  end;

implementation

uses Model.Entity.UsuariosLocais, Dao.UsuariosLocais;
{ TUsuariosLocaisController }

constructor TUsuariosLocaisController.Create(aDataSource : TDataSource);
begin
  FDataSource := aDataSource;
  FModel := TUsuariosLocaisModel.New;
  FDao := TUsuariosLocaisDao.New;
end;

destructor TUsuariosLocaisController.destroy;
begin
  inherited destroy;
end;

class function TUsuariosLocaisController.New(aDataSource : TDataSource = nil): iUsuariosLocaisController;
begin
  Result := Self.Create(aDataSource);
end;

function TUsuariosLocaisController.UsuariosLocais(aId: integer): iUsuariosLocaisController;
begin
  Result := Self;
  if Assigned(FDataSource) then;
     FDataSource.DataSet := FDao.UsuariosLocais(aID);
end;

function TUsuariosLocaisController.UsuariosLocais: iUsuariosLocaisController;
begin
  Result := Self;
  FDao.UsuariosLocais(FModel.Id,FModel);
end;

function TUsuariosLocaisController.Delete: Boolean;
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

function TUsuariosLocaisController.Save: Boolean;
begin
  if FDataSource <> nil then
     Begin
       FModel.Usuario_Id(FDataSource.DataSet.FieldByName('usuarioid').AsInteger);
       FModel.Local_Id(FDataSource.Dataset.FieldByName('localid').AsInteger);
       if FDataSource.Dataset.FindField('id') <> nil then
          FModel.Id(FDataSource.Dataset.FieldByName('id').AsInteger)
       else
          FModel.Id(0);
     end;
  Result := FDao.Save(FModel);
end;

function TUsuariosLocaisController.Id: integer;
begin
  Result := FModel.Id;
end;

function TUsuariosLocaisController.ValidarUsuariosLocais(aUsuario: integer;
  aLocal: integer): boolean;
begin
  Result := FDao.ValidarUsuariosLocais(aUsuario,aLocal);
end;


end.

