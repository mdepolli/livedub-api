defmodule Livedub.ClipsTest do
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

    {:ok, track} =
      Music.create_track(%{
        user_id: user.id,
        jam_id: jam.id,
        title: "My Track 1",
        volume: 70
      })

    {:ok, user: user, jam: jam, track: track}
  end

  describe "clips" do
    alias Livedub.Music.Clip

    @valid_attrs %{
      url: "some url",
      start_time: 0.0,
      duration: 15.0,
      recorded_at: "2018-03-30T12:30:00.000000Z"
    }
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def clip_fixture(attrs \\ %{}) do
      {:ok, clip} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Music.create_clip()

      clip
    end

    test "list_clips/0 returns all clips", %{track: track} do
      clip = clip_fixture(%{track_id: track.id})

      assert Music.list_clips() == [clip]
    end

    test "get_clip!/1 returns the clip with given id", %{track: track} do
      clip = clip_fixture(%{track_id: track.id})

      assert Music.get_clip!(clip.id) == clip
    end

    test "create_clip/1 with valid data creates a clip", %{track: track} do
      new_clip = @valid_attrs |> Enum.into(%{track_id: track.id}) |> Music.create_clip()

      assert {:ok, %Clip{} = clip} = new_clip
      assert clip.url == "some url"
    end

    test "create_clip/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_clip(@invalid_attrs)
    end

    test "update_clip/2 with valid data updates the clip", %{track: track} do
      clip = clip_fixture(%{track_id: track.id})

      assert {:ok, clip} = Music.update_clip(clip, @update_attrs)
      assert %Clip{} = clip
      assert clip.url == "some updated url"
    end

    test "update_clip/2 with invalid data returns error changeset", %{track: track} do
      clip = clip_fixture(%{track_id: track.id})

      assert {:error, %Ecto.Changeset{}} = Music.update_clip(clip, @invalid_attrs)
      assert clip == Music.get_clip!(clip.id)
    end

    test "delete_clip/1 deletes the clip", %{track: track} do
      clip = clip_fixture(%{track_id: track.id})

      assert {:ok, %Clip{}} = Music.delete_clip(clip)
      assert_raise Ecto.NoResultsError, fn -> Music.get_clip!(clip.id) end
    end

    test "change_clip/1 returns a clip changeset", %{track: track} do
      clip = clip_fixture(%{track_id: track.id})

      assert %Ecto.Changeset{} = Music.change_clip(clip)
    end
  end
end
