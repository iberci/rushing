defmodule NflRusher.RusherVersion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rusher_versions" do
    has_many :rushers, Rusher
    field :name, :string
    field :started_at, :utc_datetime
    field :completed_at, :utc_datetime
    field :faulted_at, :utc_datetime
    field :faulted_reason, :string
    field :file_sha256, :string
  end

  def changeset_start(attrs) do
    cs = %{}
      |> cast(attrs, [:name, :started_at, :file_sha256])
      |> validate_required([:name, :file_sha256])

    cs = case get_field(cs, :started_at) do
      nil ->
        {:ok, now} = DateTime.now("Etc/UTC")
        put_change(cs, :started_at, now)
      _ ->
        cs
    end

    cs
  end
 
  def changeset_fault(version, attrs) do
    cs = attrs
      |> cast(attrs, [:faulted_at, :faulted_reason])
      |> validate_required([:faulted_reason])

    cs = case get_field(cs, :faulted_at) do
      nil ->
        {:ok, now} = DateTime.now("Etc/UTC")
        put_change(cs, :faulted_at, now)
      _ ->
        cs

      cs
    end
  end

  def changeset_complete(version, attrs) do
    attrs
      |> cast(attrs, [:completed_at])
      |> validate_required([:completed_at])
  end
end
