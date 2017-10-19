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
end
