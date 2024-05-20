unit View.Cadastros.Usuarios;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Callback, memds,
  Controller.Entity.Interfaces, Controller.Entity.Usuarios,
  DataSet.Serialize, SQLDB, Horse.Jhonson,
  fpjson, DB, Horse.JWT;

procedure Usuarios;
procedure ListUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure AddUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure DelUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure Usuarios;
begin
  THorse
     .Use(Jhonson)
     .Get('/usuarios/listar', ListUsuarios)
     .Delete('/usuarios', DelUsuarios);
  THorse.Post('/usuarios', AddUsuarios);
end;

procedure ListUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  FCtrl : iUsuariosController;
  dtsLista: TDataSource;
  LBody: TJSONObject;
begin
  // Req.Body gives access to the content of the request in string format.
  // Using jhonson middleware, we can get the content of the request in JSON format.
  dtsLista := TDataSource.Create(nil);
  FCtrl:= TUsuariosController.New(dtsLista);
  FCtrl.Usuarios(0);
  LBody := dtsLista.DataSet.ToJSONObject();
  Res.Send<TJSONObject>(LBody);
  dtsLista.Free;
end;

procedure AddUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iUsuariosController;
  LBody,
  LResposta: TJSONObject;
  MemTable : TMemDataset;
begin
  dtsLista := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := Req.Body<TJSONObject>;
  LResposta := TJSONObject.Create;

  MemTable.LoadFromJSON(LBody);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= TUsuariosController.New(dtsLista);
     if not FCtrl.ExistUsername then
       if FCtrl.ValidarPassword then
         Begin
           if FCtrl.Save then
              Begin
                 LResposta.Add('Status', 'Registro incluído com sucesso');
                 Res.Send<TJSONObject>(LResposta).Status(THTTPStatus.OK);
              end
           else
              Res.Send('Cadastro não realizado.').Status(THTTPStatus.ExpectationFailed)
         end
       else
         Res.Send('Tamanho de senha inválido.').Status(THTTPStatus.ExpectationFailed)
     else
       Res.Send('Username inválido ou já cadastrado.').Status(THTTPStatus.ExpectationFailed);
  finally
  end;
  dtsLista.Free;
  MemTable.Free;
end;

procedure DelUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iUsuariosController;
  LBody: TJSONObject;
  SBody: String;
  MemTable : TMemDataset;
begin
  dtsLista := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := TJSONObject.Create;
  SBody := Req.Body;
  LBody := GetJSON(SBody) as TJSONObject;
  writeln(LBody.AsJSON);
  MemTable.LoadFromJSON(LBody);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= TUsuariosController.New(dtsLista);
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

