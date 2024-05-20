unit Model.Conexoes.ConexaoPostgreSQL;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, PQConnection, SQLDB, DataSet.Serialize,
  fpjson, lcl;

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
       function LoadJSON(FileName: string): TJSONData;
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
var Caminho : string;
    Conteudo: TJSONData;
    JSONArquivo : TJSONObject;
begin
   Caminho := GetCurrentDir + '\sacristao.json';
   if FileExists(Caminho) then
      Begin
        Conteudo := LoadJSON(Caminho);
        if Conteudo.FindPath('piauniao') <> nil then
           Begin
              FDatabase := Conteudo.FindPath('piauniao').FindPath('database').AsString;
              FUserName := Conteudo.FindPath('piauniao').FindPath('username').AsString;
              FPassword := Conteudo.FindPath('piauniao').FindPath('password').AsString;
              FServer := Conteudo.FindPath('piauniao').FindPath('hostname').AsString;
           end;
      end
   else
      Begin
        FDatabase:='';
        FUserName:='';
        FPassword:='';
        FServer:='';
      end;
end;

function TModelConexaoPostgreSQL.LoadJSON(FileName: string): TJSONData;
var
  JsonData: TJSONData;
  Strm: TFileStream;
  fFileData: string;
  SizeOfFile: int64;
begin
   Strm := TFileStream.Create(FileName, fmOpenRead);
   SizeOfFile := Strm.Size;
   SetLength(fFileData, SizeOfFile);
   Strm.Read(fFileData[1], SizeOfFile);
   JsonData := GetJSON(fFileData);
   result := JsonData;//.FormatJSON;
   Strm.Free;
end;

constructor TModelConexaoPostgreSQL.Create;
begin
  FTransacao := TSQLTransaction.Create(nil);
  FConexao := TPQConnection.Create(nil);
  FConexao.CharSet := 'utf8';
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

