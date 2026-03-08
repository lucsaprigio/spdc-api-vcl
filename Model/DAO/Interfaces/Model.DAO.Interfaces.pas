unit Model.DAO.Interfaces;

interface

uses
  Model.Entity.NotasDestinadas,  Model.Entity.NotasDestinadasXML, Model.Entity.NFSaida;

type
  IDAONotasDestinadas = interface
    ['{B08F3F7E-C233-41BE-8BCC-93AE65DD1030}']
    procedure SalvarNotasDestinadas(ANotaDestinada: TNotasDestinadas);
    procedure AtualizarStatus(AId: String; ANovoStatus: Integer);
  end;

  IDAONotasDestinadasXML = interface
    ['{C2BD9D54-E1B5-4C47-8460-42C8D458554B}']
    procedure SalvarXML(aNotaDestinadaXML : TNotasDestinadasXML);
  end;

  IDAONFSaida = interface
    ['{60A1512F-D596-41C6-8482-CAAE8A915676}']
    procedure SalvarNFSaida(aNF : TNotasSaida);
    function  BuscarNFSaida(aBusinessId, aNumero, aSerie, aModelo, aCpfCnpj: String) : TNotasSaida;
    function ListarNFSaida(aBusinessId : String; aNumero: String = '';
                            aSerie :String = ''; aModelo: String = '';
                            aCpfCnpj : String = '') : TArray<TNotasSaida>;
  end;

implementation

end.
