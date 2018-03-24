defmodule LivedubWeb.Schema do
  use Absinthe.Schema

  alias LivedubWeb.{AccountsResolver, MusicResolver}

  object :session do
    field(:user, non_null(:user))
    field(:access_token, non_null(:string))
  end

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
  end

  object :jam do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:users, list_of(non_null(:user)))
  end

  object :track do
    field(:id, non_null(:id))
    field(:user_id, non_null(:integer))
    field(:jam_id, non_null(:integer))
  end

  object :clip do
    field(:id, non_null(:id))
    field(:url, :string)
    field(:start_time, :float)
    field(:duration, :float)
    field(:user_id, non_null(:integer))
    field(:track_id, non_null(:integer))
  end

  query do
    field :all_users, list_of(non_null(:user)) do
      resolve(&AccountsResolver.all_users/3)
    end

    field :all_jams, list_of(:jam) do
      resolve(&MusicResolver.all_jams/3)
    end

    field :all_tracks, list_of(:track) do
      resolve(&MusicResolver.all_tracks/3)
    end

    field :all_clips, list_of(:clip) do
      resolve(&MusicResolver.all_clips/3)
    end
  end

  mutation do
    field :sign_up, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountsResolver.sign_up/3)
    end

    field :sign_in, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountsResolver.sign_in/3)
    end

    field :create_jam, type: :jam do
      arg(:title, non_null(:string))

      resolve(&MusicResolver.create_jam/3)
    end

    field :join_jam, type: :jam do
      arg(:jam_id, non_null(:integer))

      resolve(&MusicResolver.join_jam/3)
    end

    field :create_track, type: :track do
      arg(:jam_id, non_null(:integer))

      resolve(&MusicResolver.create_track/3)
    end

    field :create_clip, type: :clip do
      arg(:track_id, non_null(:integer))
      arg(:url, non_null(:string))
      arg(:start_time, non_null(:float))
      arg(:duration, non_null(:float))

      resolve(&MusicResolver.create_clip/3)
    end
  end
end
