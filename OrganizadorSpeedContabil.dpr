program OrganizadorSpeedContabil;

uses
  Vcl.Forms,
  Spdc.View.Principal in 'View\Spdc.View.Principal.pas' {frm_view_principal},
  Spdc.Model.Usuario in 'Model\Spdc.Model.Usuario.pas',
  Spdc.Controller.Connection in 'Infra\Spdc.Controller.Connection.pas',
  Spdc.Controller.Usuario in 'Controllers\Spdc.Controller.Usuario.pas',
  Spdc.Router.Usuario in 'Routers\Spdc.Router.Usuario.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_view_principal, frm_view_principal);
  Application.Run;
end.
