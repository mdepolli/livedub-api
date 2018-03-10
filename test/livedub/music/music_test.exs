defmodule Livedub.MusicTest do
  use Livedub.DataCase

  alias Livedub.Music

  describe "jams" do
    alias Livedub.Music.Jam

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def jam_fixture(attrs \\ %{}) do
      {:ok, jam} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Music.create_jam()

      jam
    end

    test "list_jams/0 returns all jams" do
      jam = jam_fixture()
      assert Music.list_jams() == [jam]
    end

    test "get_jam!/1 returns the jam with given id" do
      jam = jam_fixture()
      assert Music.get_jam!(jam.id) == jam
    end

    test "create_jam/1 with valid data creates a jam" do
      assert {:ok, %Jam{} = jam} = Music.create_jam(@valid_attrs)
      assert jam.title == "some title"
    end

    test "create_jam/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_jam(@invalid_attrs)
    end

    test "update_jam/2 with valid data updates the jam" do
      jam = jam_fixture()
      assert {:ok, jam} = Music.update_jam(jam, @update_attrs)
      assert %Jam{} = jam
      assert jam.title == "some updated title"
    end

    test "update_jam/2 with invalid data returns error changeset" do
      jam = jam_fixture()
      assert {:error, %Ecto.Changeset{}} = Music.update_jam(jam, @invalid_attrs)
      assert jam == Music.get_jam!(jam.id)
    end

    test "delete_jam/1 deletes the jam" do
      jam = jam_fixture()
      assert {:ok, %Jam{}} = Music.delete_jam(jam)
      assert_raise Ecto.NoResultsError, fn -> Music.get_jam!(jam.id) end
    end

    test "change_jam/1 returns a jam changeset" do
      jam = jam_fixture()
      assert %Ecto.Changeset{} = Music.change_jam(jam)
    end
  end

  describe "clips" do
    alias Livedub.Music.Clip

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def clip_fixture(attrs \\ %{}) do
      {:ok, clip} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Music.create_clip()

      clip
    end

    test "list_clips/0 returns all clips" do
      clip = clip_fixture()
      assert Music.list_clips() == [clip]
    end

    test "get_clip!/1 returns the clip with given id" do
      clip = clip_fixture()
      assert Music.get_clip!(clip.id) == clip
    end

    test "create_clip/1 with valid data creates a clip" do
      assert {:ok, %Clip{} = clip} = Music.create_clip(@valid_attrs)
      assert clip.url == "some url"
    end

    test "create_clip/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_clip(@invalid_attrs)
    end

    test "update_clip/2 with valid data updates the clip" do
      clip = clip_fixture()
      assert {:ok, clip} = Music.update_clip(clip, @update_attrs)
      assert %Clip{} = clip
      assert clip.url == "some updated url"
    end

    test "update_clip/2 with invalid data returns error changeset" do
      clip = clip_fixture()
      assert {:error, %Ecto.Changeset{}} = Music.update_clip(clip, @invalid_attrs)
      assert clip == Music.get_clip!(clip.id)
    end

    test "delete_clip/1 deletes the clip" do
      clip = clip_fixture()
      assert {:ok, %Clip{}} = Music.delete_clip(clip)
      assert_raise Ecto.NoResultsError, fn -> Music.get_clip!(clip.id) end
    end

    test "change_clip/1 returns a clip changeset" do
      clip = clip_fixture()
      assert %Ecto.Changeset{} = Music.change_clip(clip)
    end
  end

  describe "tracks" do
    alias Livedub.Music.Track

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def track_fixture(attrs \\ %{}) do
      {:ok, track} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Music.create_track()

      track
    end

    test "list_tracks/0 returns all tracks" do
      track = track_fixture()
      assert Music.list_tracks() == [track]
    end

    test "get_track!/1 returns the track with given id" do
      track = track_fixture()
      assert Music.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track" do
      assert {:ok, %Track{} = track} = Music.create_track(@valid_attrs)
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      track = track_fixture()
      assert {:ok, track} = Music.update_track(track, @update_attrs)
      assert %Track{} = track
    end

    test "update_track/2 with invalid data returns error changeset" do
      track = track_fixture()
      assert {:error, %Ecto.Changeset{}} = Music.update_track(track, @invalid_attrs)
      assert track == Music.get_track!(track.id)
    end

    test "delete_track/1 deletes the track" do
      track = track_fixture()
      assert {:ok, %Track{}} = Music.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Music.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset" do
      track = track_fixture()
      assert %Ecto.Changeset{} = Music.change_track(track)
    end
  end
end
