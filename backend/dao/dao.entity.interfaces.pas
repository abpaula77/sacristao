unit Dao.Entity.Interfaces;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Model.Entity.Interfaces;

type
  iLocaisDao = interface
     ['{82FDB325-800B-45F9-BBB3-8713E48F2B1C}']
     function Locais(aId : integer) : TDataSet; overload;
     function Locais(aId : integer;aModel : iLocaisModel) : iLocaisDao; overload;
     function Delete(aId : integer): boolean;
     function Save(aModel : iLocaisModel): boolean;
  end;

implementation

end.

