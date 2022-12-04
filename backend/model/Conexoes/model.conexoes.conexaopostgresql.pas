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
       function Conexao: TPQConnection;
       class function getInstance: TModelConexaoPostgreSQL;

   end;

implementation

{ TModelConexaoPostgreeSQL }

procedure TModelConexaoPostgreSQL.LerParametros;
begin
  FConexao.DatabaseName := 'piauniao'; //FDatabase;
  FConexao.UserName := 'piauniao'; //FUserName;
  FConexao.Password := 'PostSacrist@0';
  FConexao.HostName:='pgsql.piauniao.com.br';
end;

constructor TModelConexaoPostgreSQL.Create;
begin
  FTransacao := TSQLTransaction.Create(nil);
  FConexao := TPQConnection.Create(nil);
  FConexao.Transaction := FTransacao;
  LerParametros;
end;

destructor TModelConexaoPostgreSQL.Destroy;
begin
  FreeAndNil(FConexao);
  FDBInstance.Free;
end;

function TModelConexaoPostgreSQL.Conexao: TPQConnection;
begin
  result := FConexao;
end;

class function TModelConexaoPostgreSQL.getInstance: TModelConexaoPostgreSQL;
begin
  if not Assigned(FDBInstance) then
     FDBInstance := TModelConexaoPostgreSQL.Create;
  Result := FDBInstance;
end;

end.

