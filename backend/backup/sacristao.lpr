program sacristao;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Model.Entity.Interfaces, dao.entity.interfaces, Dao.Locais,
  Controller.Entity.Interfaces, Controller.Entity.Locais, View.Pages.Principal,
  JsonNode in 'lib\json\jsontools.pas';

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

