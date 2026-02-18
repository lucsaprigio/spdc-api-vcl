unit Lac.Model.DAO.UsuarioEmpresa;

interface

uses Model.Entity.UsuarioEmpresa, FireDAC.Comp.Client, Spdc.Infra.Connection,
  DTO.UsuarioEmpresa.Response, System.Generics.Collections, System.JSON;

type
  TDAOUsuarioEmpresa = class
    class procedure CriarUsuarioAEmpresa(aUsuarioEmpresa : TUsuarioEmpresa);
    class function  BuscarUsuarioEmpresa(aUserId: string) : TDTOUsuarioEmpresaResponse;
  end;

implementation

{ TDAOUsuarioEmpresa }

class function TDAOUsuarioEmpresa.BuscarUsuarioEmpresa(
  aUserId: string): TDTOUsuarioEmpresaResponse;
var
  LConexao : IControllerConnection;
  LQry     : TFDQuery;
  LEmpresa : TDTOEmpresa;
begin
  Result := TDTOUsuarioEmpresaResponse.New;

  Result.UserId := aUserId;

  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
  LConexao.Connect;
  LQry.Connection := LConexao.GetConnection;

  LQry.SQL.TExt :=
  'SELECT A.USERID '+
  '   ,A.BUSINESS_ID '+
  '   ,A.ROLE_NAME '+
  '   ,B.CNPJ '+
  '   ,B.CORPORATE_NAME '+
  '   ,B.FANTASY_NAME '+
  'FROM TB_USER_BUSINESS A '+
  'JOIN TB_BUSINESS B ON B.BUSINESS_ID = A.BUSINESS_ID '+
  'WHERE A.USERID = :USERID ';

  LQry.ParamByName('USERID').AsString := aUserId;

  LQry.Open;

  while not LQry.Eof do begin
    LEmpresa := TDTOEmpresa.New;

    LEmpresa.BusinessId   := LQry.FieldByName('BUSINESS_ID').AsString;
    LEmpresa.RoleName     := LQry.FieldByName('ROLE_NAME').AsString;
    LEmpresa.Cnpj         := LQry.FieldByName('CNPJ').AsString;
    LEmpresa.CorporateName:= LQry.FieldByName('CORPORATE_NAME').AsString;
    LEmpresa.FantasyName  := LQry.FieldByName('FANTASY_NAME').AsString;

    Result.Empresas.Add(LEmpresa);

    LQry.Next;
  end;

  finally
    LQry.Free;
  end;
end;

class procedure TDAOUsuarioEmpresa.CriarUsuarioAEmpresa(
  aUsuarioEmpresa: TUsuarioEmpresa);
var
  LConexao : IControllerConnection;
  LQry : TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LConexao.Connect;
    LQry.Connection := LConexao.GetConnection;

    LQry.SQL.Text :=
    'INSERT INTO TB_USER_BUSINESS '+
    '       (USERID '+
    '       ,BUSINESS_ID'+
    '       ,ROLE_NAME'+
    '       )'+
    'VALUES ' +
    '       (:USERID'+
    '        ,:BUSINESS_ID' +
    '        ,:ROLE_NAME';

    LQry.ParamByName('USERID').AsString      := aUsuarioEmpresa.UserId;
    LQry.ParamByName('BUSINESS_ID').AsString := aUsuarioEmpresa.BusinessId;
    LQry.ParamByName('ROLE_NAME').AsString   := aUsuarioEmpresa.RoleName;

    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

end.
