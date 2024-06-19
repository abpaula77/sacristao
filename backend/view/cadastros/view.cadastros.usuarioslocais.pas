unit View.Cadastros.UsuariosLocais;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Callback, memds,
  Controller.Entity.Interfaces, Controller.Entity.UsuariosLocais,
  Controller.Entity.Locais, Controller.Entity.Usuarios,
  DataSet.Serialize, SQLDB, Horse.Jhonson,
  fpjson, DB, Horse.JWT;

procedure UsuariosLocais;
procedure ListUsuariosLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure AddUsuariosLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure DelUsuariosLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure UsuariosLocais;
begin
  THorse
     .Use(Jhonson)
     .Get('/usuarioslocais/listar', ListUsuariosLocais)
     .Post('/usuarioslocais', AddUsuariosLocais)
     .Delete('/usuarioslocais', DelUsuariosLocais);
end;

procedure ListUsuariosLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  FCtrl : iUsuariosLocaisController;
  dtsLista: TDataSource;
  LBody: TJSONObject;
begin
  // Req.Body gives access to the content of the request in string format.
  // Using jhonson middleware, we can get the content of the request in JSON format.
  dtsLista := TDataSource.Create(nil);
  FCtrl:= TUsuariosLocaisController.New(dtsLista);
  FCtrl.UsuariosLocais(0);
  LBody := dtsLista.DataSet.ToJSONObject();
  Res.Send<TJSONObject>(LBody);
  dtsLista.Free;
end;

procedure AddUsuariosLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista,
  dtsLocais,
  dtsUsuarios: TDataSource;
  FCtrl : iUsuariosLocaisController;
  FCtrlLocais : iLocaisController;
  FCtrlUsuarios : iUsuariosController;
  LBody: TJSONObject;
  MemTable : TMemDataset;
begin
  dtsLista := TDataSource.Create(nil);
  dtsLocais := TDataSource.Create(nil);
  dtsUsuarios := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := Req.Body<TJSONObject>;

  MemTable.LoadFromJSON(LBody,False);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= TUsuariosLocaisController.New(dtsLista);
     FCtrlLocais:= TLocaisController.New(dtsLocais);
     FCtrlUsuarios:= TUsuariosController.New(dtsUsuarios);
     if MemTable.FieldByName('localid').AsInteger > 0 then
        if MemTable.FieldByName('usuarioid').AsInteger > 0 then
           Begin
              FCtrlLocais.Locais(MemTable.FieldByName('localid').AsInteger);
              FCtrlUsuarios.Usuarios(MemTable.FieldByName('usuarioid').AsInteger);
              if dtsLocais.DataSet.RecordCount <= 0 then
                Res.Send('Local inexistente.').Status(THTTPStatus.ExpectationFailed)
              else
                if dtsUsuarios.DataSet.RecordCount <= 0 then
                  Res.Send('Usuário inexistente.').Status(THTTPStatus.ExpectationFailed)
                else
                  if not FCtrl.ValidarUsuariosLocais(MemTable.FieldByName('usuarioid').AsInteger,MemTable.FieldByName('localid').AsInteger) then
                     if FCtrl.Save then
                        Begin
                           FCtrl.UsuariosLocais(FCtrl.Id);
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
        Res.Send('Local inexistente.').Status(THTTPStatus.ExpectationFailed);
  finally
  end;
  dtsLista.Free;
  dtsLocais.Free;
  dtsUsuarios.Free;
  MemTable.Free;
end;

procedure DelUsuariosLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iUsuariosLocaisController;
  LBody: TJSONObject;
  SBody: String;
  MemTable : TMemDataset;
begin
  dtsLista := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := TJSONObject.Create;
  SBody := Req.Body;
  LBody := GetJSON(SBody) as TJSONObject;
  MemTable.LoadFromJSON(LBody,False);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= TUsuariosLocaisController.New(dtsLista);
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

