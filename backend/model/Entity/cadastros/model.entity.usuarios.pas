unit Model.Entity.Usuarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Model.Entity.Interfaces, BlowFish;

type

  { TUsuariosModel }

  TUsuariosModel = class(TInterfacedObject, iUsuariosModel)
    private
      Fid : integer;
      Fsenha : string;
      Fnome : string;
      Fnascimento : TDate;
      Ftelefone : string;
      Femail : string;
      Fusername : string;
      FPassword : string;
    private
      function EncryptString(aString:string):string;
      function DecryptString(aString:string):string;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iUsuariosModel;
      function Id: integer; overload;
      function Id(Value : integer): iUsuariosModel; overload;
      function Senha : string; overload;
      function Senha(Value : string): iUsuariosModel; overload;
      function Nome : string; overload;
      function Nome(Value : string): iUsuariosModel; overload;
      function Nascimento : TDate; overload;
      function Nascimento(Value : TDate): iUsuariosModel; overload;
      function Telefone : string; overload;
      function Telefone(Value : string): iUsuariosModel; overload;
      function Email : string; overload;
      function Email(Value : string): iUsuariosModel; overload;
      function Username : string; overload;
      function Username(Value : string): iUsuariosModel; overload;
      function Password : string;
  end;

implementation

const
  FPrivateKey : string = 'universal';
{ TUsuariosModel }

function TUsuariosModel.EncryptString(aString: string): string;
var EncrytpStream:TBlowFishEncryptStream;
    StringStream:TStringStream;
    EncryptedString:string;
begin
  StringStream := TStringStream.Create('',TEncoding.UTF8);
  EncrytpStream := TBlowFishEncryptStream.Create(FPrivateKey,StringStream);
  EncrytpStream.WriteAnsiString(aString);
  EncrytpStream.Free;
  EncryptedString := StringStream.DataString;
  StringStream.Free;
  EncryptString := EncryptedString;
end;

function TUsuariosModel.DecryptString(aString: string): string;
var DecrytpStream:TBlowFishDeCryptStream;
    StringStream:TStringStream;
    DecryptedString:string;
begin
  StringStream := TStringStream.Create(aString,TEncoding.UTF8);
  DecrytpStream := TBlowFishDeCryptStream.Create(FPrivateKey,StringStream);
  DecryptedString := DecrytpStream.ReadAnsiString;
  DecrytpStream.Free;
  StringStream.Free;
  DecryptString := DecryptedString;
end;

constructor TUsuariosModel.Create;
begin
  //
end;

destructor TUsuariosModel.Destroy;
begin
  inherited Destroy;
end;

class function TUsuariosModel.New: iUsuariosModel;
begin
   Result := Self.Create;
end;

function TUsuariosModel.Id: integer;
begin
   Result := Fid;
end;

function TUsuariosModel.Id(Value: integer): iUsuariosModel;
begin
   Result := Self;
   Fid := Value;
end;

function TUsuariosModel.Senha: string;
begin
   Result := Fsenha;
end;

function TUsuariosModel.Senha(Value: string): iUsuariosModel;
begin
   Result := Self;
   Fsenha := Value;
   FPassword := EncryptString(Fsenha);
end;

function TUsuariosModel.Nome: string;
begin
   Result := Fnome;
end;

function TUsuariosModel.Nome(Value: string): iUsuariosModel;
begin
   Result := Self;
   Fnome := Value;
end;

function TUsuariosModel.Nascimento: TDate;
begin
   Result := Fnascimento;
end;

function TUsuariosModel.Nascimento(Value: TDate): iUsuariosModel;
begin
   Result := Self;
   Fnascimento := Value;
end;

function TUsuariosModel.Telefone: string;
begin
   Result := Ftelefone;
end;

function TUsuariosModel.Telefone(Value: string): iUsuariosModel;
begin
   Result := Self;
   Ftelefone := Value;
end;

function TUsuariosModel.Email: string;
begin
   Result := Femail;
end;

function TUsuariosModel.Email(Value: string): iUsuariosModel;
begin
   Result := Self;
   Femail := Value;
end;

function TUsuariosModel.Username: string;
begin
   Result := Fusername;
end;

function TUsuariosModel.Username(Value: string): iUsuariosModel;
begin
   Result := Self;
   Fusername := Value;
end;

function TUsuariosModel.Password: string;
begin
  Result := FPassword;
end;

end.

