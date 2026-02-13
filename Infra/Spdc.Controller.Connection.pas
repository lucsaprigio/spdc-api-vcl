unit Spdc.Controller.Connection;

interface

uses
  FireDAC.UI.Intf, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, Data.DB, FireDAC.Comp.Client, FireDAC.DApt,
  System.SysUtils;

type
  IControllerConnection = interface
    ['{8D970CDA-4C32-4198-9866-C21B1EE28B6F}']
    function GetConnection: TFDConnection;
    function Connect: IControllerConnection;
    function Disconnect: IControllerConnection;
  end;

  TControllerConection = class(TInterfacedObject, IControllerConnection)
  private
    FConnection: TFDConnection;
    procedure ConfigurarConexao;
  public
    constructor Create;
    destructor destroy; override;

    class function New: IControllerConnection;

    function GetConnection: TFDConnection;
    function Connect: IControllerConnection;
    function Disconnect: IControllerConnection;
  end;

implementation

{ TControllerConection }

constructor TControllerConection.Create;
begin
  FConnection := TFDConnection.Create(nil);
  ConfigurarConexao;
end;

destructor TControllerConection.destroy;
begin
  FConnection.Free;
  inherited;
end;

class function TControllerConection.New: IControllerConnection;
begin
  Result := Self.Create;
end;

procedure TControllerConection.ConfigurarConexao;
begin
  // Colocar no INI
  with FConnection do
  begin
    Connected                  := False;
    Params.Clear;

    Params.DriverID            := 'FB';
    Params.Values['Protocol']  := 'TCPIP';
    Params.Values['Port']      := '3050';
    Params.Values['Server']    := '192.168.0.85';

    Params.Database            := '/database/gc/spdc/spdc.fdb';
    Params.UserName            := 'SYSDBA';
    Params.Password            := 'masterkey';

    // Configurações importantes para performance
    LoginPrompt := False;

    Params.Values['LoginTimeout']   := '5';
    Params.Values['ConnectTimeout'] := '5';

     ResourceOptions.AutoConnect := True; // Para o TTask
  end;
end;

function TControllerConection.Connect: IControllerConnection;
begin
  Result := Self;

  try
    if not FConnection.Connected then begin
      FConnection.Connected := True;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro fatal ao conectar no banco de dados: ' + E.Message);
    end;
  end;
end;

function TControllerConection.Disconnect: IControllerConnection;
begin
  Result := Self;
  FConnection.Connected := False;
end;

function TControllerConection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
