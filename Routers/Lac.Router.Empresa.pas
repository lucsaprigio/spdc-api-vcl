unit Lac.Router.Empresa;

interface

uses
  Horse, Lac.Controller.Empresa;

procedure Registry;

implementation

procedure Registry;
begin
   THorse.Post('/api/business', TControllerEmpresa.PostNewBusiness);
end;

end.
