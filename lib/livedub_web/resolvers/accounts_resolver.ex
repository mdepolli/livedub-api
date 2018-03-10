defmodule LivedubWeb.AccountsResolver do
  alias Livedub.{Accounts, Accounts.User, Guardian}

  ###### PUBLIC RESOLVERS ######

  def create_user(_root, args, _info) do
    case Accounts.create_user(args) do
      {:ok, user} ->
        {:ok, user}

      _error ->
        {:error, "Could not create user"}
    end
  end

  def login(_root, %{email: email, password: password}, _info) do
    with {:ok, %User{} = user} <- Livedub.Accounts.get_user_and_verify_password(email, password),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "access") do
      {:ok, %{token: jwt}}
    end
  end

  ###### RESTRICTED RESOLVERS ######

  def all_users(_root, _args, %{context: %{current_user: _current_user}}) do
    users = Accounts.list_users()
    {:ok, users}
  end

  def all_users(_root, _args, _info) do
    {:error, "Unauthorized"}
  end
end
