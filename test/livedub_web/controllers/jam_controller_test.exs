defmodule LivedubWeb.JamControllerTest do
  use LivedubWeb.ConnCase

  alias Livedub.Music
  alias Livedub.Music.Jam

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  def fixture(:jam) do
    {:ok, jam} = Music.create_jam(@create_attrs)
    jam
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all jams", %{conn: conn} do
      conn = get(conn, jam_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create jam" do
    test "renders jam when data is valid", %{conn: conn} do
      conn = post(conn, jam_path(conn, :create), jam: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, jam_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "title" => "some title"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, jam_path(conn, :create), jam: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update jam" do
    setup [:create_jam]

    test "renders jam when data is valid", %{
      conn: conn,
      jam: %Jam{id: id} = jam
    } do
      conn = put(conn, jam_path(conn, :update, jam), jam: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, jam_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "title" => "some updated title"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, jam: jam} do
      conn = put(conn, jam_path(conn, :update, jam), jam: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete jam" do
    setup [:create_jam]

    test "deletes chosen jam", %{conn: conn, jam: jam} do
      conn = delete(conn, jam_path(conn, :delete, jam))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, jam_path(conn, :show, jam))
      end)
    end
  end

  defp create_jam(_) do
    jam = fixture(:jam)
    {:ok, jam: jam}
  end
end
