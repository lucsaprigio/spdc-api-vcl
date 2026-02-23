unit Lac.Services.NotasDestinadas;

interface

uses
  ACBrNFe, pcnRetDistDFeInt, System.SysUtils, Lac.Factory.NFe,
  ACBrDFe.Conversao;
type
  TServiceNotasDestinadas = class
    public
      procedure SincronizarSefaz(const aBusinessId: string; aCnpj: String);
  end;

implementation

{ TServiceNotasDestinadas }

procedure TServiceNotasDestinadas.SincronizarSefaz(const aBusinessId: string; aCnpj: String);
var
  LNFe : TACBrNFe;
  LUltimoNSU : String;
  LItemSefaz : TdocZipCollectionItem;
  I          : Integer ;
begin

   LNFe := TLacFactoryAcbr.New.ConfigurarACBrNFe(aBusinessId);

   try
     LNFe.DistribuicaoDFePorUltNSU(
      LNFe.Configuracoes.WebServices.UFCodigo,
      aCnpj,
      LUltimoNSU
    );

    for I := 0 to LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Count -1 do begin

      LItemSefaz := TdocZipCollectionItem(LNFe.WebServices.DistribuicaoDFe.retDistDFeInt.docZip.Items[I]);

      if  LItemSefaz.schema = schresNFe then
      begin
        // É apenas um RESUMO da nota (A nota existe, mas você ainda não tem os produtos)
        // TLacDAONotasDestinadas.SalvarResumo(ABusinessId, LItemSefaz.NSU, LItemSefaz.XML);
      end
      else if LItemSefaz.schema = schprocNFe then
      begin
        // É o XML COMPLETO da nota (O fornecedor emitiu e você já pode dar entrada)
        // TLacDAONotasDestinadas.SalvarXMLCompleto(ABusinessId, LItemSefaz.NSU, LItemSefaz.XML);
      end
      else if LItemSefaz.schema = schresEvento then
      begin
        // É um EVENTO (Ex: Carta de Correção, Cancelamento da nota pelo fornecedor)
        // TLacDAONotasDestinadas.AtualizarStatusNota(LItemSefaz.NSU, LItemSefaz.XML);
      end
      else if LItemSefaz.schema = schprocEventoNFe then
          // Xml Completo de um Evento
      end;
   finally
     LNFe.Free;
   end;
end;

end.
