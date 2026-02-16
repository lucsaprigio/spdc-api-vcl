program OrganizadorSpeedContabil;

uses
  Vcl.Forms,
  Spdc.View.Principal in 'View\Spdc.View.Principal.pas' {frm_view_principal},
  Spdc.Controller.Usuario in 'Controllers\Spdc.Controller.Usuario.pas',
  Spdc.Router.Usuario in 'Routers\Spdc.Router.Usuario.pas',
  Spdc.Utils.Configuracao in 'Utils\Spdc.Utils.Configuracao.pas',
  Spdc.Controller.Auth in 'Controllers\Spdc.Controller.Auth.pas',
  Spdc.Router.Auth in 'Routers\Spdc.Router.Auth.pas' {$R *.res},
  Spdc.Infra.Connection in 'Infra\Spdc.Infra.Connection.pas',
  Infra.HorseServer in 'Infra\Infra.HorseServer.pas',
  Spdc.UserAuth.Response in 'DTO\Spdc.UserAuth.Response.pas',
  Lac.Schema.ScriptExecute in 'Schemas\Lac.Schema.ScriptExecute.pas' {$R *.res},
  Spdc.Model.DAO.Usuario in 'Model\DAO\Spdc.Model.DAO.Usuario.pas',
  Model.Entity.Usuario in 'Model\Entities\Model.Entity.Usuario.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_view_principal, frm_view_principal);
  Application.Run;
end.
