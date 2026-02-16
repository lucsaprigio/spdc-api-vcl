program OrganizadorSpeedContabil;

uses
  Vcl.Forms,
  Spdc.View.Principal in 'View\Spdc.View.Principal.pas' {frm_view_principal},
  Spdc.Model.Usuario in 'Model\Spdc.Model.Usuario.pas',
  Spdc.Controller.Usuario in 'Controllers\Spdc.Controller.Usuario.pas',
  Spdc.Router.Usuario in 'Routers\Spdc.Router.Usuario.pas',
  Spdc.Utils.Configuracao in 'Utils\Spdc.Utils.Configuracao.pas',
  Spdc.Controller.Auth in 'Controllers\Spdc.Controller.Auth.pas',
  Spdc.Router.Auth in 'Routers\Spdc.Router.Auth.pas' {$R *.res},
  Spdc.Infra.Connection in 'Infra\Spdc.Infra.Connection.pas',
  Infra.HorseServer in 'Infra\Infra.HorseServer.pas',
  Spdc.UserAuth.Response in 'DTO\Spdc.UserAuth.Response.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_view_principal, frm_view_principal);
  Application.Run;
end.
