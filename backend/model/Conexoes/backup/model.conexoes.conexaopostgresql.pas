unit Model.Conexoes.ConexaoPostgreSQL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, PQConnection, SQLDB;

type

   { TModelConexaoPostgreeSQL }

   { TModelConexaoPostgreSQL }

   TModelConexaoPostgreSQL = class(TInterfacedObject)
     private
       class var FDBInstance: TModelConexaoPostgreSQL;
       FConexao: TPQConnection;
       FTransacao : TSQLTransaction;
       FDatabase: String;
       FUserName: String;
       FPassword: String;
       FDriverID: String;
       FServer: String;
       FPorta: Integer;
       procedure LerParametros;
     public
       constructor Create;
       destructor Destroy;
       class function getInstance: TModelConexaoPostgreSQL;

   end;

implementation

{ TModelConexaoPostgreeSQL }

procedure TModelConexaoPostgreSQL.LerParametros;
begin
  FConexao.Params.Database := 'piauniao'; //FDatabase;
  FConexao.Params.UserName := 'piauniao'; //FUserName;
  FConexao.Params.Password := 'PostSacrist@0';
  FConexao.Params.Add('Server=' + 'pgsql.piauniao.com.br'); //FServer);
  FConexao.Params.Add('Port=' + IntToStr(5432));
end;

constructor TModelConexaoPostgreSQL.Create;
begin
  FTransacao := TSQLTransaction.Create(nil);
  FConexao := TPQConnection.Create(nil);
  FConexao.tr
  LerParametros;
end;

destructor TModelConexaoPostgreSQL.Destroy;
begin
  FreeAndNil(FConexao);
  FDBInstance.Free;
end;

class function TModelConexaoPostgreSQL.getInstance: TModelConexaoPostgreSQL;
begin
  if not Assigned(FDBInstance) then
     FDBInstance := TModelConexaoPostgreSQL.Create;
  Result := FDBInstance;
end;

end.

