unit Spdc.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Spdc.Infra.Connection, Horse, Horse.Jhonson, FireDAC.Comp.Client,
  Spdc.Router.Auth, Infra.HorseServer ;

type
  Tfrm_view_principal = class(TForm)
    pnlContainer: TPanel;
    memLog: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  frm_view_principal: Tfrm_view_principal;

implementation

uses
  Spdc.Router.Usuario, Spdc.Utils.Configuracao;

{$R *.dfm}

procedure Tfrm_view_principal.FormCreate(Sender: TObject);
begin

  TSession.LoadJWT;
  TAppConfig.CarregarIni;

  TThread.CreateAnonymousThread(
  procedure
  begin
    TServerHorse.Start(9000,
    procedure(const AMsg : string) begin
      TThread.Synchronize(nil, procedure
      begin
         memLog.Lines.Add(AMsg);
      end);
    end);
  end).Start;
end;

procedure Tfrm_view_principal.FormDestroy(Sender: TObject);
begin
    TServerHorse.Stop;
end;

end.
