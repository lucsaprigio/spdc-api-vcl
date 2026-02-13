unit Spdc.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Spdc.Controller.Connection, Horse, Horse.Jhonson;

type
  Tfrm_view_principal = class(TForm)
    pnlContainer: TPanel;
    memLog: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    procedure StartServer;
  public
    { Public declarations }
  end;

var
  frm_view_principal: Tfrm_view_principal;

implementation

uses
  FireDAC.Comp.Client, Spdc.Router.Usuario;

{$R *.dfm}

procedure Tfrm_view_principal.FormCreate(Sender: TObject);
begin
  Spdc.Router.Usuario.Registry;

  TThread.CreateAnonymousThread(
    procedure
    begin
      StartServer;
    end).Start;
end;

procedure Tfrm_view_principal.StartServer;
begin
try
    THorse.Use(Jhonson);
    THorse.Listen(9000,
      procedure
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            memLog.Lines.Add(FormatDateTime('[hh:nn:ss] ', Now) +
              'Servidor Online na porta 9000');
          end);
      end);

  except
    on E: Exception do
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          memLog.Lines.Add('Erro ao iniciar: ' + E.Message);
        end);
    end;
  end;
end;

end.
