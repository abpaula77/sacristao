unit Controller.Entity.Interfaces;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  iLocaisController = interface
  ['{CED01921-B243-49ED-8694-57B975361BF1}']
    function Locais(aId: integer): iLocaisController;
    function Locais: iLocaisController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
  end;

  iUsuariosController = interface
  ['{8D8D9D54-38D7-4465-A417-C49324AB80D8}']
    function Usuarios(aId: integer): iUsuariosController;
    function Usuarios: iUsuariosController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
    function ValidarUsuario(aUsername: string; aPassword: string): boolean;
    function ExistUsername: Boolean;
    function ValidarPassword: Boolean;
  end;

  iFuncoesController = interface
  ['{70A63864-F17F-4DE1-9103-DCC7903F5C33}']
    function Funcoes(aId: integer): iFuncoesController;
    function Funcoes: iFuncoesController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
  end;

  iHorariosController = interface
  ['{FBDDD711-429D-4377-B2B5-6518CF442972}']
    function Horarios(aId: integer): iHorariosController;
    function Horarios: iHorariosController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
  end;

  iUsuariosFuncoesController = interface
  ['{7D0E9BC6-67BA-4944-8235-2F2DB55C33DF}']
    function UsuariosFuncoes(aId: integer): iUsuariosFuncoesController;
    function UsuariosFuncoes: iUsuariosFuncoesController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
  end;

  iUsuariosLocaisController = interface
  ['{5E0D1C15-A958-4963-B2B3-2981E143343E}']
    function UsuariosLocais(aId: integer): iUsuariosLocaisController;
    function UsuariosLocais: iUsuariosLocaisController;
    function Delete: Boolean;
    function Save: Boolean;
    function Id: integer;
  end;
implementation

end.

