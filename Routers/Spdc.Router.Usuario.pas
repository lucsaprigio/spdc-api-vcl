unit Spdc.Router.Usuario;

interface

uses
  Horse, Horse.JWT,
  Spdc.Controller.Usuario, Spdc.Utils.Configuracao;

procedure Registry;

implementation

procedure Registry;
begin
  THorse.Use(HorseJWT(TAppConfig.JWT_SECRET, THorseJWTConfig.New.SkipRoutes(['/api/login', '/api/user'])));

  THorse.Get('/api/user/:id', TControllerUsuario.GetUsuarioPorID);
  THorse.Get('/api/user_business/:id', TControllerUsuario.GetUsuarioByEmpresa);
  THorse.Post('/api/user', TControllerUsuario.PostNewUser);
  THorse.Put('/api/user/:id', TControllerUsuario.PutUpdateUser);
  THorse.Delete('/api/user/:id', TControllerUsuario.DeleteUser);
end;

end.
