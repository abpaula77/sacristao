unit Model.Entity.Funcoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Model.Entity.Interfaces;

type

  { TFuncoesModel }

  TFuncoesModel = class(TInterfacedObject, iFuncoesModel)
    private
      Fid : integer;
      Fdescricao : string;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iFuncoesModel;
      function Id: integer; overload;
      function Id(Value : integer): iFuncoesModel; overload;
      function Descricao : string; overload;
      function Descricao(Value : string): iFuncoesModel; overload;
  end;

implementation

{ TFuncoesModel }

constructor TFuncoesModel.Create;
begin
  //
end;

destructor TFuncoesModel.Destroy;
begin
  inherited Destroy;
end;

class function TFuncoesModel.New: iFuncoesModel;
begin
   Result := Self.Create;
end;

function TFuncoesModel.Id: integer;
begin
   Result := Fid;
end;

function TFuncoesModel.Id(Value: integer): iFuncoesModel;
begin
   Result := Self;
   Fid := Value;
end;

function TFuncoesModel.Descricao: string;
begin
   Result := Fdescricao;
end;

function TFuncoesModel.Descricao(Value: string): iFuncoesModel;
begin
   Result := Self;
   Fdescricao := Value;
end;

end.

