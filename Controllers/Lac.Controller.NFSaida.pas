unit Lac.Controller.NFSaida;

interface

uses
  Horse, System.JSON;

type
  TLacControllerNFSaida = class
    class procedure PostSalvarNFSaida(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetBuscarNFSaida(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    class procedure GetListarNFSaida(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

{ TLacControllerNFSaida }

class procedure TLacControllerNFSaida.GetListarNFSaida(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
begin

end;

class procedure TLacControllerNFSaida.PostSalvarNFSaida(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
begin

end;

class procedure TLacControllerNFSaida.GetBuscarNFSaida(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
begin

end;

end.
