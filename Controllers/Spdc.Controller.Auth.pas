unit Spdc.Controller.Auth;

interface

uses
  Horse, System.JSON, JOSE.Core.JWT, JOSE.Core.Builder, System.SysUtils,
  Spdc.UserAuth.Response, REST.Json;

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
 LUserAuthResponse : TDTOUserAuthResponse;
 LUser, LPassword: String;
 LJWT   : TJWT;
 LToken : string;
begin
   LBody := Req.Body<TJSONObject>;

   if Assigned(LBody) then begin
      LBody.TryGetValue<string>('user', LUser);
      LBody.TryGetValue<string>('password', LPassword);
   end;

   if (LUser = 'admin') and (LPassword = '123') then begin

     LJWT := TJWT.Create;

     LUserAuthResponse := TDTOUserAuthResponse.Create;


     try
       LJWT.Claims.Subject := '999';
       LJWT.Claims.Issuer := 'Spdc-API';
       LJWT.Claims.Expiration := Now + 1; // Expira em 1 dia

       LToken := TJOSE.SHA256CompactToken('123456', LJWT); // Chave Secreta

       // Preciso preencher as Properties
       LUserAuthResponse.UserId := '999';
       LUserAuthResponse.Username := LUser;
       LUserAuthResponse.Token := LToken;


       Res.Status(200).Send<TJSONObject>(TJson.ObjectToJsonObject(LUserAuthResponse));
     finally
       LJWT.Free;
       LUserAuthResponse.Free;
     end;
   end
   else begin
     Res.Status(401).Send('Usuário ou Senha inválidos');
   end;
end;

end.
