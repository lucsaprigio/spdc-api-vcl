unit Model.DAO.Interfaces;

interface

uses
  Model.Entity.NotasDestinadas,  Model.Entity.NotasDestinadasXML;

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

implementation

end.
