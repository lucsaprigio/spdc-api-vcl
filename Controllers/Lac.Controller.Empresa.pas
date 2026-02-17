unit Lac.Controller.Empresa;

interface

uses
  Horse, System.JSON, Model.Entity.Empresa, Lac.Model.DAO.Empresa,
  System.SysUtils;

type
  TControllerEmpresa = class
      class procedure PostNewBusiness(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TControllerEmpresa }

class procedure TControllerEmpresa.PostNewBusiness(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LBusiness : TEmpresa;
begin
  LBody := Req.Body<TJSONObject>;

   if not Assigned(LBody) then begin
     Res.Status(400).Send('Corpo da Requisição Inválido');
     Exit;
   end;

   LBusiness := TEmpresa.Create;
   try
     try
       LBusiness.CorporateName := LBody.GetValue<string>('corporateName');
       LBusiness.FantasyName := LBody.GetValue<string>('fantasyName');
       LBusiness.Cnpj := LBody.GetValue<string>('cnpj');
       LBusiness.Ie := LBody.GetValue<string>('ie');
       LBusiness.Uf := LBody.GetValue<string>('uf');
       LBusiness.Environment := LBody.GetValue<integer>('env');
       LBusiness.LastNSU:= LBody.GetValue<string>('lastNsu', '');
       LBusiness.CertBase64 := LBody.GetValue<string>('cert', '');
       LBusiness.CertPassword := LBody.GetValue<string>('certPass', '');

       TDAOEmpresa.CriarEmpresa(LBusiness);

       Res.Status(200).Send('Empresa criada com sucesso!');
     except on E: Exception do
       Res.Status(400).Send('Ocorreu um erro ao criar Empresa ' + E.Message);
     end;
   finally
      LBusiness.Free;
   end;
end;

end.
