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
  Forms, ujlangform, ujprezform;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TJLangForm, JLangForm);
  Application.CreateForm(TJPrezForm, JPrezForm);
  JPrezForm.ShowOnTop;
  Application.Run;
end.

