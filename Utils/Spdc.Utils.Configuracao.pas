unit Spdc.Utils.Configuracao;

interface

uses
  System.IOUtils,
  System.SysUtils,
  System.IniFiles;

type
  TSession = class
  private
    class var FJWT_SECRET: String;
  public
    class procedure LoadJWT;

    class property JWT_SECRET: String read FJWT_SECRET write FJWT_SECRET;
  end;

  TAppConfig = class
  private
    class var FServer: String;
    class var FPort: String;
    class var FDBSpdc: String;
    class var FDBXml: String;
    class var FDBUser: String;
    class var FDBPassword: String;
    
    class var FServerXml: String;
    class var FPortXml: String;
    class var FDBUserXml: String;
    class var FDBPasswordXml: String;
  public
    class procedure CarregarIni;

    // Informações do Banco Spdc (Login e Usuário; Informações das Notas Fiscais)
    class property Server: string read FServer;
    class property Port: string read FPort;
    class property DBSpdc: string read FDBSpdc;
    class property DBUser: string read FDBUser;
    class property DBPassword: string read FDBPassword;

    // Banco onde está os Xml salvos das empresas.
    class property DBXml: string read FDBXml;
    class property ServerXml: String read FServerXml write FServerXml;
    class property PortXml: String read FPortXml write FPortXml;
    class property DBUserXml: String read FDBUserXml write FDBUserXml;
    class property DBPasswordXml: String read FDBPasswordXml write FDBPasswordXml;
  end;

implementation

{ TAppConfig }

class procedure TAppConfig.CarregarIni;
var
  LArquivoINI : TIniFile;
  LCaminhoINI : String;
begin
  // C:\MeuApp\config.Ini -> Facilitanto caso for para um Linux.
  LCaminhoINI := TPath.Combine(ExtractFilePath(ParamStr(0)), 'config.ini');

  if not FileExists(LCaminhoINI) then begin
       LArquivoINI := TIniFile.Create(LCaminhoINI);

       try
         LArquivoINI.WriteString('BancoSpdc', 'Server', '127.0.0.1');
         LArquivoINI.WriteString('BancoSpdc', 'Port', '3050');
         LArquivoINI.WriteString('BancoSpdc', 'Database', '');
         LArquivoINI.WriteString('BancoSpdc', 'User', 'SYSDBA');
         LArquivoINI.WriteString('BancoSpdc', 'Password', 'masterkey');

         LArquivoINI.WriteString('BancoXml', 'DatabaseXml', '');
       finally
        LArquivoINI.Free;
       end;
  end;


  LArquivoINI := TIniFile.Create(LCaminhoINI);

  try
    FServer     := LArquivoINI.ReadString('BancoSpdc', 'Server', '127.0.0.1');
    FPort       := LArquivoINI.ReadString('BancoSpdc', 'Port', '3050');
    FDBSpdc     := LArquivoINI.ReadString('BancoSpdc', 'Database', '');
    FDBUser     := LArquivoINI.ReadString('BancoSpdc', 'User', 'SYSDBA');
    FDBPassword := LArquivoINI.ReadString('BancoSpdc', 'Password', 'masterkey');

    FServerXml     := LArquivoINI.ReadString('BancoSpdc', 'ServerXml', '127.0.0.1');
    FDBXml         := LArquivoINI.ReadString('BancoXml', 'DatabaseXml', '');
    FPortXml       := LArquivoINI.ReadString('BancoXml', 'PortXml', '3050');
    FDBUserXml     := LArquivoINI.ReadString('BancoXml', 'UserXml', 'sysdba');
    FDBPasswordXml := LArquivoINI.ReadString('BancoXml', 'PasswordXml', 'masterkey');

  finally
    LArquivoINI.Free;
  end;

end;

{ TSession }

class procedure TSession.LoadJWT;
var
  LArquivoINI : TIniFile;
  LCaminhoINI : String;
begin
  // Vou usar ini por enquanto
  LCaminhoINI := TPath.Combine(ExtractFilePath(ParamStr(0)), 'jwt.ini');

  if not FileExists(LCaminhoINI) then begin
  LArquivoINI := TIniFile.Create(LCaminhoINI);
    try
     LArquivoINI.WriteString('Auth', 'JWT', '');
    finally
     LArquivoINI.Free;
    end;
  end;
  LArquivoINI := TIniFile.Create(LCaminhoINI);

  try
   FJWT_SECRET := LArquivoINI.ReadString('Auth', 'JWT', '');
  finally
    LArquivoINI.Free;
  end;
end;

end.
