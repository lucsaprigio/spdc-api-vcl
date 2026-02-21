unit Spdc.Controller.Usuario;

interface

uses
  Horse,
  System.JSON,
  Spdc.Model.DAO.Usuario,
  Model.Entity.Usuario,
  REST.JSON, System.Hash, System.SysUtils, Lac.Utils;

type
  TControllerUsuario = class
    public
      class procedure GetUsuarioPorID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure GetUsuarioByEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure PostNewUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure DeleteUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
      class procedure PutUpdateUser(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;
implementation

{ TControllerUsuario }

class procedure TControllerUsuario.GetUsuarioByEmpresa(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  lArray   : TJSONArray;
  lEmpresa : String;
begin
  lEmpresa := Req.Params.Field('id').AsString;
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
  if not TLacUtils.IsValidID(LID) then begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (UUID).');
    Exit;
  end;

  LUser       := TModelUsuario.BuscarPorID(LID);

  if Assigned(LUser) then begin
    Res.Send<TJSONObject>(TJson.ObjectToJsonObject(LUser));
  end
  else begin
    Res.Status(404).Send('Usuário não encontrado');
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

class procedure TControllerUsuario.PutUpdateUser(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  LID, LTempName, LTempEmail         : String;
  LBody       : TJSONObject;
  LUserExists, LCheckEmail : TUser;
begin
  LID := REq.Params.Field('id').AsString;

  if not TLacUtils.IsValidID(LID) then begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (GUID).')
  end;

  LUserExists    := TModelUsuario.BuscarPorID(LID);

  if not assigned(LUserExists) then begin
    Res.Status(404).Send('Usuário não encontrado');
    Exit;
  end;

  try
   LBody := Req.Body<TJSONObject>;

   if Assigned(LBody) then begin
     if LBody.TryGetValue<string>('username', LTempName) then begin
       if LTempName <> LUserExists.Username then begin
        LUserExists.Username := LTempName;
       end;
     end;

     if LBody.TryGetValue<string>('email', LTempEmail) then begin
       if LTempEmail <> LUserExists.Email then begin
       LCheckEmail := TModelUsuario.BuscarPorEmail(LTempEmail);
        if Assigned(LCheckEmail) then begin
          LCheckEmail.Free;
          Res.Status(409).Send('Este e-mail já esta sendo utilizado por outro usuário.');
          Exit;
        end;
       end;

       LUserExists.Email := LTempEmail;
     end;

     TModelUsuario.AtualizarUsuario(LUserExists);

     Res.Status(200).Send('Usuário atualizado com sucesso.');
   end
   else begin
     Res.Status(400).Send('Nenhum dado enviado para atualização.');
   end;
  finally
   LUserExists.Free;
  end;

end;

class procedure TControllerUsuario.DeleteUser(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  LID : String;
  LUser : TUser;
begin
  LID := Req.Params.Field('id').AsString;

  if not TLacUtils.IsValidID(LID) then begin
    Res.Status(400).Send('O ID informado na URL não é um formato válido (GUID).');
    Exit;
  end;

  LUser       := TModelUsuario.BuscarPorID(LID);

  if Assigned(LUser) then begin
   try
     TModelUsuario.ExcluirUsuario(LID);

     Res.Status(200).Send('Usuário Excluído com sucesso.')
   finally
     LUser.Free;
   end;
  end
  else begin
    Res.Status(401).Send('Usuário não encontrado');
  end;
end;

end.
