unit Lac.Router.NotasSaidas;

interface

uses
  Horse, Lac.Controller.Empresa, Lac.Controller.NFSaida;

procedure Registry;

implementation

procedure Registry;
begin
    THorse.Get('/api/nfe/saida/:businessId/:numero/:serie/:modelo', TLacControllerNFSaida.GetBuscarNFSaida);
    THorse.Get('/api/nfe/saida/:businessId', TLacControllerNFSaida.GetListarNFSaida);
    THorse.Post('/api/nfe/saida', TLacControllerNFSaida.PostSalvarNFSaida);
end;

end.
