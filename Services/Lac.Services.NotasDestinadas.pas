unit Lac.Services.NotasDestinadas;

interface

uses
  ACBrNFe, pcnRetDistDFeInt, System.SysUtils, Lac.Factory.NFe,
  ACBrDFe.Conversao, Spdc.Infra.Connection, Model.Entity.NotasDestinadas,
  Lac.Model.DAO.NotasDestinadas;
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
  LConexao   : IControllerConnection;
  LDAONotasDestinadas :TDAOLacNotasDestinadas;
  LNotasDestinadas    : TNotasDestinadas;
begin

   LNFe := TLacFactoryAcbr.New.ConfigurarACBrNFe(aBusinessId);

   LConexao := TControllerConection.New;
   LConexao.Connect;

   LDAONotasDestinadas := TDAOLacNotasDestinadas.Create(LConexao);
   LNotasDestinadas := TNotasDestinadas.Create;

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
        LNotasDestinadas.ChaveAcesso := LItemSefaz.resDFe.chDFe;
        LNotasDestinadas.CnpjEmit    := LItemSefaz.resDFe.CNPJCPF;
        LNotasDestinadas.NomeEmit    := LItemSefaz.resDFe.xNome;
        LNotasDestinadas.DtEmi       := LItemSefaz.resDFe.dhEmi;
        LNotasDestinadas.VrTot       := LItemSefaz.resDFe.vNF;
        LNotasDestinadas.SitSefaz    := StrToIntDef(SituacaoDFeToStr(LItemSefaz.resDFe.cSitDFe), 0);

        LDAONotasDestinadas.SalvarNotasDestinadas(LNotasDestinadas);
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
     LDAONotasDestinadas.Free;
     LNotasDestinadas.Free;
   end;
end;

end.
