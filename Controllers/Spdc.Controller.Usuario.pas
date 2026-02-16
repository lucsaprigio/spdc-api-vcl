unit Spdc.Controller.Usuario;

interface

uses
  Horse,
  System.JSON,
  Spdc.Model.DAO.Usuario,
  Model.Entity.Usuario,
  REST.JSON, System.Hash, System.SysUtils;

type
  TControllerUsuario = class
    public
      class procedure GetUsuarioPorID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure GetUsuarioByEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure PostNewUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;
implementation

{ TControllerUsuario }

class procedure TControllerUsuario.GetUsuarioByEmpresa(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lArray   : TJSONArray;
  lEmpresa : Integer;
begin
  lEmpresa := Req.Params.Field('id').AsInteger;
  lArray   := TModelUsuario.ListarPorEmpresa(lEmpresa);

  if Assigned(lArray) then begin
    Res.Send<TJSONArray>(lArray);
  end;
end;

class procedure TControllerUsuario.GetUsuarioPorID(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  LID            : String;
  LUser          : TUser;
  LGUIDValidacao : TGUID;
begin
  LID := Req.Params.Field('id').AsString;

  // Validando o tipo GUID para não retornar o erro 500 de internal erro
  try
    LGUIDValidacao := StringToGUID('{' + LID + '}');
  except
    Res.Status(400).Send('O ID informado na URL não é um formato válido (UUID).');
    Exit;
  end;

  LUser       := TModelUsuario.BuscarPorID(LID);

  if Assigned(LUser) then begin
    Res.Send<TJSONObject>(TJson.ObjectToJsonObject(LUser));
  end
  else begin
    Res.Status(404).Send('Cliente não encontrado');
  end;
end;

class procedure TControllerUsuario.PostNewUser(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LUser, LUserExists : TUser;
  LBodyPassword : String;
begin
   LBody := Req.Body<TJSONObject>;

   if not Assigned(LBody) then begin
     Res.Status(400).Send('Corpo da Requisição Inválido');
     Exit;
   end;

   LUser := TUser.Create;
   try
      LUser.Username  := LBody.GetValue<String>('username');
      LUser.Email     := LBody.GetValue<String>('email');

      LUserExists := TModelUsuario.BuscarPorEmail(LUser.Email);

      if Assigned(LUserExists) then begin
        LUserExists.Free;
        Res.Status(409).Send('E-mail já está em uso');
        Exit;
      end;


      // Pegando a Senha Normal
      LBodyPassword       := LBody.GetValue<String>('password');

      // Hasheando a senha
      LUser.Password  := THashSHA2.GetHashString(LBodyPassword);

      TModelUsuario.CriarUsuario(LUser);

      Res.Status(201).Send('Usuário criado com sucesso');

   finally
     LUser.Free;
   end;
end;

end.
