defmodule SpaceArena.GameHostTest do
  use SpaceArena.ModelCase

  alias SpaceArena.GameHost

  @valid_attrs %{cur_players: 42, ip: "some content", max_players: 42, name: "some content", port: "some content", token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GameHost.changeset(%GameHost{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GameHost.changeset(%GameHost{}, @invalid_attrs)
    refute changeset.valid?
  end
end
