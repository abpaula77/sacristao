unit Dao.UsuariosLocais;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Model.Conexoes.ConexaoPostgreSQL, Dao.Entity.Interfaces,
  Model.Entity.Interfaces, DB;
type

  { TUsuariosLocaisDao }

  TUsuariosLocaisDao = class(TInterfacedObject, iUsuariosLocaisDao)
    private
       FSQL : TStringList;
       FQry : TSQLQuery;
       function Exist(aId : integer): boolean;
       procedure Bind(aDataSet : TDataSet; aModel: iUsuariosLocaisModel);
    public
       constructor Create;
       destructor Destroy; override;
       class function New: iUsuariosLocaisDao;
       function UsuariosLocais(aId : integer) : TDataSet; overload;
       function UsuariosLocais(aId : integer;aModel : iUsuariosLocaisModel) : iUsuariosLocaisDao; overload;
       function Delete(aId : integer): boolean;
       function Save(aModel : iUsuariosLocaisModel): boolean;
       function ValidarUsuariosLocais(aUsuario: integer; aLocal: integer): boolean;
  end;

implementation

{ TUsuariosLocaisDao }

function TUsuariosLocaisDao.Exist(aId: integer): boolean;
var lQry : TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT ');
      lQry.SQL.Add(' a.id ');
      lQry.SQL.Add('FROM public.usuarios_locais a');
      lQry.SQL.Add('WHERE a.Id = :Id');
      lQry.ParamByName('Id').AsInteger := aId;
      try
         lQry.Open;
         Result := not lQry.IsEmpty;
      except
        on E: exception do
           Begin
              Result := False;
              Raise Exception.Create(E.Message);
           end;
      end;
   finally
     lQry.Close;
     FreeAndNil(lQry);
   end;

end;

procedure TUsuariosLocaisDao.Bind(aDataSet: TDataSet; aModel: iUsuariosLocaisModel);
begin
  aModel.id(aDataSet.FieldByName('id').AsInteger);
  aModel.Usuario_Id(aDataSet.FieldByName('usuario_id').AsInteger);
  aModel.Local_Id(aDataSet.FieldByName('local_id').AsInteger);
end;

constructor TUsuariosLocaisDao.Create;
begin
  FSQL := TStringList.Create;
  FQry := TSQLQuery.Create(nil);
  FQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
end;

destructor TUsuariosLocaisDao.Destroy;
begin
  FreeAndNil(FSQL);
  FQry.Close;
  FreeAndNil(FQry);
  inherited Destroy;
end;

class function TUsuariosLocaisDao.New: iUsuariosLocaisDao;
begin
   Result := Self.Create;
end;

function TUsuariosLocaisDao.UsuariosLocais(aId: integer): TDataSet;
begin
   FQry.Close;
   FQry.SQL.Clear;
   FQry.SQL.Add('SELECT ');
   FQry.SQL.Add(' a.id ');
   FQry.SQL.Add(',a.usuario_id ');
   FQry.SQL.Add(',a.local_id ');
   FQry.SQL.Add('FROM public.usuarios_locais a');
   if aId > 0 then
      Begin
         FQry.SQL.Add('WHERE a.Id = :Id');
         FQry.ParamByName('Id').AsInteger := aId;
      end;
   try
      FQry.Open;
      Result := FQry;
   except
     on E: exception do
        Raise Exception.Create(E.Message);
   end;
end;

function TUsuariosLocaisDao.UsuariosLocais(aId: integer; aModel: iUsuariosLocaisModel): iUsuariosLocaisDao;
var lQry: TSQLQuery;
begin
   Result := Self;
   if aId <= 0 then
      Raise Exception.Create('ID não foi informado !');

   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT * FROM public.usuarios_locais ');
      lQry.SQL.Add('WHERE Id = :Id');
      lQry.ParamByName('Id').AsInteger := aId;
      try
         lQry.Open;
         if not lQry.IsEmpty then
            Bind(lQry,aModel);
      except
         on E: exception do
            Raise Exception.Create(E.Message);
      end;
   finally
     lQry.Close;
     FreeAndNil(lQry);
   end;
end;

function TUsuariosLocaisDao.Delete(aId: integer): boolean;
var lQry: TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lQry.SQL.Add('DELETE FROM public.usuarios_locais ');
      lQry.SQL.Add('WHERE Id = :Id');
      lQry.ParamByName('Id').AsInteger := aId;
      try
         lQry.ExecSQL;
         lQry.SQLTransaction.Commit;
      except
         Result := False;
      end;
   finally
     lQry.Close;
     FreeAndNil(lQry);
   end;
end;

function TUsuariosLocaisDao.Save(aModel: iUsuariosLocaisModel): boolean;
var lQry : TSQLQuery;
  lExist : Boolean;
begin
   if aModel = nil then
      Begin
         Raise Exception.Create('Função não informada !');
         Exit(False);
      end;
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lExist:= Exist(aModel.Id);
      if not lExist then
         Begin
            lQry.SQL.Add('INSERT INTO sacristao.public.usuarios_locais');
            lQry.SQL.Add('(usuario_id, local_id)');
            lQry.SQL.Add('VALUES');
            lQry.SQL.Add('(:usuario_id, :local_id)');
            lQry.SQL.Add('RETURNING id');
         end
      else
         Begin
            lQry.SQL.Add('UPDATE public.usuarios_locais SET');
            lQry.SQL.Add(' usuario_id = :usuarios_id,');
            lQry.SQL.Add(' local_id = :local_id');
            lQry.SQL.Add('WHERE');
            lQry.SQL.Add('id = :id');
            lQry.ParamByName('id').AsInteger := aModel.Id;
         end;
      lQry.ParamByName('usuario_id').AsInteger := aModel.Usuario_Id;
      lQry.ParamByName('local_id').AsInteger := aModel.Local_Id;
      try
         if not lExist then
            Begin
               lQry.Open;
               aModel.Id(lQry.FieldByName('id').AsInteger);
            end
         else
            lQry.ExecSQL;
         lQry.SQLTransaction.Commit;
      except
         Result := False;
      end;
   finally
     lQry.Close;
     FreeAndNil(lQry);
   end;

end;

function TUsuariosLocaisDao.ValidarUsuariosLocais(aUsuario: integer;
  aLocal: integer): boolean;
begin
   FQry.Close;
   FQry.SQL.Clear;
   FQry.SQL.Add('SELECT ');
   FQry.SQL.Add(' a.id ');
   FQry.SQL.Add('FROM public.usuarios_locais a');
   FQry.SQL.Add('WHERE a.usuario_id = :usuario_id');
   FQry.SQL.Add('AND a.local_id = :local_id');
   FQry.ParamByName('usuario_id').AsInteger := aUsuario;
   FQry.ParamByName('local_id').AsInteger := aLocal;
   try
      FQry.Open;
      if FQry.IsEmpty then
         Result := False
      else
         Result := True;
   except
     on E: exception do
        Raise Exception.Create(E.Message);
   end;
end;

end.

