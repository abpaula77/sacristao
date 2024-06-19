unit Dao.Horarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, Model.Conexoes.ConexaoPostgreSQL, Dao.Entity.Interfaces,
  Model.Entity.Interfaces, DB;
type

  { THorariosDao }

  THorariosDao = class(TInterfacedObject, iHorariosDao)
    private
       FSQL : TStringList;
       FQry : TSQLQuery;
       function Exist(aId : integer): boolean;
       procedure Bind(aDataSet : TDataSet; aModel: iHorariosModel);
    public
       constructor Create;
       destructor Destroy; override;
       class function New: iHorariosDao;
       function Horarios(aId : integer) : TDataSet; overload;
       function Horarios(aId : integer;aModel : iHorariosModel) : iHorariosDao; overload;
       function Delete(aId : integer): boolean;
       function Save(aModel : iHorariosModel): boolean;
  end;

implementation

{ THorariosDao }

function THorariosDao.Exist(aId: integer): boolean;
var lQry : TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT ');
      lQry.SQL.Add(' a.id ');
      lQry.SQL.Add('FROM public.horarios a');
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

procedure THorariosDao.Bind(aDataSet: TDataSet; aModel: iHorariosModel);
begin
  aModel.id(aDataSet.FieldByName('id').AsInteger);
  aModel.local_id(aDataSet.FieldByName('local_id').AsInteger);
  aModel.descricao(aDataSet.FieldByName('descricao').AsString);
  aModel.hora_inicio(aDataSet.FieldByName('hora_inicio').AsString);
  aModel.segunda(aDataSet.FieldByName('segunda').AsBoolean);
  aModel.terca(aDataSet.FieldByName('terca').AsBoolean);
  aModel.quarta(aDataSet.FieldByName('quarta').AsBoolean);
  aModel.quinta(aDataSet.FieldByName('quinta').AsBoolean);
  aModel.sexta(aDataSet.FieldByName('sexta').AsBoolean);
  aModel.sabado(aDataSet.FieldByName('sabado').AsBoolean);
  aModel.domingo(aDataSet.FieldByName('domingo').AsBoolean);
end;

constructor THorariosDao.Create;
begin
  FSQL := TStringList.Create;
  FQry := TSQLQuery.Create(nil);
  FQry.SQLConnection := TModelConexaoPostgreSQL.getInstance.Conexao;
end;

destructor THorariosDao.Destroy;
begin
  FreeAndNil(FSQL);
  FQry.Close;
  FreeAndNil(FQry);
  inherited Destroy;
end;

class function THorariosDao.New: iHorariosDao;
begin
   Result := Self.Create;
end;

function THorariosDao.Horarios(aId: integer): TDataSet;
begin
   FQry.Close;
   FQry.SQL.Clear;
   FQry.SQL.Add('SELECT ');
   FQry.SQL.Add(' a.id ');
   FQry.SQL.Add(',a.local_id ');
   FQry.SQL.Add(',a.descricao ');
   FQry.SQL.Add(',a.hora_inicio ');
   FQry.SQL.Add(',a.segunda ');
   FQry.SQL.Add(',a.terca ');
   FQry.SQL.Add(',a.quarta ');
   FQry.SQL.Add(',a.quinta ');
   FQry.SQL.Add(',a.sexta ');
   FQry.SQL.Add(',a.sabado ');
   FQry.SQL.Add(',a.domingo ');
   FQry.SQL.Add('FROM public.horarios a');
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

function THorariosDao.Horarios(aId: integer; aModel: iHorariosModel): iHorariosDao;
var lQry: TSQLQuery;
begin
   Result := Self;
   if aId <= 0 then
      Raise Exception.Create('ID não foi informado !');

   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lQry.SQL.Add('SELECT * FROM public.horarios ');
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

function THorariosDao.Delete(aId: integer): boolean;
var lQry: TSQLQuery;
begin
   Result := True;
   lQry := TSQLQuery.Create(nil);
   try
      lQry.SQLConnection := FQry.SQLConnection;
      lQry.SQL.Clear;
      lQry.SQL.Add('DELETE FROM public.horarios ');
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

function THorariosDao.Save(aModel: iHorariosModel): boolean;
var lQry : TSQLQuery;
  lExist : Boolean;
begin
   if aModel = nil then
      Begin
         Raise Exception.Create('Horário não informado !');
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
            lQry.SQL.Add('INSERT INTO sacristao.public.horarios');
            lQry.SQL.Add('(local_id,descricao,hora_inicio,segunda,terca,quarta,quinta,sexta,sabado,domingo)');
            lQry.SQL.Add('VALUES');
            lQry.SQL.Add('(:local_id,:descricao,:hora_inicio,:segunda,:terca,:quarta,:quinta,:sexta,:sabado,:domingo)');
            lQry.SQL.Add('RETURNING id');
         end
      else
         Begin
            lQry.SQL.Add('UPDATE public.horarios SET');
            lQry.SQL.Add(' local_id = :local_id');
            lQry.SQL.Add(',descricao = :descricao');
            lQry.SQL.Add(',hora_inicio = :hora_inicio');
            lQry.SQL.Add(',segunda = :segunda');
            lQry.SQL.Add(',terca = :terca');
            lQry.SQL.Add(',quarta = :quarta');
            lQry.SQL.Add(',quinta = :quinta');
            lQry.SQL.Add(',sexta = :sexta');
            lQry.SQL.Add(',sabado = :sabado');
            lQry.SQL.Add(',domingo = :domingo');
            lQry.SQL.Add('WHERE');
            lQry.SQL.Add('id = :id');
            lQry.ParamByName('id').AsInteger := aModel.Id;
         end;
      lQry.ParamByName('descricao').AsString := aModel.Descricao;
      lQry.ParamByName('local_id').AsInteger := aModel.Local_Id;
      lQry.ParamByName('hora_inicio').AsString := aModel.Hora_Inicio;
      lQry.ParamByName('segunda').AsBoolean := aModel.Segunda;
      lQry.ParamByName('terca').AsBoolean := aModel.Terca;
      lQry.ParamByName('quarta').AsBoolean := aModel.Quarta;
      lQry.ParamByName('quinta').AsBoolean := aModel.Quinta;
      lQry.ParamByName('sexta').AsBoolean := aModel.Sexta;
      lQry.ParamByName('sabado').AsBoolean := aModel.Sabado;
      lQry.ParamByName('domingo').AsBoolean := aModel.Domingo;
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

