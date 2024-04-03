unit Model.Entity.Interfaces;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;
type
  iLocaisModel = interface
     ['{77792BE4-2D00-4EC3-B047-60807A432281}']
     function Id: integer; overload;
     function Id(Value : integer): iLocaisModel; overload;
     function Descricao : string; overload;
     function Descricao(Value : string): iLocaisModel; overload;
     function Endereco : string; overload;
     function Endereco(Value : string): iLocaisModel; overload;
  end;

  iUsuariosModel = interface
     ['{77792BE4-2D00-4EC3-B047-60807A432281}']
     function Id: integer; overload;
     function Id(Value : integer): iUsuariosModel; overload;
     function Senha : string; overload;
     function Senha(Value : string): iUsuariosModel; overload;
     function Nome : string; overload;
     function Nome(Value : string): iUsuariosModel; overload;
     function Nascimento : Tdate; overload;
     function Nascimento(Value : Tdate): iUsuariosModel; overload;
     function Email : string; overload;
     function Email(Value : string): iUsuariosModel; overload;
     function Telefone : string; overload;
     function Telefone(Value : string): iUsuariosModel; overload;
     function Username : string; overload;
     function Username(Value : string): iUsuariosModel; overload;
     function Password : string;
  end;

  iFuncoesModel = interface
     ['{252A398F-8206-48D7-8CCE-B05E7A2C98EF}']
     function Id: integer; overload;
     function Id(Value : integer): iFuncoesModel; overload;
     function Descricao : string; overload;
     function Descricao(Value : string): iFuncoesModel; overload;
  end;

  iHorariosModel = interface
     ['{B4D70211-8901-473B-89B1-F9AC9206CC4B}']
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

  iUsuariosFuncoesModel = interface
     ['{612EA99F-F89E-4712-888C-F37E724E3CC2}']
     function Id: integer; overload;
     function Id(Value : integer): iUsuariosFuncoesModel; overload;
     function Usuario_Id: integer; overload;
     function Usuario_Id(Value : integer): iUsuariosFuncoesModel; overload;
     function Funcao_Id: integer; overload;
     function Funcao_Id(Value : integer): iUsuariosFuncoesModel; overload;
  end;

  iUsuariosLocaisModel = interface
     ['{612EA99F-F89E-4712-888C-F37E724E3CC2}']
     function Id: integer; overload;
     function Id(Value : integer): iUsuariosLocaisModel; overload;
     function Usuario_Id: integer; overload;
     function Usuario_Id(Value : integer): iUsuariosLocaisModel; overload;
     function Local_Id: integer; overload;
     function Local_Id(Value : integer): iUsuariosLocaisModel; overload;
  end;
implementation

end.

