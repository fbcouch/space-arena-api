defmodule SpaceArena.GameHostControllerTest do
  use SpaceArena.ConnCase

  alias SpaceArena.GameHost
  @valid_attrs %{cur_players: 42, ip: "some content", max_players: 42, name: "some content", port: "some content", token: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, game_host_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    game_host = Repo.insert! %GameHost{}
    conn = get conn, game_host_path(conn, :show, game_host)
    assert json_response(conn, 200)["data"] == %{"id" => game_host.id,
      "name" => game_host.name,
      "ip" => game_host.ip,
      "port" => game_host.port,
      "cur_players" => game_host.cur_players,
      "max_players" => game_host.max_players,
      "token" => game_host.token}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, game_host_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, game_host_path(conn, :create), game_host: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GameHost, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, game_host_path(conn, :create), game_host: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    game_host = Repo.insert! %GameHost{}
    conn = put conn, game_host_path(conn, :update, game_host), game_host: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GameHost, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    game_host = Repo.insert! %GameHost{}
    conn = put conn, game_host_path(conn, :update, game_host), game_host: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    game_host = Repo.insert! %GameHost{}
    conn = delete conn, game_host_path(conn, :delete, game_host)
    assert response(conn, 204)
    refute Repo.get(GameHost, game_host.id)
  end
end
