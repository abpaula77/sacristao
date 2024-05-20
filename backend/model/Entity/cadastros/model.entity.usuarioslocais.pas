unit Model.Entity.UsuariosLocais;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Model.Entity.Interfaces;

type

  { TUsuariosLocaisModel }

  TUsuariosLocaisModel = class(TInterfacedObject, iUsuariosLocaisModel)
    private
      Fid : integer;
      Fusuarioid : integer;
      Flocalid : integer;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iUsuariosLocaisModel;
      function Id: integer; overload;
      function Id(Value : integer): iUsuariosLocaisModel; overload;
      function Usuario_Id: integer; overload;
      function Usuario_Id(Value : integer): iUsuariosLocaisModel; overload;
      function Local_Id: integer; overload;
      function Local_Id(Value : integer): iUsuariosLocaisModel; overload;
  end;

implementation

{ TUsuariosLocaisModel }

constructor TUsuariosLocaisModel.Create;
begin
  //
end;

destructor TUsuariosLocaisModel.Destroy;
begin
  inherited Destroy;
end;

class function TUsuariosLocaisModel.New: iUsuariosLocaisModel;
begin
   Result := Self.Create;
end;

function TUsuariosLocaisModel.Id: integer;
begin
   Result := Fid;
end;

function TUsuariosLocaisModel.Id(Value: integer): iUsuariosLocaisModel;
begin
   Result := Self;
   Fid := Value;
end;

function TUsuariosLocaisModel.Usuario_Id: integer;
begin
   Result := Fusuarioid;
end;

function TUsuariosLocaisModel.Usuario_Id(Value: integer
  ): iUsuariosLocaisModel;
begin
   Result := Self;
   Fusuarioid := Value;
end;

function TUsuariosLocaisModel.Local_Id: integer;
begin
   Result := Flocalid;
end;

function TUsuariosLocaisModel.Local_Id(Value: integer): iUsuariosLocaisModel;
begin
   Result := Self;
   Flocalid := Value;
end;

end.

