unit DTO.UsuarioEmpresa.Response;

interface

uses
  System.SysUtils, System.StrUtils, Lac.Utils, System.Generics.Collections;

type
  // Vou criar uma Classe só para a empresa, pois vai ter mais de uma, então retornaremos um Array.
  TDTOEmpresa = class
  private
    FCnpj: string;
    FCorporateName: string;
    FRoleName: string;
    FBusinessId: string;
    FFantasyName: String;

    procedure SetBusinessId(const Value: string);

   public
    property BusinessId: string read FBusinessId write SetBusinessId;
    property CorporateName: string read FCorporateName write FCorporateName;
    property Cnpj: string read FCnpj write FCnpj;
    property RoleName: string read FRoleName write FRoleName;
    property FantasyName: String read FFantasyName write FFantasyName;

    class function New: TDTOEmpresa;
  end;

  TDTOUsuarioEmpresaResponse = class
  private
    FUserId: String;
    FEmpresas: TObjectList<TDTOEmpresa>;

    procedure SetUserId(const Value: String);
    procedure SetEmpresas(const Value: TObjectList<TDTOEmpresa>);
  public
    property UserId: String read FUserId write SetUserId;
    property Empresas: TObjectList<TDTOEmpresa> read FEmpresas;

    constructor Create;
    destructor Destroy; override;
    class function New: TDTOUsuarioEmpresaResponse;
  end;

implementation

{ TDTOUsuarioEmpresaResponse }

constructor TDTOUsuarioEmpresaResponse.Create;
begin
  inherited Create;
  // Como o meu FEmpresas retorna um ObjectList, precisamos colocar ele no Constructor
  FEmpresas := TObjectList<TDTOEmpresa>.Create;
end;

destructor TDTOUsuarioEmpresaResponse.Destroy;
begin
  Empresas.Free;
  inherited;
end;

class function TDTOUsuarioEmpresaResponse.New: TDTOUsuarioEmpresaResponse;
begin
  Result := TDTOUsuarioEmpresaResponse.Create;
end;

procedure TDTOUsuarioEmpresaResponse.SetEmpresas(
  const Value: TObjectList<TDTOEmpresa>);
begin

end;

procedure TDTOUsuarioEmpresaResponse.SetUserId(const Value: String);
begin
  if Trim(Value) = '' then begin
     FUserId := '';
     Exit;
  end;

  FUserId := Value;
end;

{ TDTOEmpresa }

class function TDTOEmpresa.New: TDTOEmpresa;
begin
   Result := TDTOEmpresa.Create;
end;

procedure TDTOEmpresa.SetBusinessId(const Value: string);
begin
  if Trim(Value) = '' then begin
     FBusinessId := '';
     Exit;
  end;

  FBusinessId := TLacUtils.CleanID(Value);
end;

end.
