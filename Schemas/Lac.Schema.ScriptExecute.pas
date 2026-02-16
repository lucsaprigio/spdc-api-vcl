unit Lac.Schema.ScriptExecute;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, Spdc.Infra.Connection, FireDAC.UI.Intf,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Stan.Intf,
  FireDAC.Comp.Script;

type
  TDatabaseSchema = class
    public
      class procedure Execute(const APath: string);
  end;

implementation

{ TDatabaseSchema }

class procedure TDatabaseSchema.Execute(const APath: string);
var
  LScript : TFDScript;
begin

  LScript := TFDScript.Create(nil);
  try
    LScript.Connection := TControllerConection.New.GetConnection;

    LScript.SQLScripts.Clear;
    LScript.SQLScripts.Add.SQL.LoadFromFile(APath);

    LScript.ExecuteAll;
  finally
   LScript.Free;
  end;
end;


end.
