unit Spdc.Model.Usuario;

interface

uses
  System.JSON, FIREDAC.Comp.Client, System.SysUtils,
  Spdc.Controller.Connection, DataSet.Serialize;

type
  TModelUsuario = class
    class function ListarPorEmpresa(aCodEmpresa: Integer): TJSONArray;
    class function BuscarPorID(aID: Integer): TJSONObject;
  end;

implementation

{ TModelUsuario }

class function TModelUsuario.BuscarPorID(aID: Integer): TJSONObject;
var
  lConexao : IControllerConnection;
  lQry     : TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry     := TFDQuery.Create(nil);

  try
    lQry.Connection := lConexao.GetConnection;
    lQry.SQL.Add(' SELECT FROM DB_CLIENTE_PAGINA WHERE CD_CLIENTE = :pId');
    lQry.ParamByName('pd');

    lQry.Open;

    Result := lQry.ToJSONObject;
  finally
     lQry.Free;
  end;
end;

class function TModelUsuario.ListarPorEmpresa(aCodEmpresa: Integer): TJSONArray;
var
  lConexao : IControllerConnection;
  lQry     : TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry     := TFDQuery.Create(nil);

  try
    lQry.Connection := lConexao.GetConnection;
    lQry.SQL.Add(' SELECT CD_CLIENTE, CNPJ_EMPRESA, RAZAO_EMPRESA, CNPJ_MATRIZ, ITEN, EMP_CONCENTRADORA');
    lQry.SQL.Add(' FROM DB_CLIENTE_PAGINA_EMPRESA WHERE CD_EMPRESA = :pEmpresa');
    lQry.ParamByName('pEmpresa');

    lQry.Open;

    Result := lQry.ToJSONArray;
  finally
     lQry.Free;
  end;
end;

end.
