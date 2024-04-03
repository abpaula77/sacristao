unit Model.Entity.Horarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Model.Entity.Interfaces;

type

  { TFuncoesModel }

  { THorariosModel }

  THorariosModel = class(TInterfacedObject, iHorariosModel)
    private
      Fid : integer;
      Flocalid : integer;
      Fdescricao : string;
      Fhorainicio : string;
      Fsegunda : boolean;
      Fterca : boolean;
      Fquarta : boolean;
      Fquinta : boolean;
      Fsexta : boolean;
      Fsabado : boolean;
      Fdomingo : boolean;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: iHorariosModel;
      function Id: integer; overload;
      function Id(Value : integer): iHorariosModel; overload;
      function Local_Id: integer; overload;
      function Local_Id(Value : integer): iHorariosModel; overload;
      function Descricao : string; overload;
      function Descricao(Value : string): iHorariosModel; overload;
      function Hora_Inicio : string; overload;
      function Hora_Inicio(Value : string): iHorariosModel; overload;
      function Segunda : boolean; overload;
      function Segunda(Value : boolean): iHorariosModel; overload;
      function Terca : boolean; overload;
      function Terca(Value : boolean): iHorariosModel; overload;
      function Quarta : boolean; overload;
      function Quarta(Value : boolean): iHorariosModel; overload;
      function Quinta : boolean; overload;
      function Quinta(Value : boolean): iHorariosModel; overload;
      function Sexta : boolean; overload;
      function Sexta(Value : boolean): iHorariosModel; overload;
      function Sabado : boolean; overload;
      function Sabado(Value : boolean): iHorariosModel; overload;
      function Domingo : boolean; overload;
      function Domingo(Value : boolean): iHorariosModel; overload;
  end;

implementation

{ THorariosModel }

constructor THorariosModel.Create;
begin
  //
end;

destructor THorariosModel.Destroy;
begin
  inherited Destroy;
end;

class function THorariosModel.New: iHorariosModel;
begin
   Result := Self.Create;
end;

function THorariosModel.Id: integer;
begin
   Result := Fid;
end;

function THorariosModel.Id(Value: integer): iHorariosModel;
begin
   Result := Self;
   Fid := Value;
end;

function THorariosModel.Local_Id: integer;
begin
   Result := Flocalid;
end;

function THorariosModel.Local_Id(Value: integer): iHorariosModel;
begin
   Result := Self;
   Flocalid := Value;
end;

function THorariosModel.Descricao: string;
begin
   Result := Fdescricao;
end;

function THorariosModel.Descricao(Value: string): iHorariosModel;
begin
   Result := Self;
   Fdescricao := Value;
end;

function THorariosModel.Hora_Inicio: string;
begin
   Result := FHorainicio;
end;

function THorariosModel.Hora_Inicio(Value: string): iHorariosModel;
begin
   Result := Self;
   Fhorainicio := Value;
end;

function THorariosModel.Segunda: boolean;
begin
   Result := Fsegunda;
end;

function THorariosModel.Segunda(Value: boolean): iHorariosModel;
begin
   Result := Self;
   Fsegunda := Value;
end;

function THorariosModel.Terca: boolean;
begin
   Result := Fterca;
end;

function THorariosModel.Terca(Value: boolean): iHorariosModel;
begin
   Result := Self;
   Fterca := Value;
end;

function THorariosModel.Quarta: boolean;
begin
   Result := Fquarta;
end;

function THorariosModel.Quarta(Value: boolean): iHorariosModel;
begin
   Result := Self;
   Fquarta := Value;
end;

function THorariosModel.Quinta: boolean;
begin
   Result := Fquinta;
end;

function THorariosModel.Quinta(Value: boolean): iHorariosModel;
begin
   Result := Self;
   Fquinta := Value;
end;

function THorariosModel.Sexta: boolean;
begin
   Result := Fsexta;
end;

function THorariosModel.Sexta(Value: boolean): iHorariosModel;
begin
   Result := Self;
   Fsexta := Value;
end;

function THorariosModel.Sabado: boolean;
begin
   Result := Fsabado;
end;

function THorariosModel.Sabado(Value: boolean): iHorariosModel;
begin
   Result := Self;
   Fsabado := Value;
end;

function THorariosModel.Domingo: boolean;
begin
   Result := Fdomingo;
end;

function THorariosModel.Domingo(Value: boolean): iHorariosModel;
begin
   Result := Self;
   Fdomingo := Value;
end;

end.

