unit Spdc.Controller.Auth;

interface

uses
  Horse, System.JSON, JOSE.Core.JWT, JOSE.Core.Builder, System.SysUtils,
  Spdc.UserAuth.Response, REST.JSON, Spdc.Model.DAO.Usuario,
  Model.Entity.Usuario, System.Hash, Spdc.Utils.Configuracao;

type
  TControllerAuth = class
  public
    class procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TControllerAuth }

class procedure TControllerAuth.Login(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
var
  LBody: TJSONObject;
  LUserAuthResponse: TDTOUserAuthResponse;
  LEmail, LPassword, LHashPassword: String;
  LUser: TUser;
  LJWT: TJWT;
  LToken: string;
begin
  LBody := Req.Body<TJSONObject>;

  if Assigned(LBody) then
  begin
    LBody.TryGetValue<string>('email', LEmail);
    LBody.TryGetValue<string>('password', LPassword);
  end;

  LUser := TModelUsuario.BuscarPorEmail(LEmail);

  if Assigned(LUser) then
  begin

    LHashPassword := THashSHA2.GetHashString(LPassword);

    if LUser.Password = LHashPassword then
    begin

      LJWT := TJWT.Create;

      LUserAuthResponse := TDTOUserAuthResponse.Create;

      try
        LJWT.Claims.Subject := LUser.UserId;
        LJWT.Claims.Issuer := 'LAC-API';
        LJWT.Claims.Expiration := Now + 1;  // Expira em 1 dia

        LToken := TJOSE.SHA256CompactToken(TAppConfig.JWT_SECRET, LJWT); // Chave Secreta

        // Preciso preencher as Properties
        LUserAuthResponse.UserId := LUser.UserId.Replace('{','').Replace('}', '');
        LUserAuthResponse.Username := LUser.Username;
        LUserAuthResponse.Token := LToken;

        Res.Status(200).Send<TJSONObject>(TJson.ObjectToJsonObject(LUserAuthResponse));
      finally
        LJWT.Free;
        LUserAuthResponse.Free;
      end;
    end
    else
    begin
      Res.Status(401).Send('Usuário ou Senha inválidos');
    end;

  end;
end;

end.
