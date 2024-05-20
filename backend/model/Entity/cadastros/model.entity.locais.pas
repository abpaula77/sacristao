unit Model.Entity.Locais;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Model.Entity.Interfaces;

type

  { TUsuariosModel }

  TLocaisModel = class(TInterfacedObject, iLocaisModel)
    private
      Fid : integer;
      Fdescricao : string;
      Fendereco : string;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iLocaisModel;
      function Id: integer; overload;
      function Id(Value : integer): iLocaisModel; overload;
      function Descricao : string; overload;
      function Descricao(Value : string): iLocaisModel; overload;
      function Endereco : string; overload;
      function Endereco(Value : string): iLocaisModel; overload;
  end;

implementation

{ TLocaisModel }

constructor TLocaisModel.Create;
begin
  //
end;

destructor TLocaisModel.Destroy;
begin
  inherited Destroy;
end;

class function TLocaisModel.New: iLocaisModel;
begin
   Result := Self.Create;
end;

function TLocaisModel.Id: integer;
begin
   Result := Fid;
end;

function TLocaisModel.Id(Value: integer): iLocaisModel;
begin
   Result := Self;
   Fid := Value;
end;

function TLocaisModel.Descricao: string;
begin
   Result := Fdescricao;
end;

function TLocaisModel.Descricao(Value: string): iLocaisModel;
begin
   Result := Self;
   Fdescricao := Value;
end;

function TLocaisModel.Endereco: string;
begin
   Result := Fendereco;
end;

function TLocaisModel.Endereco(Value: string): iLocaisModel;
begin
   Result := Self;
   Fendereco := Value;
end;


end.

