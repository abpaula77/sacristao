unit Model.Conexoes.ConexaoPostgreSQL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, PQConnection, SQLDB, JsonTools, Forms;

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
       procedure CarregarParametros;
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
  FConexao.DatabaseName := FDatabase;
  FConexao.UserName := FUserName;
  FConexao.Password := FPassword;
  FConexao.HostName:=FServer;
end;

procedure TModelConexaoPostgreSQL.CarregarParametros;
var Caminho: string;
    ArquivoJson: TJsonNode;
    posicao : integer;
begin
   Caminho := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName)) + 'sacristao.json';
   if FileExists(Caminho) then
      Begin
        ArquivoJson := TJsonNode.Create;
        ArquivoJson.LoadFromFile(Caminho);
        FDatabase:=ArquivoJson.Find('piauniao/database').AsString;
        FUserName:=ArquivoJson.Find('piauniao/username').AsString;
        FPassword:=ArquivoJson.Find('piauniao/password').AsString;
        FServer:=ArquivoJson.Find('piauniao/hostname').AsString;
      end
   else
      Begin
        FDatabase:='';
        FUserName:='';
        FPassword:='';
        FServer:='';
      end;
end;

constructor TModelConexaoPostgreSQL.Create;
begin
  FTransacao := TSQLTransaction.Create(nil);
  FConexao := TPQConnection.Create(nil);
  FConexao.Transaction := FTransacao;
  CarregarParametros;
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

