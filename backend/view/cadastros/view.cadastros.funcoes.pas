unit View.Cadastros.Funcoes;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Callback, memds,
  Controller.Entity.Interfaces, Controller.Entity.Funcoes,
  DataSet.Serialize, SQLDB, Horse.Jhonson,
  fpjson, DB, Horse.JWT;

procedure Funcoes;
procedure ListFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure AddFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure DelFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure Funcoes;
begin
  THorse
     .Use(Jhonson)
     .Get('/funcoes/listar', ListFuncoes)
     .Post('/funcoes', AddFuncoes)
     .Delete('/funcoes', DelFuncoes);
end;

procedure ListFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  FCtrl : iFuncoesController;
  dtsLista: TDataSource;
  LBody: TJSONObject;
begin
  // Req.Body gives access to the content of the request in string format.
  // Using jhonson middleware, we can get the content of the request in JSON format.
  dtsLista := TDataSource.Create(nil);
  FCtrl:= TFuncoesController.New(dtsLista);
  FCtrl.Funcoes(0);
  LBody := dtsLista.DataSet.ToJSONObject();
  Res.Send<TJSONObject>(LBody);
  dtsLista.Free;
end;

procedure AddFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iFuncoesController;
  LBody: TJSONObject;
  MemTable : TMemDataset;
begin
  dtsLista := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := Req.Body<TJSONObject>;

  MemTable.LoadFromJSON(LBody);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= TFuncoesController.New(dtsLista);
     if FCtrl.Save then
        Begin
           FCtrl.Funcoes(FCtrl.Id);
           LBody := dtsLista.DataSet.ToJSONObject();
           Res.Send<TJSONObject>(LBody).Status(THTTPStatus.OK);
        end
     else
        Res.Send('Cadastro não realizado.').Status(THTTPStatus.ExpectationFailed);
  finally
  end;
  dtsLista.Free;
  MemTable.Free;
end;

procedure DelFuncoes(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iFuncoesController;
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
     FCtrl:= TFuncoesController.New(dtsLista);
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

