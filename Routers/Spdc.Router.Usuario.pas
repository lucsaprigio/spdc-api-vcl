unit Spdc.Router.Usuario;

interface

uses
  Horse,
  Spdc.Controller.Usuario;

procedure Registry;

implementation

procedure Registry;
begin
  THorse.Get('/user/:id', TControllerUsuario.GetUsuarioPorID);
  THorse.Get('/user_business/:id', TControllerUsuario.GetUsuarioByEmpresa);
end;

end.
