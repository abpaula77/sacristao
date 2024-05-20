unit View.Utils.Login;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Horse, Horse.Callback, memds,
  Controller.Entity.Interfaces, Controller.Entity.Locais,
  DataSet.Serialize, SQLDB, Horse.Jhonson, Controller.Entity.Usuarios,
  fpjson, DB, Horse.JWT, LazJWT, DateUtils;

procedure Login;
procedure GetLogin(Req: THorseRequest; Res: THorseResponse);

implementation

procedure Login;
begin
  THorse
     .Use(Jhonson);
  THorse.Post('/login', GetLogin);
end;

procedure GetLogin(Req: THorseRequest; Res: THorseResponse);
var
  LBody: TJSONObject;
  AUsername,
  APassword,
  AToken: String;
  JSONToken : TJSONObject;
  FCtrl : iUsuariosController;
begin
  LBody := Req.Body<TJSONObject>;
  AUsername := LBody.Find('usuario').Value;
  APassword := LBody.Find('password').Value;
  FCtrl:= TUsuariosController.New;
  // Here inside you can access your database and validate if username and password are valid
  if FCtrl.ValidarUsuario(AUsername,APassword) then
      Begin
         AToken := TLazJWT.New
                      .SecretJWT('catedral')
                         .Exp(DateTimeToUnix(IncHour(Now,1)))
                            .AddClaim('username',AUsername)
                               .AddClaim('password',APassword)
                                  .Token;
         JSONToken := TJSONObject.Create(['token',AToken]);
         Res.Send<TJSONObject>(JSONToken).Status(THTTPStatus.Accepted);
      end
  else
     Res.Send('Usuário ou senha não cadastrado.').Status(THTTPStatus.Unauthorized);
end;


end.

