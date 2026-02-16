unit Spdc.Router.Usuario;

interface

uses
  Horse, Horse.JWT,
  Spdc.Controller.Usuario, Spdc.Utils.Configuracao;

procedure Registry;

implementation

procedure Registry;
begin
  THorse.Use(HorseJWT(TSession.JWT_SECRET, THorseJWTConfig.New.SkipRoutes(['/api/login'])));

  THorse.Get('/api/user/:id', TControllerUsuario.GetUsuarioPorID);
  THorse.Get('/api/user_business/:id', TControllerUsuario.GetUsuarioByEmpresa);
end;

end.
