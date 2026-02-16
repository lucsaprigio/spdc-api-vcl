unit Spdc.Router.Auth;

interface

uses
  Horse, Spdc.Controller.Auth;

  procedure Registry;

implementation

procedure Registry;
begin
  THorse.Post('/api/login', TControllerAuth.Login);
end;

end.
