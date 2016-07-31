defmodule SpaceArena.GameHost do
  use SpaceArena.Web, :model

  schema "game_hosts" do
    field :name, :string
    field :ip, :string
    field :port, :string
    field :cur_players, :integer
    field :max_players, :integer
    field :version, :string
    field :token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :ip, :port, :cur_players, :max_players, :version, :token])
    |> validate_required([:name, :ip, :port, :cur_players, :max_players, :version, :token])
  end
end