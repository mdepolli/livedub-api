defmodule LivedubWeb.ClipControllerTest do
  use LivedubWeb.ConnCase

  alias Livedub.Music
  alias Livedub.Music.Clip

  @create_attrs %{url: "some url"}
  @update_attrs %{url: "some updated url"}
  @invalid_attrs %{url: nil}

  def fixture(:clip) do
    {:ok, clip} = Music.create_clip(@create_attrs)
    clip
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clips", %{conn: conn} do
      conn = get conn, clip_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clip" do
    test "renders clip when data is valid", %{conn: conn} do
      conn = post conn, clip_path(conn, :create), clip: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, clip_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "url" => "some url"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, clip_path(conn, :create), clip: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clip" do
    setup [:create_clip]

    test "renders clip when data is valid", %{conn: conn, clip: %Clip{id: id} = clip} do
      conn = put conn, clip_path(conn, :update, clip), clip: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, clip_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "url" => "some updated url"}
    end

    test "renders errors when data is invalid", %{conn: conn, clip: clip} do
      conn = put conn, clip_path(conn, :update, clip), clip: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clip" do
    setup [:create_clip]

    test "deletes chosen clip", %{conn: conn, clip: clip} do
      conn = delete conn, clip_path(conn, :delete, clip)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, clip_path(conn, :show, clip)
      end
    end
  end

  defp create_clip(_) do
    clip = fixture(:clip)
    {:ok, clip: clip}
  end
end
