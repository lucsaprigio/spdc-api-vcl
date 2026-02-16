unit Infra.HorseServer;

interface

uses
  System.SysUtils, Spdc.Router.Auth;

type
  TLogCallBack = reference to procedure(const AMsg : string);

 TServerHorse = class
   class procedure Start(APort: Integer; const AOnLog: TLogCallback = nil);
   class procedure Stop;
 end;

implementation

uses
  Horse,
  Horse.Jhonson,
  Spdc.Router.Usuario;

{ TServerHorse }

class procedure TServerHorse.Start(APort: Integer; const AOnLog: TLogCallback);
begin
  THorse.Use(Jhonson);

  Spdc.Router.Auth.Registry;

  Spdc.Router.Usuario.Registry;

  THorse.Listen(APort,
    procedure
    begin
      if Assigned(AOnLog) then
        AOnLog(FormatDateTime('[hh:nn:ss] ', Now) + 'Servidor Online na porta ' + APort.ToString);
    end);
end;

class procedure TServerHorse.Stop;
begin
    if THorse.IsRunning then begin
      THorse.StopListen;
    end;
end;

end.
