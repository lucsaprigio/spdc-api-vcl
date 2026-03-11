unit Lac.Services.ExportacaoXML;

interface

type
  iServiceExportacaoXML = interface
     ['{DC5F13F3-09ED-4CE4-B08C-0156D68A8E71}']
     function GerarLoteXML(aBusinessId: string; aDataInicio, aDataFim: TDateTime): string;
  end;

  TServiceExportacao = class(TInterfacedObject, iServiceExportacaoXML)
    public
      constructor Create;
      class function New: iServiceExportacaoXML;

      function GerarLoteXML(aBusinessId: string; aDataInicio, aDataFim: TDateTime): string;
  end;

implementation

{ TServiceExportacao }

constructor TServiceExportacao.Create;
begin

end;

function TServiceExportacao.GerarLoteXML(aBusinessId: string; aDataInicio,
  aDataFim: TDateTime): string;
begin

end;

class function TServiceExportacao.New: iServiceExportacaoXML;
begin

end;

end.
