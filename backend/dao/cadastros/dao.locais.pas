unit Dao.Locais;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Model.Conexoes.ConexaoPostgreSQL, Dao.Entity.Interfaces,
  Model.Entity.Interfaces, DB;
type

  { TLocaisDao }

  TLocaisDao = class(TInterfacedObject, iLocaisDao)
    private
       FSQL : TStringList;
       FQry : TSQLQuery;
       function Exist(aId : integer): boolean;
       procedure Bind(aDataSet : TDataSet; aModel: iLocaisModel);
    public
       constructor Create;
       destructor Destroy; override;
       class function New: iLocaisDao;
       function Locais(aId : integer) : TDataSet; overload;
       function Locais(aId : integer;aModel : iLocaisModel) : iLocaisDao; overload;
       function Delete(aId : integer): boolean;
       function Save(aModel : iLocaisModel): boolean;
  end;

implementation

{ TLocaisDao }

function TLocaisDao.Exist(aId: integer): boolean;
var lQry : TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT ');
      lQry.SQL.Add(' a.id ');
      lQry.SQL.Add('FROM public.locais a');
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
     FreeAndNil(lQry);
   end;

end;

procedure TLocaisDao.Bind(aDataSet: TDataSet; aModel: iLocaisModel);
begin
  aModel.id(aDataSet.FieldByName('id').AsInteger);
  aModel.descricao(aDataSet.FieldByName('descricao').AsString);
  aModel.endereco(aDataSet.FieldByName('endereco').AsString);
end;

constructor TLocaisDao.Create;
begin
  FSQL := TStringList.Create;
  FQry := TSQLQuery.Create(nil);
  FQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
end;

destructor TLocaisDao.Destroy;
begin
  FreeAndNil(FSQL);
  FQry.Close;
  FreeAndNil(FQry);
  inherited Destroy;
end;

class function TLocaisDao.New: iLocaisDao;
begin
   Result := Self.Create;
end;

function TLocaisDao.Locais(aId: integer): TDataSet;
begin
   FQry.Close;
   FQry.SQL.Clear;
   FQry.SQL.Add('SELECT ');
   FQry.SQL.Add(' a.id ');
   FQry.SQL.Add(',a.descricao ');
   FQry.SQL.Add(',a.endereco ');
   FQry.SQL.Add('FROM public.locais a');
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

function TLocaisDao.Locais(aId: integer; aModel: iLocaisModel): iLocaisDao;
var lQry: TSQLQuery;
begin
   Result := Self;
   if aId <= 0 then
      Raise Exception.Create('ID não foi informado !');

   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT * FROM public.locais ');
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

function TLocaisDao.Delete(aId: integer): boolean;
var lQry: TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
      lQry.SQL.Clear;
      lQry.SQL.Add('DELETE FROM public.locais ');
      lQry.SQL.Add('WHERE Id = :Id');
      lQry.ParamByName('Id').AsInteger := aId;
      try
         lQry.ExecSQL;
      except
         Result := False;
      end;
   finally
     FreeAndNil(lQry);
   end;
end;

function TLocaisDao.Save(aModel: iLocaisModel): boolean;
var lQry : TSQLQuery;
  lExist : Boolean;
begin
   if aModel = nil then
      Begin
         Raise Exception.Create('Local não informado !');
         Exit(False);
      end;
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
      lQry.SQL.Clear;
      lExist:= Exist(aModel.Id);
      if not lExist then
         Begin
            lQry.SQL.Add('INSERT INTO public.locais');
            lQry.SQL.Add('(descricao,endereco)');
            lQry.SQL.Add('VALUES');
            lQry.SQL.Add('(:descricao,:endereco)');
         end
      else
         Begin
            lQry.SQL.Add('UPDATE public.locais SET');
            lQry.SQL.Add(' descricao = :descricao');
            lQry.SQL.Add(',endereco = :endereco');
            lQry.SQL.Add('WHERE');
            lQry.SQL.Add('id = :id');
            lQry.ParamByName('id').AsInteger := aModel.Id;
         end;
      lQry.ParamByName('descricao').AsString := aModel.Descricao;
      lQry.ParamByName('endereco').AsString := aModel.Endereco;
      try
         lQry.ExecSQL;
      except
         Result := False;
      end;
   finally
     FreeAndNil(lQry);
   end;

end;

end.

