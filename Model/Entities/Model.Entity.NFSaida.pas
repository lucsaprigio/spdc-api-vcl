unit Model.Entity.NFSaida;

interface

uses
  System.SysUtils;

type
TNotasSaida = class
  private
    FId: string;
    FBusinessId: string;
    FNumero: Integer;
    FSerie: Integer;
    FChaveAcesso: string;
    FProtocolo: string;
    FCfop: string;
    FDataEmissao: TDateTime;
    FValorTotal: Double;
    FBaseIcms: Double;
    FValorIcms: Double;
    FAliqIcms : Double;
    FBaseSt : Double;
    FValorSt : Double;
    FObsNf : WideString;

    // Assinaturas dos Getters e Setters
    function GetId: string;
    procedure SetId(const Value: string);
    function GetAliqIcms: Double;
    procedure SetAliqIcms(const Value: Double);

    function GetBaseSt: Double;
    procedure SetBaseSt(const Value: Double);

    function GetValorSt: Double;
    procedure SetValorSt(const Value: Double);

    function GetObsNf: WideString;
    procedure SetObsNf(const Value: WideString);

    constructor Create(const aId : String = '');

    property Id: string read GetId write SetId;
    property BusinessId: string read FBusinessId write FBusinessId;
    property Numero: Integer read FNumero write FNumero;
    property Serie: Integer read FSerie write FSerie;
    property ChaveAcesso: string read FChaveAcesso write FChaveAcesso;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Cfop: string read FCfop write FCfop;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property BaseIcms: Double read FBaseIcms write FBaseIcms;
    property ValorIcms: Double read FValorIcms write FValorIcms;
    property AliqIcms: Double read GetAliqIcms write SetAliqIcms;
    property BaseSt: Double read GetBaseSt write SetBaseSt;
    property ValorSt: Double read GetValorSt write SetValorSt;
    property ObsNf: WideString read GetObsNf write SetObsNf;
  end;

implementation

{ TNotasSaida }

constructor TNotasSaida.Create(const aId : String = '');
begin
    // Lembrar sempre que for instanciar, dar o .Create, enviar o ID se for consulta... Futuramente posso criar uma função para validação.
    if Trim(aId) = '' then
      FId := TGUID.NewGuid.toString().Replace('{', '').Replace('}', '')
    else
      FId := aId;
end;

function TNotasSaida.GetAliqIcms: Double;
begin
     Result := FAliqIcms;
end;

function TNotasSaida.GetBaseSt: Double;
begin
     Result := FBaseSt;
end;

function TNotasSaida.GetId: string;
begin
    Result := FId;
end;

function TNotasSaida.GetValorSt: Double;
begin
     Result := FValorSt;
end;

function TNotasSaida.GetObsNf: WideString;
begin
    Result := FObsNf;
end;

procedure TNotasSaida.SetAliqIcms(const Value: Double);
begin
      FAliqIcms := Value;
end;

procedure TNotasSaida.SetBaseSt(const Value: Double);
begin
      FBaseSt := Value;
end;

procedure TNotasSaida.SetValorSt(const Value: Double);
begin
      FValorSt := Value;
end;


procedure TNotasSaida.SetId(const Value: string);
begin
   if Value.Trim = '' then begin
    FId := '';
    Exit;
  end;

    FId := Value.Replace('{', '').Replace('}', '');
end;

procedure TNotasSaida.SetObsNf(const Value: WideString);
begin
      FObsNf := Value;
end;


