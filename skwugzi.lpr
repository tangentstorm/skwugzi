program skwugzi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ujlangform, ujprezform, uaudioform, laz_acs_lib;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TJLangForm, JLangForm);
  Application.CreateForm(TJPrezForm, JPrezForm);
  Application.CreateForm(TAudioForm, AudioForm);
  JPrezForm.ShowOnTop;
  AudioForm.ShowOnTop;
  Application.Run;
end.

