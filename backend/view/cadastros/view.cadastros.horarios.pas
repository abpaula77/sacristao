unit View.Cadastros.Horarios;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Callback, memds,
  Controller.Entity.Interfaces, Controller.Entity.Locais,
  Controller.Entity.Horarios,
  DataSet.Serialize, SQLDB, Horse.Jhonson,
  fpjson, DB, Horse.JWT;

procedure Horarios;
procedure ListHorarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure AddHorarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
procedure DelHorarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);

implementation

procedure Horarios;
begin
  THorse
     .Use(Jhonson)
     .Get('/horarios/listar', ListHorarios)
     .Post('/horarios', AddHorarios)
     .Delete('/horarios', DelHorarios);
end;

procedure ListHorarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  FCtrl : iHorariosController;
  dtsLista: TDataSource;
  LBody: TJSONObject;
begin
  // Req.Body gives access to the content of the request in string format.
  // Using jhonson middleware, we can get the content of the request in JSON format.
  dtsLista := TDataSource.Create(nil);
  FCtrl:= THorariosController.New(dtsLista);
  FCtrl.Horarios(0);
  LBody := dtsLista.DataSet.ToJSONObject();
  Res.Send<TJSONObject>(LBody);
  dtsLista.Free;
end;

procedure AddHorarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iHorariosController;
  LBody: TJSONObject;
  MemTable : TMemDataset;
  FCtrlLocais : iLocaisController;
  dtsLocais: TDataSource;
begin
  dtsLocais := TDataSource.Create(nil);
  FCtrlLocais:= TLocaisController.New(dtsLocais);
  dtsLista := TDataSource.Create(nil);
  MemTable := TMemDataset.Create(nil);
  LBody := Req.Body<TJSONObject>;

  MemTable.LoadFromJSON(LBody,False);
  dtsLista.DataSet := MemTable;
  try
     FCtrl:= THorariosController.New(dtsLista);
     if MemTable.FieldByName('localid').AsInteger > 0 then
        Begin
           FCtrlLocais.Locais(MemTable.FieldByName('localid').AsInteger);
           if dtsLocais.DataSet.RecordCount <= 0 then
             Res.Send('Local inexistente.').Status(THTTPStatus.ExpectationFailed)
           else
           if FCtrl.Save then
              Begin
                 FCtrl.Horarios(FCtrl.Id);
                 LBody := dtsLista.DataSet.ToJSONObject();
                 Res.Send<TJSONObject>(LBody).Status(THTTPStatus.OK);
              end
           else
              Res.Send('Cadastro não realizado.').Status(THTTPStatus.ExpectationFailed);
        end
     else
        Res.Send('Local inexistente.').Status(THTTPStatus.ExpectationFailed);
  finally
  end;
  dtsLista.Free;
  dtsLocais.Free;
  MemTable.Free;
end;

procedure DelHorarios(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  dtsLista: TDataSource;
  FCtrl : iHorariosController;
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
     FCtrl:= THorariosController.New(dtsLista);
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

