unit View.Cadastros.UsuariosFuncoes;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Callback, memds,
  Controller.Entity.Interfaces, Controller.Entity.UsuariosFuncoes,
  Controller.Entity.Funcoes, Controller.Entity.Usuarios,
  DataSet.Serialize, SQLDB, Horse.Jhonson,
  fpjson, DB, Horse.JWT;

procedure UsuariosFuncoes;
procedure ListUsuariosFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure AddUsuariosFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure DelUsuariosFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure UsuariosFuncoes;
begin
  THorse
     .Use(Jhonson)
     .Get('/usuariosfuncoes/listar', ListUsuariosFuncoes)
     .Post('/usuariosfuncoes', AddUsuariosFuncoes)
     .Delete('/usuariosfuncoes', DelUsuariosFuncoes);
end;

procedure ListUsuariosFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  FCtrl : iUsuariosFuncoesController;
  dtsLista: TDataSource;
  LBody: TJSONObject;
begin
  // Req.Body gives access to the content of the request in string format.
  // Using jhonson middleware, we can get the content of the request in JSON format.
  dtsLista := TDataSource.Create(nil);
  FCtrl:= TUsuariosFuncoesController.New(dtsLista);
  FCtrl.UsuariosFuncoes(0);
  LBody := dtsLista.DataSet.ToJSONObject();
  Res.Send<TJSONObject>(LBody);
  dtsLista.Free;
end;

procedure AddUsuariosFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista,
  dtsFuncoes,
  dtsUsuarios: TDataSource;
  FCtrl : iUsuariosFuncoesController;
  FCtrlFuncoes : iFuncoesController;
  FCtrlUsuarios : iUsuariosController;
  LBody: TJSONObject;
  MemTable : TMemDataset;
begin
  dtsLista := TDataSource.Create(nil);
  dtsFuncoes := TDataSource.Create(nil);
  dtsUsuarios := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := Req.Body<TJSONObject>;

  MemTable.LoadFromJSON(LBody);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= TUsuariosFuncoesController.New(dtsLista);
     FCtrlFuncoes:= TFuncoesController.New(dtsFuncoes);
     FCtrlUsuarios:= TUsuariosController.New(dtsUsuarios);
     if MemTable.FieldByName('funcaoid').AsInteger > 0 then
        if MemTable.FieldByName('usuarioid').AsInteger > 0 then
           Begin
              FCtrlFuncoes.Funcoes(MemTable.FieldByName('funcaoid').AsInteger);
              FCtrlUsuarios.Usuarios(MemTable.FieldByName('usuarioid').AsInteger);
              if dtsFuncoes.DataSet.RecordCount <= 0 then
                Res.Send('Função inexistente.').Status(THTTPStatus.ExpectationFailed)
              else
                if dtsUsuarios.DataSet.RecordCount <= 0 then
                  Res.Send('Usuário inexistente.').Status(THTTPStatus.ExpectationFailed)
                else
                  if not FCtrl.ValidarUsuariosFuncoes(MemTable.FieldByName('usuarioid').AsInteger,MemTable.FieldByName('funcaoid').AsInteger) then
                     if FCtrl.Save then
                        Begin
                           FCtrl.UsuariosFuncoes(FCtrl.Id);
                           LBody := dtsLista.DataSet.ToJSONObject();
                           Res.Send<TJSONObject>(LBody).Status(THTTPStatus.OK);
                        end
                     else
                        Res.Send('Cadastro não realizado.').Status(THTTPStatus.ExpectationFailed)
                  else
                    Res.Send('Registro já cadastrado.').Status(THTTPStatus.ExpectationFailed);
           end
       else
          Res.Send('Usuário inexistente.').Status(THTTPStatus.ExpectationFailed)
     else
        Res.Send('Função inexistente.').Status(THTTPStatus.ExpectationFailed);
  finally
  end;
  dtsLista.Free;
  dtsFuncoes.Free;
  dtsUsuarios.Free;
  MemTable.Free;
end;

procedure DelUsuariosFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iUsuariosFuncoesController;
  LBody: TJSONObject;
  SBody: String;
  MemTable : TMemDataset;
begin
  dtsLista := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := TJSONObject.Create;
  SBody := Req.Body;
  LBody := GetJSON(SBody) as TJSONObject;
  MemTable.LoadFromJSON(LBody);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= TUsuariosFuncoesController.New(dtsLista);
     if FCtrl.Delete then
        Begin
           SBody := '{"Status":"Registro excluido com sucesso"}';
           LBody := GetJSON(SBody) as TJSONObject;
           Res.Send<TJSONObject>(LBody).Status(THTTPStatus.OK);
        end
     else
        Res.Send('Cadastro não realizado.').Status(THTTPStatus.ExpectationFailed);
  finally
  end;
  dtsLista.Free;
  MemTable.Free;
end;



end.

