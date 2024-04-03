unit Controller.Entity.Usuarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controller.Entity.Interfaces, Model.Entity.Interfaces, Dao.Entity.Interfaces,
  db, Horse.JWT;

type

  { TUsuariosController }

  TUsuariosController = class(TInterfacedObject, iUsuariosController)
  private
    FModel : iUsuariosModel;
    FDao : iUsuariosDao;
    FDataSource : TDataSource;
  public
    constructor Create(aDataSource : TDataSource);
    destructor destroy; override;
    class function New(aDataSource : TDataSource = nil): iUsuariosController;
    function Usuarios(aId: integer): iUsuariosController;
    function Usuarios: iUsuariosController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
    function ValidarUsuario(aUsername: string; aPassword: string): boolean;
    function ExistUsername: Boolean;
    function ValidarPassword: Boolean;
  end;

implementation

uses Model.Entity.Usuarios, Dao.Usuarios;
{ TUsuariosController }

constructor TUsuariosController.Create(aDataSource : TDataSource);
begin
  FDataSource := aDataSource;
  FModel := TUsuariosModel.New;
  FDao := TUsuariosDao.New;
end;

destructor TUsuariosController.destroy;
begin
  inherited destroy;
end;

class function TUsuariosController.New(aDataSource : TDataSource = nil): iUsuariosController;
begin
  Result := Self.Create(aDataSource);
end;

function TUsuariosController.Usuarios(aId: integer): iUsuariosController;
begin
  Result := Self;
  if Assigned(FDataSource) then;
     FDataSource.DataSet := FDao.Usuarios(aID);
end;

function TUsuariosController.Usuarios: iUsuariosController;
begin
  Result := Self;
  FDao.Usuarios(FModel.Id,FModel);
end;

function TUsuariosController.Delete: Boolean;
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

function TUsuariosController.Save: Boolean;
begin
  if FDataSource <> nil then
     Begin
       FModel.Senha(FDataSource.DataSet.FieldByName('senha').AsString);
       FModel.Nome(FDataSource.Dataset.FieldByName('nome').AsString);
       FModel.Nascimento(FDataSource.Dataset.FieldByName('nascimento').AsDateTime);
       FModel.Telefone(FDataSource.Dataset.FieldByName('telefone').AsString);
       FModel.Email(FDataSource.Dataset.FieldByName('email').AsString);
       FModel.Username(FDataSource.Dataset.FieldByName('username').AsString);
       if FDataSource.Dataset.FindField('id') <> nil then
          FModel.Id(FDataSource.Dataset.FieldByName('id').AsInteger)
       else
          FModel.Id(0);
     end;
  Result := FDao.Save(FModel);
end;

function TUsuariosController.Id: integer;
begin
  Result := FModel.Id;
end;

function TUsuariosController.ValidarUsuario(aUsername: string; aPassword: string): boolean;
begin
  Result := FDao.ValidarUsuario(aUsername,aPassword);
end;

function TUsuariosController.ExistUsername: Boolean;
begin
  if FDataSource <> nil then
     Begin
       FModel.Username(FDataSource.Dataset.FieldByName('username').AsString);
     end;
  if FModel.Username <> '' then
     Result := FDao.ExistUsername(FModel)
  else
     Result := False;
end;

function TUsuariosController.ValidarPassword: Boolean;
begin
  if FDataSource <> nil then
     Begin
       FModel.Senha(FDataSource.DataSet.FieldByName('senha').AsString);
     end;
  if FModel.Password <> '' then
     Begin
       if Length(FModel.Password) > 50 then
          Result := False
       else
          Result := True;
     end
  else
     Result := False;
end;


end.

