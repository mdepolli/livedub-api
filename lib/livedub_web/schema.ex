defmodule LivedubWeb.Schema do
  use Absinthe.Schema

  alias LivedubWeb.AccountsResolver

  object :session do
    field(:token, :string)
  end

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
  end

  query do
    field :all_users, list_of(non_null(:user)) do
      resolve(&AccountsResolver.all_users/3)
    end
  end

  mutation do
    field :login, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountsResolver.login/3)
    end

    field :create_user, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountsResolver.create_user/3)
    end
  end
end
