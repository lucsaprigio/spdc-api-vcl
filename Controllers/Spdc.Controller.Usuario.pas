unit Spdc.Controller.Usuario;

interface

uses
  Horse,
  System.JSON,
  Spdc.Model.Usuario;

type
  TControllerUsuario = class
    public
      class procedure GetUsuarioPorID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure GetUsuarioByEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;
implementation

{ TControllerUsuario }

class procedure TControllerUsuario.GetUsuarioByEmpresa(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lArray   : TJSONArray;
  lEmpresa : Integer;
begin
  lEmpresa := Req.Params.Field('id').AsInteger;
  lArray   := TModelUsuario.ListarPorEmpresa(lEmpresa);

  if Assigned(lArray) then begin
    Res.Send<TJSONArray>(lArray);
  end;
end;

class procedure TControllerUsuario.GetUsuarioPorID(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lIDEmpresa : Integer;
  lObj       : TJSONObject;
begin
  lIDEmpresa := Req.Params.Field('id').AsInteger;
  lObj       := TModelUsuario.BuscarPorID(lIDEmpresa);

  if Assigned(lObj) then begin
    Res.Send<TJSONObject>(lObj);
  end
  else begin
    Res.Status(404).Send('Cliente não encontrado');
  end;
end;

end.
