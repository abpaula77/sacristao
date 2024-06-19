program apirest;
{$MODE DELPHI}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Horse,
  Horse.Jhonson, // It's necessary to use the unit
  Horse.BasicAuthentication, // It's necessary to use the unit
  Horse.Compression, // It's necessary to use the unit
  Horse.HandleException, // It's necessary to use the unit
  Horse.OctetStream, // It's necessary to use the unit
  Horse.Logger, // It's necessary to use the unit
  Horse.Logger.Provider.LogFile, // It's necessary to use the unit
  Horse.Paginate,
  Horse.ETag,
  Horse.JWT,
  fpjson,
  Controller.Entity.Interfaces,
  Controller.Entity.Locais,
  Controller.Entity.Funcoes,
  DataSet.Serialize,
  SQLDB,
  DB,
  memds,
  SysUtils,
  Classes,
  view.cadastros.funcoes,
  view.cadastros.Locais,
  View.Cadastros.Horarios,
  View.Utils.Login,
  View.Cadastros.UsuariosFuncoes,
  View.Cadastros.UsuariosLocais,
  View.Cadastros.Usuarios;

procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LBody: TJSONObject;
begin
  // Req.Body gives access to the content of the request in string format.
  // Using jhonson middleware, we can get the content of the request in JSON format.
  LBody := Req.Body<TJSONObject>;
  Res.Send<TJSONObject>(LBody);
  //raise EHorseException.New.Error('My Error!');
end;

procedure GetStream(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LStream: TFileStream;
begin
  // Now you can send your stream:
  LStream := TFileStream.Create(ExtractFilePath(ParamStr(0)) + '748.jpg', fmOpenRead);
  Res.Send<TStream>(LStream).ContentType('application/jpg');
end;

procedure PostStream(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LStream: TMemoryStream;
begin
  // Now you can send your stream:
  // Para dar certo o Content-Type no envio precisa estar como application/octet-stream
  LStream := Req.Body<TMemoryStream>;
  LStream.SaveToFile(ExtractFilePath(ParamStr(0)) + 'banco.jpg');
  Res.Send('Upload OK').Status(201);
end;

procedure GetItems(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LDataSet: TMemDataset;
begin
        LDataSet := TMemDataset.Create(nil);
        try
          LDataSet.LoadFromFile('items.xml');
          Res.Send<TJsonArray>(LDataSet.ToJsonArray);
        finally
          LDataSet.Free;
        end;
end;

procedure GetUsers(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LContent: TJSONObject;
begin
  LContent := TJSONObject.Create;
  LContent.Add('login', 'kaue');
  Res.Send<TJsonData>(LContent);
end;

function DoLogin(const AUsername, APassword: string): Boolean;
begin
  // Here inside you can access your database and validate if username and password are valid
  Result := AUsername.Equals('kaue') and APassword.Equals('123');
end;

procedure GetLogin(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LContent: TJSONObject;
begin
  LContent := TJSONObject.Create;
  LContent.Add('login', 'kaue');
  Res.Send<TJsonData>(LContent);
end;

procedure OnListen;
begin
  if THorse.IsRunning then
    Writeln(Format('Server is runing on %s:%d', [THorse.Host, THorse.Port]));
  if not THorse.IsRunning then
    Writeln('Server stopped');
end;

begin
  THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogFile.New());
  // It's necessary to add the middleware in the Horse:
  THorse
     .Use(Compression()) // Must come before Jhonson middleware
     //.Use(HorseBasicAuthentication(DoLogin))
     .Use(Paginate)
     .Use(Jhonson('UTF-8'))
     .Use(ETag)
     .Use(OctetStream)
     .Use(THorseLoggerManager.HorseCallback)
     .Use(HandleException)
     .Use(HorseJWT('catedral', THorseJWTConfig.New.SkipRoutes(['ping','login','usuarios'])));
  // You can specify the charset when adding middleware to the Horse:
  // THorse.Use(Jhonson('UTF-8'));
  //THorse.Get('/items', GetItems);
  //THorse.Get('/stream', GetStream);
  //THorse.Post('/stream', PostStream);
  //THorse.Get('/users', GetUsers);

  THorse.Get('/ping', GetPing);


  View.Utils.Login.Login;
  View.Cadastros.Locais.Locais;
  View.Cadastros.Usuarios.Usuarios;
  View.Cadastros.Funcoes.Funcoes;
  View.Cadastros.Horarios.Horarios;
  View.Cadastros.UsuariosFuncoes.UsuariosFuncoes;
  View.Cadastros.UsuariosLocais.UsuariosLocais;

  THorse.Listen(9876, @OnListen);
end.
