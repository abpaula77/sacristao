unit Dao.Entity.Interfaces;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Model.Entity.Interfaces;

type
  iLocaisDao = interface
     ['{82FDB325-800B-45F9-BBB3-8713E48F2B1C}']
     function Locais(aId : integer) : TDataSet; overload;
     function Locais(aId : integer;aModel : iLocaisModel) : iLocaisDao; overload;
     function Delete(aId : integer): boolean;
     function Save(aModel : iLocaisModel): boolean;
  end;

  iUsuariosDao = interface
     ['{4063CE3E-BAD6-42B5-A4F0-8F2A7253D5AC}']
     function Usuarios(aId : integer) : TDataSet; overload;
     function Usuarios(aId : integer;aModel : iUsuariosModel) : iUsuariosDao; overload;
     function Delete(aId : integer): boolean;
     function Save(aModel : iUsuariosModel): boolean;
     function ValidarUsuario(aUsername: string; aPassword: string): boolean;
     function ExistUsername(aModel : iUsuariosModel): boolean;
  end;

  iFuncoesDao = interface
     ['{1CB53C68-DE98-4FB7-B5EB-707E53E949BB}']
     function Funcoes(aId : integer) : TDataSet; overload;
     function Funcoes(aId : integer;aModel : iFuncoesModel) : iFuncoesDao; overload;
     function Delete(aId : integer): boolean;
     function Save(aModel : iFuncoesModel): boolean;
  end;

  iHorariosDao = interface
     ['{354943CC-D904-4147-A43B-B31577624943}']
     function Horarios(aId : integer) : TDataSet; overload;
     function Horarios(aId : integer;aModel : iHorariosModel) : iHorariosDao; overload;
     function Delete(aId : integer): boolean;
     function Save(aModel : iHorariosModel): boolean;
  end;

  iUsuariosFuncoesDao = interface
     ['{8DF6ACDB-9283-4072-9F7B-316E4E2B241C}']
     function UsuariosFuncoes(aId : integer) : TDataSet; overload;
     function UsuariosFuncoes(aId : integer;aModel : iUsuariosFuncoesModel) : iUsuariosFuncoesDao; overload;
     function Delete(aId : integer): boolean;
     function Save(aModel : iUsuariosFuncoesModel): boolean;
     function ValidarUsuariosFuncoes(aUsuario: integer; aFuncao: integer): boolean;
  end;

  iUsuariosLocaisDao = interface
     ['{2D73F6B0-EE26-45C4-9065-D6A769788095}']
     function UsuariosLocais(aId : integer) : TDataSet; overload;
     function UsuariosLocais(aId : integer;aModel : iUsuariosLocaisModel) : iUsuariosLocaisDao; overload;
     function Delete(aId : integer): boolean;
     function Save(aModel : iUsuariosLocaisModel): boolean;
     function ValidarUsuariosLocais(aUsuario: integer; aLocal: integer): boolean;
  end;
implementation

end.

