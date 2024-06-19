unit Dao.Usuarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Model.Conexoes.ConexaoPostgreSQL, Dao.Entity.Interfaces,
  Model.Entity.Interfaces, DB;
type

  { TUsuariosDao }

  TUsuariosDao = class(TInterfacedObject, iUsuariosDao)
    private
       FSQL : TStringList;
       FQry : TSQLQuery;
       function Exist(aId : integer): boolean;
       procedure Bind(aDataSet : TDataSet; aModel: iUsuariosModel);
    public
       constructor Create;
       destructor Destroy; override;
       class function New: iUsuariosDao;
       function Usuarios(aId : integer) : TDataSet; overload;
       function Usuarios(aId : integer;aModel : iUsuariosModel) : iUsuariosDao; overload;
       function ValidarUsuario(aUsername : string;aPassword : string) : boolean;
       function Delete(aId : integer): boolean;
       function Save(aModel : iUsuariosModel): boolean;
       function ExistUsername(aModel : iUsuariosModel): boolean;
  end;

implementation

{ TUsuariosDao }

function TUsuariosDao.Exist(aId: integer): boolean;
var lQry : TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT ');
      lQry.SQL.Add(' a.id ');
      lQry.SQL.Add('FROM public.usuarios a');
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

procedure TUsuariosDao.Bind(aDataSet: TDataSet; aModel: iUsuariosModel);
begin
  aModel.id(aDataSet.FieldByName('id').AsInteger);
  aModel.Senha(aDataSet.FieldByName('senha').AsString);
  aModel.Nome(aDataSet.FieldByName('nome').AsString);
  aModel.Nascimento(aDataSet.FieldByName('nascimento').AsDateTime);
  aModel.Email(aDataSet.FieldByName('email').AsString);
  aModel.Telefone(aDataSet.FieldByName('telefone').AsString);
  aModel.Username(aDataSet.FieldByName('username').AsString);
end;

constructor TUsuariosDao.Create;
begin
  FSQL := TStringList.Create;
  FQry := TSQLQuery.Create(nil);
  FQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
end;

destructor TUsuariosDao.Destroy;
begin
  FreeAndNil(FSQL);
  FQry.Close;
  FreeAndNil(FQry);
  inherited Destroy;
end;

class function TUsuariosDao.New: iUsuariosDao;
begin
   Result := Self.Create;
end;

function TUsuariosDao.Usuarios(aId: integer): TDataSet;
begin
   FQry.Close;
   FQry.SQL.Clear;
   FQry.SQL.Add('SELECT ');
   FQry.SQL.Add(' a.id ');
   FQry.SQL.Add(',a.senha ');
   FQry.SQL.Add(',a.nome ');
   FQry.SQL.Add(',a.nascimento ');
   FQry.SQL.Add(',a.email ');
   FQry.SQL.Add(',a.telefone ');
   FQry.SQL.Add(',a.username ');
   FQry.SQL.Add('FROM public.usuarios a');
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

function TUsuariosDao.Usuarios(aId: integer; aModel: iUsuariosModel): iUsuariosDao;
var lQry: TSQLQuery;
begin
   Result := Self;
   if aId <= 0 then
      Raise Exception.Create('ID não foi informado !');

   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT * FROM public.usuarios ');
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

function TUsuariosDao.ValidarUsuario(aUsername: string; aPassword: string
  ): boolean;
begin
   FQry.Close;
   FQry.SQL.Clear;
   FQry.SQL.Add('SELECT ');
   FQry.SQL.Add(' a.senha ');
   FQry.SQL.Add(',a.nome ');
   FQry.SQL.Add(',a.username ');
   FQry.SQL.Add('FROM public.usuarios a');
   FQry.SQL.Add('WHERE a.username = :Username');
   FQry.SQL.Add('AND a.senha = :Password');
   FQry.ParamByName('Username').AsString := aUsername;
   FQry.ParamByName('Password').AsString := aPassword;
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

function TUsuariosDao.Delete(aId: integer): boolean;
var lQry: TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lQry.SQL.Add('DELETE FROM public.usuarios ');
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

function TUsuariosDao.Save(aModel: iUsuariosModel): boolean;
var lQry : TSQLQuery;
  lExist : Boolean;
begin
   if aModel = nil then
      Begin
         Raise Exception.Create('Usuário não informado !');
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
            lQry.SQL.Add('INSERT INTO sacristao.public.usuarios');
            lQry.SQL.Add('(senha, nome, nascimento, email, telefone, username)');
            lQry.SQL.Add('VALUES');
            lQry.SQL.Add('(:senha, :nome, :nascimento, :email, :telefone, :username)');
            lQry.SQL.Add('RETURNING id');
         end
      else
         Begin
            lQry.SQL.Add('UPDATE public.usuarios SET');
            lQry.SQL.Add(' senha = :senha');
            lQry.SQL.Add(',nome = :nome');
            lQry.SQL.Add(',nascimento = :nascimento');
            lQry.SQL.Add(',email = :email');
            lQry.SQL.Add(',telefone = :telefone');
            lQry.SQL.Add(',username = :username');
            lQry.SQL.Add('WHERE');
            lQry.SQL.Add('id = :id');
            lQry.ParamByName('id').AsInteger := aModel.Id;
         end;
      lQry.ParamByName('senha').AsString := aModel.Password;
      writeln(aModel.Password);
      lQry.ParamByName('nome').AsString := aModel.Nome;
      lQry.ParamByName('nascimento').AsDate := aModel.Nascimento;
      lQry.ParamByName('email').AsString := aModel.Email;
      lQry.ParamByName('telefone').AsString := aModel.Telefone;
      if aModel.Username <> '' then
         lQry.ParamByName('username').AsString := aModel.Username
      else
         lQry.ParamByName('username').AsString := aModel.Email;
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

function TUsuariosDao.ExistUsername(aModel: iUsuariosModel): boolean;
begin
   FQry.Close;
   FQry.SQL.Clear;
   FQry.SQL.Add('SELECT ');
   FQry.SQL.Add(' a.senha ');
   FQry.SQL.Add(',a.nome ');
   FQry.SQL.Add(',a.username ');
   FQry.SQL.Add('FROM public.usuarios a');
   FQry.SQL.Add('WHERE a.username = :Username');
   FQry.ParamByName('Username').AsString := aModel.Username;
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

