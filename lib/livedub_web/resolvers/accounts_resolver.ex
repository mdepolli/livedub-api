defmodule LivedubWeb.AccountsResolver do
  alias Livedub.{Accounts, Accounts.User, Guardian}

  def sign_up(_root, args, _info) do
    with {:ok, %User{} = user} <- Accounts.create_user(args),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "access") do
      {:ok, %{user: user, access_token: jwt}}
    else
      {:error, changeset} ->
        {:error, message: "Could not create user", details: error_details(changeset)}
    end
  end

  def sign_in(_root, %{email: email, password: password}, _info) do
    with {:ok, %User{} = user} <- Accounts.get_user_and_verify_password(email, password),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(user, %{}, token_type: "access") do
      {:ok, %{user: user, access_token: jwt}}
    else
      {:error, _} ->
        {:error, message: "Email or password not recognized"}
    end
  end

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
