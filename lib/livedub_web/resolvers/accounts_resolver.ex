defmodule LivedubWeb.AccountsResolver do
  alias Livedub.{Accounts, Accounts.User, Guardian}

  ###### PUBLIC RESOLVERS ######

  def sign_up(_root, args, _info) do
    with {:ok, %User{} = user} <- Accounts.create_user(args),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "access") do
      {:ok, %{id: user.id, email: user.email, access_token: jwt}}
    else
      {:error, changeset} ->
        {:error, message: "Could not create user", details: error_details(changeset)}
    end
  end

  def sign_in(_root, %{email: email, password: password}, _info) do
    with {:ok, %User{} = user} <- Accounts.get_user_and_verify_password(email, password),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "access") do
      {:ok, %{id: user.id, email: user.email, access_token: jwt}}
    else
      {:error, changeset} ->
        {:error, message: "Could not log in", details: error_details(changeset)}
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

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
