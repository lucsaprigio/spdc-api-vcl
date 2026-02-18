unit Lac.Controller.UsuarioEmpresa;

interface

uses
  Horse, System.JSON;

type
  TLacControllerUsuarioEmpresa = class
    class procedure GetBuscarUsuarioEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PostNovoUsuarioEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TLacControllerUsuarioEmpresa }

class procedure TLacControllerUsuarioEmpresa.GetBuscarUsuarioEmpresa(
  Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin

end;

class procedure TLacControllerUsuarioEmpresa.PostNovoUsuarioEmpresa(
  Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin

end;

end.
