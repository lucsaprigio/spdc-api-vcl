unit Spdc.Model.Usuario;

interface

uses
  System.JSON, FIREDAC.Comp.Client, System.SysUtils,
  Spdc.Infra.Connection, DataSet.Serialize;

type
  TModelUsuario = class
    class function ListarPorEmpresa(aCodEmpresa: Integer): TJSONArray;
    class function BuscarPorID(aID: Integer): TJSONObject;
  end;

implementation

{ TModelUsuario }

class function TModelUsuario.BuscarPorID(aID: Integer): TJSONObject;
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry := TFDQuery.Create(nil);

  try
    lConexao.Connect;
    
    lQry.Connection := lConexao.GetConnection;
    lQry.SQL.Add
      (' SELECT CD_CLIENTE, CNPJ_CLIENTE FROM DB_CLIENTE_PAGINA WHERE CD_CLIENTE = :pId');
    lQry.ParamByName('pId').AsInteger := aID;

    lQry.Open;
    Result := lQry.ToJSONObject;
  except
    on E: Exception do
    begin
      raise Exception.Create('Ocorreu um erro ao executar a Query: ' +
        E.Message);
    end;
  end;
  lQry.Free;
  lConexao.Disconnect;
end;

class function TModelUsuario.ListarPorEmpresa(aCodEmpresa: Integer): TJSONArray;
var
  lConexao: IControllerConnection;
  lQry: TFDQuery;
begin
  lConexao := TControllerConection.New;
  lQry := TFDQuery.Create(nil);

  try
    lQry.Connection := lConexao.GetConnection;
    lQry.SQL.Add
      (' SELECT CD_CLIENTE, CNPJ_EMPRESA, RAZAO_EMPRESA, CNPJ_MATRIZ, ITEN, EMP_CONCENTRADORA');
    lQry.SQL.Add
      (' FROM DB_CLIENTE_PAGINA_EMPRESA WHERE CD_CLIENTE = :pEmpresa');
    lQry.ParamByName('pEmpresa').AsInteger := aCodEmpresa;

    lQry.Open;

    Result := lQry.ToJSONArray;
  finally
    lQry.Free;
  end;
end;

end.
