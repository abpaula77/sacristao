unit Model.Entity.UsuariosFuncoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Model.Entity.Interfaces;

type

  { TUsuariosFuncoesModel }

  TUsuariosFuncoesModel = class(TInterfacedObject, iUsuariosFuncoesModel)
    private
      Fid : integer;
      Fusuarioid : integer;
      Ffuncaoid : integer;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iUsuariosFuncoesModel;
      function Id: integer; overload;
      function Id(Value : integer): iUsuariosFuncoesModel; overload;
      function Usuario_Id: integer; overload;
      function Usuario_Id(Value : integer): iUsuariosFuncoesModel; overload;
      function Funcao_Id: integer; overload;
      function Funcao_Id(Value : integer): iUsuariosFuncoesModel; overload;
  end;

implementation

{ TUsuariosFuncoesModel }

constructor TUsuariosFuncoesModel.Create;
begin
  //
end;

destructor TUsuariosFuncoesModel.Destroy;
begin
  inherited Destroy;
end;

class function TUsuariosFuncoesModel.New: iUsuariosFuncoesModel;
begin
   Result := Self.Create;
end;

function TUsuariosFuncoesModel.Id: integer;
begin
   Result := Fid;
end;

function TUsuariosFuncoesModel.Id(Value: integer): iUsuariosFuncoesModel;
begin
   Result := Self;
   Fid := Value;
end;

function TUsuariosFuncoesModel.Usuario_Id: integer;
begin
   Result := Fusuarioid;
end;

function TUsuariosFuncoesModel.Usuario_Id(Value: integer
  ): iUsuariosFuncoesModel;
begin
   Result := Self;
   Fusuarioid := Value;
end;

function TUsuariosFuncoesModel.Funcao_Id: integer;
begin
   Result := Ffuncaoid;
end;

function TUsuariosFuncoesModel.Funcao_Id(Value: integer): iUsuariosFuncoesModel;
begin
   Result := Self;
   Ffuncaoid := Value;
end;

end.

