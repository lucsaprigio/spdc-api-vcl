unit Lac.Controller.UsuarioEmpresa;

interface

uses
  Horse, System.JSON, Lac.Model.DAO.UsuarioEmpresa, REST.Json,
  Model.Entity.UsuarioEmpresa, System.SysUtils;

type
  TLacControllerUsuarioEmpresa = class
    class procedure GetBuscarUsuarioEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PostNovoUsuarioEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TLacControllerUsuarioEmpresa }

uses DTO.UsuarioEmpresa.Response, Lac.Utils;

class procedure TLacControllerUsuarioEmpresa.GetBuscarUsuarioEmpresa(
  Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LDTOEmpresaResponse : TDTOUsuarioEmpresaResponse;
  LID                 : String;
begin
  LID := REq.PArams.Field('id').AsString;

  if not TLacUtils.IsValidID(LID) then begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (GUID).');
    Exit;
  end;

  LDTOEmpresaResponse := TDAOUsuarioEmpresa.BuscarUsuarioEmpresa(LID);

  try
   Res.Status(200).Send<TJSONObject>(TJson.ObjectToJsonObject(LDTOEmpresaResponse));
  finally
   LDTOEmpresaResponse.Free;
  end;
end;

class procedure TLacControllerUsuarioEmpresa.PostNovoUsuarioEmpresa(
  Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LUsuarioEmpresa : TUsuarioEmpresa;
begin
  LBody := Req.Body<TJSONObject>;

  if not Assigned(LBody) then
  begin
    Res.Status(400).Send('Corpo da Requisição Inválido');
    Exit;
  end;

  LUsuarioEmpresa.New;

  try
    try
       LUsuarioEmpresa.UserId     := LBody.GetValue<String>('userId');
       LUsuarioEmpresa.BusinessId := LBody.GetValue<String>('businessId');
       LUsuarioEmpresa.RoleName   := LBody.GetValue<String>('roleName');

       TDAOUsuarioEmpresa.CriarUsuarioAEmpresa(LUsuarioEmpresa);

       Res.Status(200).Send('Usuário vinculado a Empresa!');
    except on E: Exception do begin
       Res.Status(400).Send('Ocorreu um erro ao Vincular o Usuário ' + E.Message);
     end;
    end;
  finally
   LUsuarioEmpresa.Free;
  end;

end;

end.
