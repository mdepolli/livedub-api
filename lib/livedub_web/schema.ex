defmodule LivedubWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Ecto, repo: Livedub.Repo

  alias LivedubWeb.{AccountsResolver, MusicResolver}

  import_types(Absinthe.Type.Custom)

  object :session do
    field(:user, non_null(:user))
    field(:access_token, non_null(:string))
  end

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
    field(:full_name, non_null(:string))
  end

  object :jam do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:users, list_of(non_null(:user)), resolve: assoc(:users))
    field(:tracks, list_of(non_null(:track)), resolve: assoc(:tracks))
  end

  object :track do
    field(:id, non_null(:id))
    field(:user_id, non_null(:id))
    field(:jam_id, non_null(:id))
    field(:clips, list_of(non_null(:clip)), resolve: assoc(:clips))
  end

  object :clip do
    field(:id, non_null(:id))
    field(:url, non_null(:string))
    field(:start_time, non_null(:float))
    field(:duration, non_null(:float))
    field(:user_id, non_null(:id))
    field(:track_id, non_null(:id))
    field(:inserted_at, non_null(:datetime))
  end

  query do
    field :all_jams, list_of(non_null(:jam)) do
      middleware(LivedubWeb.Middleware.Auth)
      resolve(&MusicResolver.all_jams/3)
    end

    field :get_jam, :jam do
      arg(:jam_id, non_null(:id))

      middleware(LivedubWeb.Middleware.Auth)
      resolve(&MusicResolver.get_jam/3)
    end

    field :all_tracks, list_of(non_null(:track)) do
      middleware(LivedubWeb.Middleware.Auth)
      resolve(&MusicResolver.all_tracks/3)
    end

    field :all_clips, list_of(non_null(:clip)) do
      middleware(LivedubWeb.Middleware.Auth)
      resolve(&MusicResolver.all_clips/3)
    end
  end

  mutation do
    # Unrestricted mutation
    field :sign_up, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountsResolver.sign_up/3)
    end

    # Unrestricted mutation
    field :sign_in, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountsResolver.sign_in/3)
    end

    field :create_jam, type: :jam do
      arg(:title, non_null(:string))

      middleware(LivedubWeb.Middleware.Auth)
      resolve(&MusicResolver.create_jam/3)
    end

    field :join_jam, type: :jam do
      arg(:jam_id, non_null(:id))

      middleware(LivedubWeb.Middleware.Auth)
      resolve(&MusicResolver.join_jam/3)
    end

    field :create_track, type: :track do
      arg(:jam_id, non_null(:id))

      middleware(LivedubWeb.Middleware.Auth)
      resolve(&MusicResolver.create_track/3)
    end

    field :create_clip, type: :clip do
      arg(:track_id, non_null(:id))
      arg(:url, non_null(:string))
      arg(:start_time, non_null(:float))
      arg(:duration, non_null(:float))

      middleware(LivedubWeb.Middleware.Auth)
      resolve(&MusicResolver.create_clip/3)
    end
  end
end
