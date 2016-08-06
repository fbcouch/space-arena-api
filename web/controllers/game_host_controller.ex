defmodule SpaceArena.GameHostController do
  use SpaceArena.Web, :controller

  alias SpaceArena.GameHost

  def index(conn, %{"version" => version} = params) do
    game_hosts = GameHost
      |> GameHost.recent
      |> GameHost.with_version(version)
      |> Repo.all
    render(conn, "index.json", game_hosts: game_hosts)
  end

  def index(conn, _params) do
    game_hosts = GameHost
      |> GameHost.recent
      |> Repo.all
    render(conn, "index.json", game_hosts: game_hosts)
  end

  defp token,
    do: :crypto.strong_rand_bytes(64) |> Base.encode64 |> binary_part(0, 64)

  def create(%{req_headers: headers} = conn, %{"game_host" => game_host_params}) do
    {_, forwarded_for} = Enum.find(headers, fn ({key, _}) -> key == "x-forwarded-for" end)
    game_host_params = game_host_params
      |> Dict.put("token", token)
      |> Dict.put("ip", forwarded_for)
    changeset = GameHost.changeset(%GameHost{}, game_host_params)
    IO.inspect(conn)

    case Repo.insert(changeset) do
      {:ok, game_host} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", game_host_path(conn, :show, game_host))
        |> render("create.json", game_host: game_host)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(SpaceArena.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game_host = Repo.get!(GameHost, id)
    render(conn, "show.json", game_host: game_host)
  rescue
    e in Ecto.NoResultsError -> e
      send_resp(conn, :not_found, "")
  end

  def update(conn, %{"id" => id, "game_host" => game_host_params, "token" => token}) do
    game_host = Repo.get!(GameHost, id)
    if token == game_host.token do
      changeset = GameHost.changeset(game_host, game_host_params)

      case Repo.update(changeset) do
        {:ok, game_host} ->
          render(conn, "show.json", game_host: game_host)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(SpaceArena.ChangesetView, "error.json", changeset: changeset)
      end
    else
      send_forbidden(conn)
    end
  rescue
    e in Ecto.NoResultsError -> e
      send_resp(conn, :not_found, "")
  end

  def update(conn, _),
    do: send_forbidden(conn)

  def delete(conn, %{"id" => id, "token" => token}) do
    IO.inspect(conn)
    game_host = Repo.get!(GameHost, id)
    if token == game_host.token do
      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(game_host)

      send_resp(conn, :no_content, "")
    else
      send_forbidden(conn)
    end
  rescue
    e in Ecto.NoResultsError -> e
      send_resp(conn, :not_found, "")
  end

  def delete(conn, _),
    do: send_forbidden(conn)

  defp send_forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{"error": "Token invalid"})
  end
end
