unit Lac.Model.DAO.Empresa;

interface

uses
  Spdc.Infra.Connection, FireDAC.Comp.Client, Model.Entity.Empresa;

type
  TDAOEmpresa = class
    class procedure CriarEmpresa(aEmpresa : TEmpresa);
  end;

implementation

{ TDAOEmpresa }

class procedure TDAOEmpresa.CriarEmpresa(aEmpresa : TEmpresa);
var
  LConexao : iControllerConnection;
  LQry     : TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry     := TFDQuery.Create(nil);

  try
   LQry.Connection := LConexao.GetConnection;

   LQry.SQL.Text :=
    'INSERT INTO TB_BUSINESS '+
    '(BUSINESS_ID, CORPORATE_NAME, FANTASY_NAME, CNPJ, IE, UF, ENVIRONMENT, LAST_NSU, CERT_BASE64, CERT_PASSWORD, CERT_EXPIRATION) '+
    'VALUES '+
    '(:BUSINESS_ID, :CORPORATE_NAME, :FANTASY_NAME, :CNPJ, :IE, :UF, :ENVIRONMENT, :LAST_NSU, :CERT_BASE64, :CERT_PASSWORD, :CERT_EXPIRATION) ';

    LQry.ParamByName('BUSINESS_ID').AsString := aEmpresa.BusinessId;
    LQry.ParamByName('CORPORATE_NAME').AsString := aEmpresa.CorporateName;
    LQry.ParamByName('FANTASY_NAME').AsString := aEmpresa.FantasyName;
    LQry.ParamByName('CNPJ').AsString := aEmpresa.Cnpj;
    LQry.ParamByName('IE').AsString := aEmpresa.Ie;
    LQry.ParamByName('UF').AsString := aEmpresa.Uf;
    LQry.ParamByName('ENVIRONMENT').AsInteger := aEmpresa.Environment;
    LQry.ParamByName('LAST_NSU').AsString := aEmpresa.LastNSU;
    LQry.ParamByName('CERT_BASE64').AsString := aEmpresa.CertBase64;
    LQry.ParamByName('CERT_PASSWORD').AsString := aEmpresa.CertPassword;
    LQry.ParamByName('CERT_EXPIRATION').AsDateTime := aEmpresa.CertExpiration;

    LQry.ExecSQL;
  finally
   LQry.Free;
  end;
end;

end.
