unit View.Cadastros.Locais;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Callback, memds,
  Controller.Entity.Interfaces, Controller.Entity.Locais,
  DataSet.Serialize, SQLDB, Horse.Jhonson,
  fpjson, DB, Horse.JWT;

procedure Locais;
procedure ListLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure AddLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure DelLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure Locais;
begin
  THorse
     .Use(Jhonson)
     .Get('/locais/listar', ListLocais)
     .Post('/locais', AddLocais)
     .Delete('/locais', DelLocais);
end;

procedure ListLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  FCtrl : iLocaisController;
  dtsLista: TDataSource;
  LBody: TJSONObject;
begin
  // Req.Body gives access to the content of the request in string format.
  // Using jhonson middleware, we can get the content of the request in JSON format.
  dtsLista := TDataSource.Create(nil);
  FCtrl:= TLocaisController.New(dtsLista);
  FCtrl.Locais(0);
  LBody := dtsLista.DataSet.ToJSONObject();
  Res.Send<TJSONObject>(LBody);
  dtsLista.Free;
end;

procedure AddLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iLocaisController;
  LBody: TJSONObject;
  MemTable : TMemDataset;
begin
  dtsLista := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := Req.Body<TJSONObject>;

  MemTable.LoadFromJSON(LBody);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= TLocaisController.New(dtsLista);
     if FCtrl.Save then
        Begin
           FCtrl.Locais(FCtrl.Id);
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

procedure DelLocais(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iLocaisController;
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
     FCtrl:= TLocaisController.New(dtsLista);
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

