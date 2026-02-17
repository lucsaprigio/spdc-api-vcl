unit Lac.Controller.Empresa;

interface

uses
  Horse, System.JSON, Model.Entity.Empresa, Lac.Model.DAO.Empresa,
  System.SysUtils, Lac.Utils, REST.JSON, Lac.Utils.Certificados;

type
  TControllerEmpresa = class
    class procedure GetBusinessByCnpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PostNewBusiness(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PutAtualizaCertificado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure PutAtualizarEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TControllerEmpresa }

class procedure TControllerEmpresa.GetBusinessByCnpj(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LCnpj: String;
  LEmpresa: TEmpresa;
begin
  LCnpj := Req.Params.Field('id').AsString;

  LEmpresa := TDAOEmpresa.BuscarEmpresaPorCnpj(LCnpj);

  if Assigned(LEmpresa) then
    Res.Send<TJSONObject>(TJson.ObjectToJsonObject(LEmpresa))
  else
    Res.Status(400).Send('Empresa não encontrada.')
end;

class procedure TControllerEmpresa.PostNewBusiness(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LBusiness: TEmpresa;
begin
  LBody := Req.Body<TJSONObject>;

  if not Assigned(LBody) then
  begin
    Res.Status(400).Send('Corpo da Requisição Inválido');
    Exit;
  end;

  LBusiness := TEmpresa.New;
  try
    try
      LBusiness.CorporateName := LBody.GetValue<string>('corporateName');
      LBusiness.FantasyName := LBody.GetValue<string>('fantasyName');
      LBusiness.Cnpj := LBody.GetValue<string>('cnpj');
      LBusiness.Ie := LBody.GetValue<string>('ie');
      LBusiness.Uf := LBody.GetValue<string>('uf');
      LBusiness.Environment := LBody.GetValue<integer>('env');
      LBusiness.LastNSU := LBody.GetValue<string>('lastNsu', '');
      LBusiness.CertBase64 := LBody.GetValue<string>('cert', '');
      LBusiness.CertPassword := LBody.GetValue<string>('certPass', '');

      TDAOEmpresa.CriarEmpresa(LBusiness);

      Res.Status(200).Send('Empresa criada com sucesso!');
    except
      on E: Exception do
        Res.Status(400).Send('Ocorreu um erro ao criar Empresa ' + E.Message);
    end;
  finally
    LBusiness.Free;
  end;
end;

class procedure TControllerEmpresa.PutAtualizaCertificado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LBusiness: TEmpresa;
  LCnpj: String;
begin
  LBody := Req.Body<TJSONObject>;
  LCnpj := Req.Params.Field('id').AsString;

  LBusiness := TDAOEmpresa.BuscarEmpresaPorCnpj(LCnpj);

  if not Assigned(LBusiness) then
  begin
    Res.Status(404).Send('Empresa não encontrada');
    Exit;
  end;

  try
    if Assigned(LBody) then
    begin
      LBusiness.CertBase64 := LBody.GetValue<String>('certificate');
      LBusiness.CertPassword := LBody.GetValue<String>('certPass');

      LBusiness.CertExpiration := TLacUtilsCertificado.ValidarCertificado(LBusiness.CertBase64, LBusiness.CertPassword);

      TDAOEmpresa.AtualizarCertificado(LCnpj, LBusiness);

      Res.Status(200).Send('Certificado validado e importado com sucesso Válido até ' +
        DateToStr(LBusiness.CertExpiration));
    end;
  except
    on E: Exception do
    begin
      Res.Status(400).Send('Ocorreu um erro ao importar ' + E.Message);
    end;
  end;
end;

class procedure TControllerEmpresa.PutAtualizarEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LID, LTempName, LTempCnpj: String;
  LBody: TJSONObject;
  LBusinessExist, LCheckCnpj: TEmpresa;
begin
  LID   := Req.Params.Field('id').AsString;

  if not TLacUtils.IsValidID(LID) then
  begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (GUID).')
  end;

  LBusinessExist := TDAOEmpresa.BuscarEmpresaPorID(LID);

  if not Assigned(LBusinessExist) then
  begin
    Res.Status(404).Send('Empresa não encontrada.');
    Exit;
  end;

  try
    LBody := Req.Body<TJSONObject>;

    if Assigned(LBody) then begin

      if Assigned(LBody.GetValue('cnpj')) then begin
        LTempCnpj := LBody.GetValue<string>('cnpj');
        if LTempCnpj <> LBusinessExist.Cnpj then begin
          LCheckCnpj := TDAOEmpresa.BuscarEmpresaPorCnpj(LTempCnpj);
          if Assigned(LCheckCnpj) then begin
            LCheckCnpj.Free;
            Res.Status(409).Send('Já existe este CNPJ no Cadastro de Empresa');
            Exit;
          end;
        end;

        LBusinessExist.Cnpj := LTempCnpj;
      end;

      if Assigned(LBody.GetValue('corporateName')) then begin
        LBusinessExist.CorporateName := LBody.GetValue<string>('corporateName');
      end;

      if Assigned(LBody.GetValue('fantasyName')) then begin
        LBusinessExist.FantasyName := LBody.GetValue<string>('fantasyName');
      end;

      if Assigned(LBody.GetValue('ie')) then begin
        LBusinessExist.Ie := LBody.GetValue<string>('ie');
      end;

      if Assigned(LBody.GetValue('uf')) then begin
        LBusinessExist.Uf := LBody.GetValue<string>('uf');
      end;

      if Assigned(LBody.GetValue('env')) then begin
        LBusinessExist.Environment:= LBody.GetValue<integer>('env');
      end;

      if Assigned(LBody.GetValue('lastNsu')) then begin
        LBusinessExist.LastNSU := LBody.GetValue<string>('lastNsu');
      end;

      TDAOEmpresa.AtualizarEmpresa(LBusinessExist);

      Res.Status(200).Send('Empresa atualizada com sucesso.');
    end
    else
    begin
      Res.Status(400).Send('Nenhum dado enviado para atualização.');
    end;
  finally
    LBusinessExist.Free;
  end;
end;

end.
