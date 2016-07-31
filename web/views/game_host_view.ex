defmodule SpaceArena.GameHostView do
  use SpaceArena.Web, :view

  def render("index.json", %{game_hosts: game_hosts}) do
    render_many(game_hosts, SpaceArena.GameHostView, "game_host.json")
  end

  def render("show.json", %{game_host: game_host}) do
    render_one(game_host, SpaceArena.GameHostView, "game_host.json")
  end

  def render("create.json", %{game_host: game_host}) do
    render_one(game_host, SpaceArena.GameHostView, "game_host_with_token.json")
  end

  def render("game_host.json", %{game_host: game_host}) do
    %{id: game_host.id,
      name: game_host.name,
      ip: game_host.ip,
      port: game_host.port,
      cur_players: game_host.cur_players,
      max_players: game_host.max_players}
  end

  def render("game_host_with_token.json", %{game_host: game_host}) do
    %{id: game_host.id,
      name: game_host.name,
      ip: game_host.ip,
      port: game_host.port,
      cur_players: game_host.cur_players,
      max_players: game_host.max_players,
      token: game_host.token}
  end
end
