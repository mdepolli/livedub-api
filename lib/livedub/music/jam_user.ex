defmodule Livedub.Music.JamUser do
  use Ecto.Schema

  schema "jams_users" do
    belongs_to(:jam, Livedub.Music.Jam)
    belongs_to(:user, Livedub.Accounts.User)
  end
end
