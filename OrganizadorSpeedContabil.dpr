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
  Model.Entity.Usuario in 'Model\Entities\Model.Entity.Usuario.pas',
  Lac.Utils in 'Utils\Lac.Utils.pas',
  Lac.Database.Migrations in 'Database\Migrations\Lac.Database.Migrations.pas',
  Lac.Model.DAO.Empresa in 'Model\DAO\Lac.Model.DAO.Empresa.pas',
  Model.Entity.Empresa in 'Model\Entities\Model.Entity.Empresa.pas',
  Lac.Controller.Empresa in 'Controllers\Lac.Controller.Empresa.pas',
  Lac.Router.Empresa in 'Routers\Lac.Router.Empresa.pas',
  Lac.Utils.Certificados in 'Utils\Lac.Utils.Certificados.pas',
  Model.Entity.UsuarioEmpresa in 'Model\Entities\Model.Entity.UsuarioEmpresa.pas',
  Lac.Model.DAO.UsuarioEmpresa in 'Model\DAO\Lac.Model.DAO.UsuarioEmpresa.pas',
  DTO.UsuarioEmpresa.Response in 'DTO\DTO.UsuarioEmpresa.Response.pas',
  Lac.Controller.UsuarioEmpresa in 'Controllers\Lac.Controller.UsuarioEmpresa.pas',
  Lac.Router.UsuarioEmpresa in 'Routers\Lac.Router.UsuarioEmpresa.pas',
  Lac.Exceptions in 'Exceptions\Lac.Exceptions.pas',
  Lac.Services.NotasDestinadas in 'Services\Lac.Services.NotasDestinadas.pas',
  Lac.Factory.NFe in 'Factories\Lac.Factory.NFe.pas',
  Lac.Model.DAO.NotasDestinadas in 'Model\DAO\Lac.Model.DAO.NotasDestinadas.pas',
  Model.Entity.NotasDestinadas in 'Model\Entities\Model.Entity.NotasDestinadas.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_view_principal, frm_view_principal);
  Application.Run;

end.
