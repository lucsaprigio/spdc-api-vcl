unit Lac.Database.Migrations;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, Spdc.Infra.Connection;

type
  TDatabaseMigrations = class
    private
      class procedure CriarTabelaBusiness(AQuery : TFDQuery);
      class procedure TB_USER_BUSINESS(AQuery: TFDQuery);
    public
      class procedure Run;
  end;

implementation

{ TDatabaseMigrations }

class procedure TDatabaseMigrations.CriarTabelaBusiness(AQuery: TFDQuery);
begin
    AQuery.SQL.Text :=
      'IF OBJECT_ID(''dbo.TB_BUSINESS'', ''U'') IS NULL ' +
      'BEGIN ' +
      '  CREATE TABLE dbo.TB_BUSINESS ( ' +
      '    BUSINESS_ID UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (NEWID()), ' +
      '    CORPORATE_NAME NVARCHAR(200) NOT NULL, ' +
      '    FANTASY_NAME NVARCHAR(200), ' +
      '    CNPJ VARCHAR(14) NOT NULL UNIQUE, ' +
      '    IE VARCHAR(20), ' +
      '    UF CHAR(2) NOT NULL, ' +
      '    ENVIRONMENT INT DEFAULT 1, ' +
      '    LAST_NSU VARCHAR(20) DEFAULT (''0''), ' +
      '    CERT_BASE64 VARCHAR(MAX), ' +
      '    CERT_PASSWORD VARCHAR(100), ' +
      '    CERT_EXPIRATION DATETIME, ' +
      '    CREATED_AT DATETIME DEFAULT (GETDATE()), ' +
      '    UPDATED_AT DATETIME ' +
      '  ); ' +
      'END;';

      AQuery.ExecSQL;
end;

class procedure TDatabaseMigrations.Run;
var
  LConexao: IControllerConnection;
  LQry: TFDQuery;
begin
  LConexao := TControllerConection.New;
  LQry := TFDQuery.Create(nil);

  try
    LConexao.Connect;
    LQry.Connection := LConexao.GetConnection;

    LQry.ResourceOptions.PreprocessCmdText := False;

    try
      CriarTabelaBusiness(LQry);
      TB_USER_BUSINESS(LQry);
    except
      on E:Exception do

    end;
  finally
    LQry.Free;
  end;

end;

class procedure TDatabaseMigrations.TB_USER_BUSINESS(AQuery: TFDQuery);
begin
  AQuery.SQL.Text :=
    'IF OBJECT_ID(''dbo.TB_USER_BUSINESS'', ''U'') IS NULL ' +
    ' BEGIN '+
    '	CREATE TABLE dbo.TB_USER_BUSINESS ('+
	  ' USERID UNIQUEIDENTIFIER NOT NULL,'+
    '	BUSINESS_ID UNIQUEIDENTIFIER NOT NULL,'+
    '	ROLE_NAME VARCHAR(50) NOT NULL,'+
    '	CREATED_AT DATETIME NOT NULL DEFAULT GETDATE(),'+

    '	PRIMARY KEY (USERID, BUSINESS_ID),'+

    '	CONSTRAINT FK_UB_USER FOREIGN KEY (USERID) REFERENCES dbo.TB_USERS(USERID) ON DELETE CASCADE,'+
    '	CONSTRAINT FK_UB_BUSINESS FOREIGN KEY (BUSINESS_ID) REFERENCES dbo.TB_BUSINESS(BUSINESS_ID) ON DELETE CASCADE'+
    '	); '+
    ' END;';

    AQuery.ExecSQL;
end;

end.
