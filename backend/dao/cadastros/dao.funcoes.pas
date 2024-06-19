unit Dao.Funcoes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Model.Conexoes.ConexaoPostgreSQL, Dao.Entity.Interfaces,
  Model.Entity.Interfaces, DB;
type

  { TFuncoesDao }

  TFuncoesDao = class(TInterfacedObject, iFuncoesDao)
    private
       FSQL : TStringList;
       FQry : TSQLQuery;
       function Exist(aId : integer): boolean;
       procedure Bind(aDataSet : TDataSet; aModel: iFuncoesModel);
    public
       constructor Create;
       destructor Destroy; override;
       class function New: iFuncoesDao;
       function Funcoes(aId : integer) : TDataSet; overload;
       function Funcoes(aId : integer;aModel : iFuncoesModel) : iFuncoesDao; overload;
       function Delete(aId : integer): boolean;
       function Save(aModel : iFuncoesModel): boolean;
  end;

implementation

{ TFuncoesDao }

function TFuncoesDao.Exist(aId: integer): boolean;
var lQry : TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT ');
      lQry.SQL.Add(' a.id ');
      lQry.SQL.Add('FROM public.funcoes a');
      lQry.SQL.Add('WHERE a.Id = :Id');
      lQry.ParamByName('Id').AsInteger := aId;
      try
         lQry.Open;
         Result := not lQry.IsEmpty;
      except
        on E: exception do
           Begin
              Result := False;
              Raise Exception.Create(E.Message);
           end;
      end;
   finally
     lQry.Close;
     FreeAndNil(lQry);
   end;

end;

procedure TFuncoesDao.Bind(aDataSet: TDataSet; aModel: iFuncoesModel);
begin
  aModel.id(aDataSet.FieldByName('id').AsInteger);
  aModel.descricao(aDataSet.FieldByName('descricao').AsString);
end;

constructor TFuncoesDao.Create;
begin
  FSQL := TStringList.Create;
  FQry := TSQLQuery.Create(nil);
  FQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
end;

destructor TFuncoesDao.Destroy;
begin
  FreeAndNil(FSQL);
  FQry.Close;
  FreeAndNil(FQry);
  inherited Destroy;
end;

class function TFuncoesDao.New: iFuncoesDao;
begin
   Result := Self.Create;
end;

function TFuncoesDao.Funcoes(aId: integer): TDataSet;
begin
   FQry.Close;
   FQry.SQL.Clear;
   FQry.SQL.Add('SELECT ');
   FQry.SQL.Add(' a.id ');
   FQry.SQL.Add(',a.descricao ');
   FQry.SQL.Add('FROM public.funcoes a');
   if aId > 0 then
      Begin
         FQry.SQL.Add('WHERE a.Id = :Id');
         FQry.ParamByName('Id').AsInteger := aId;
      end;
   try
      FQry.Open;
      Result := FQry;
   except
     on E: exception do
        Raise Exception.Create(E.Message);
   end;
end;

function TFuncoesDao.Funcoes(aId: integer; aModel: iFuncoesModel): iFuncoesDao;
var lQry: TSQLQuery;
begin
   Result := Self;
   if aId <= 0 then
      Raise Exception.Create('ID não foi informado !');

   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT * FROM public.funcoes ');
      lQry.SQL.Add('WHERE Id = :Id');
      lQry.ParamByName('Id').AsInteger := aId;
      try
         lQry.Open;
         if not lQry.IsEmpty then
            Bind(lQry,aModel);
      except
         on E: exception do
            Raise Exception.Create(E.Message);
      end;
   finally
     lQry.Close;
     FreeAndNil(lQry);
   end;
end;

function TFuncoesDao.Delete(aId: integer): boolean;
var lQry: TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lQry.SQL.Add('DELETE FROM public.funcoes ');
      lQry.SQL.Add('WHERE Id = :Id');
      lQry.ParamByName('Id').AsInteger := aId;
      try
         lQry.ExecSQL;
         lQry.SQLTransaction.Commit;
      except
         Result := False;
      end;
   finally
     lQry.Close;
     FreeAndNil(lQry);
   end;
end;

function TFuncoesDao.Save(aModel: iFuncoesModel): boolean;
var lQry : TSQLQuery;
  lExist : Boolean;
begin
   if aModel = nil then
      Begin
         Raise Exception.Create('Função não informada !');
         Exit(False);
      end;
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lExist:= Exist(aModel.Id);
      if not lExist then
         Begin
            lQry.SQL.Add('INSERT INTO sacristao.public.funcoes');
            lQry.SQL.Add('(descricao)');
            lQry.SQL.Add('VALUES');
            lQry.SQL.Add('(:descricao)');
            lQry.SQL.Add('RETURNING id');
         end
      else
         Begin
            lQry.SQL.Add('UPDATE public.funcoes SET');
            lQry.SQL.Add(' descricao = :descricao');
            lQry.SQL.Add('WHERE');
            lQry.SQL.Add('id = :id');
            lQry.ParamByName('id').AsInteger := aModel.Id;
         end;
      lQry.ParamByName('descricao').AsString := aModel.Descricao;
      try
         if not lExist then
            Begin
               lQry.Open;
               aModel.Id(lQry.FieldByName('id').AsInteger);
            end
         else
            lQry.ExecSQL;
         lQry.SQLTransaction.Commit;
      except
         Result := False;
      end;
   finally
     lQry.Close;
     FreeAndNil(lQry);
   end;

end;

end.

