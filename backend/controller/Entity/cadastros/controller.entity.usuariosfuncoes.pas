unit Controller.Entity.UsuariosFuncoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controller.Entity.Interfaces, Model.Entity.Interfaces, Dao.Entity.Interfaces,
  db, Horse.JWT;

type

  { TUsuariosFuncoesController }

  TUsuariosFuncoesController = class(TInterfacedObject, iUsuariosFuncoesController)
  private
    FModel : iUsuariosFuncoesModel;
    FDao : iUsuariosFuncoesDao;
    FDataSource : TDataSource;
  public
    constructor Create(aDataSource : TDataSource);
    destructor destroy; override;
    class function New(aDataSource : TDataSource = nil): iUsuariosFuncoesController;
    function UsuariosFuncoes(aId: integer): iUsuariosFuncoesController;
    function UsuariosFuncoes: iUsuariosFuncoesController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
    function ValidarUsuariosFuncoes(aUsuario: integer; aFuncao: integer): boolean;
  end;

implementation

uses Model.Entity.UsuariosFuncoes, Dao.UsuariosFuncoes;
{ TUsuariosFuncoesController }

constructor TUsuariosFuncoesController.Create(aDataSource : TDataSource);
begin
  FDataSource := aDataSource;
  FModel := TUsuariosFuncoesModel.New;
  FDao := TUsuariosFuncoesDao.New;
end;

destructor TUsuariosFuncoesController.destroy;
begin
  inherited destroy;
end;

class function TUsuariosFuncoesController.New(aDataSource : TDataSource = nil): iUsuariosFuncoesController;
begin
  Result := Self.Create(aDataSource);
end;

function TUsuariosFuncoesController.UsuariosFuncoes(aId: integer): iUsuariosFuncoesController;
begin
  Result := Self;
  if Assigned(FDataSource) then;
     FDataSource.DataSet := FDao.UsuariosFuncoes(aID);
end;

function TUsuariosFuncoesController.UsuariosFuncoes: iUsuariosFuncoesController;
begin
  Result := Self;
  FDao.UsuariosFuncoes(FModel.Id,FModel);
end;

function TUsuariosFuncoesController.Delete: Boolean;
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

function TUsuariosFuncoesController.Save: Boolean;
begin
  if FDataSource <> nil then
     Begin
       FModel.Usuario_Id(FDataSource.DataSet.FieldByName('usuarioid').AsInteger);
       FModel.Funcao_Id(FDataSource.Dataset.FieldByName('funcaoid').AsInteger);
       if FDataSource.Dataset.FindField('id') <> nil then
          FModel.Id(FDataSource.Dataset.FieldByName('id').AsInteger)
       else
          FModel.Id(0);
     end;
  Result := FDao.Save(FModel);
end;

function TUsuariosFuncoesController.Id: integer;
begin
  Result := FModel.Id;
end;

function TUsuariosFuncoesController.ValidarUsuariosFuncoes(aUsuario: integer;
  aFuncao: integer): boolean;
begin
  Result := FDao.ValidarUsuariosFuncoes(aUsuario,aFuncao);
end;


end.

