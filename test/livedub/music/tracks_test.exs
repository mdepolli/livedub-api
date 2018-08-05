defmodule Livedub.MusicTest do
  use Livedub.DataCase

  alias Livedub.{Accounts, Music}

  setup do
    {:ok, user} =
      Accounts.create_user(%{
        email: "peter.potamus@example.com",
        password: "password",
        full_name: "Peter Potamus"
      })

    {:ok, jam} =
      Music.create_jam(%{
        title: "My Jam 1",
        users: [user]
      })

    {:ok, user: user, jam: jam}
  end

  describe "tracks" do
    alias Livedub.Music.Track

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def track_fixture(attrs \\ %{}) do
      {:ok, track} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Music.create_track()

      track
    end

    test "list_tracks/0 returns all tracks", %{user: user, jam: jam} do
      track = track_fixture(%{user_id: user.id, jam_id: jam.id})

      assert Music.list_tracks() == [track]
    end

    test "get_track!/1 returns the track with given id", %{user: user, jam: jam} do
      track = track_fixture(%{user_id: user.id, jam_id: jam.id})
      assert Music.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track", %{user: user, jam: jam} do
      new_track =
        @valid_attrs |> Enum.into(%{user_id: user.id, jam_id: jam.id}) |> Music.create_track()

      assert {:ok, %Track{} = track} = new_track
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track", %{user: user, jam: jam} do
      track = track_fixture(%{user_id: user.id, jam_id: jam.id})

      assert {:ok, track} = Music.update_track(track, @update_attrs)
      assert %Track{} = track
    end

    test "update_track/2 with invalid data returns error changeset", %{user: user, jam: jam} do
      track = track_fixture(%{user_id: user.id, jam_id: jam.id})

      assert {:error, %Ecto.Changeset{}} = Music.update_track(track, @invalid_attrs)
      assert track == Music.get_track!(track.id)
    end

    test "delete_track/1 deletes the track", %{user: user, jam: jam} do
      track = track_fixture(%{user_id: user.id, jam_id: jam.id})

      assert {:ok, %Track{}} = Music.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Music.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset", %{user: user, jam: jam} do
      track = track_fixture(%{user_id: user.id, jam_id: jam.id})

      assert %Ecto.Changeset{} = Music.change_track(track)
    end
  end
end
