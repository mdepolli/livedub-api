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

    {:ok, user: user}
  end

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

    test "list_jams/0 returns all jams", %{user: user} do
      jam = jam_fixture(users: [user])

      assert Music.list_jams() |> Enum.map(& &1.id) == [jam.id]
    end

    test "get_jam!/1 returns the jam with given id", %{user: user} do
      jam = jam_fixture(users: [user])

      assert Music.get_jam!(jam.id) |> Map.get(:id) == jam.id
    end

    test "create_jam/1 with valid data creates a jam", %{user: user} do
      new_jam = @valid_attrs |> Enum.into(%{users: [user]}) |> Music.create_jam()

      assert {:ok, %Jam{} = jam} = new_jam
      assert jam.title == "some title"
    end

    test "create_jam/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Music.create_jam(@invalid_attrs)
    end

    test "update_jam/2 with valid data updates the jam", %{user: user} do
      jam = jam_fixture(users: [user])

      assert {:ok, jam} = Music.update_jam(jam, @update_attrs)
      assert %Jam{} = jam
      assert jam.title == "some updated title"
    end

    test "update_jam/2 with invalid data returns error changeset", %{user: user} do
      jam = jam_fixture(users: [user])

      assert {:error, %Ecto.Changeset{}} = Music.update_jam(jam, @invalid_attrs)
      assert jam.title == "some title"
    end

    test "delete_jam/1 deletes the jam", %{user: user} do
      jam = jam_fixture(users: [user])

      assert {:ok, %Jam{}} = Music.delete_jam(jam)
      assert_raise Ecto.NoResultsError, fn -> Music.get_jam!(jam.id) end
    end

    test "change_jam/1 returns a jam changeset", %{user: user} do
      jam = jam_fixture(users: [user])

      assert %Ecto.Changeset{} = Music.change_jam(jam)
    end
  end
end
