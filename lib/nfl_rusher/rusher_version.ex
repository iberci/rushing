defmodule NflRusher.RusherVersion do
  use Ecto.Schema
  import Ecto.Changeset
  alias NflRusher.Rusher

  schema "rusher_versions" do
    has_many :rushers, Rusher
    field :name, :string
    field :started_at, :utc_datetime
    field :completed_at, :utc_datetime
    field :faulted_at, :utc_datetime
    field :faulted_reason, :string
    field :file_sha256, :string
    field :inserted_at, :utc_datetime, null: false
    field :updated_at, :utc_datetime, null: false
    field :import_path, :string
  end

  defp changeset(cs, changes \\ %{}) do
    cs
      |> change(changes)
      |> validate_required([:name, :file_sha256])
      |> put_change(:updated_at, now())
  end

  def changeset_create(cs, attrs) do
    cs
      |> changeset(attrs)
      |> validate_required([:import_path])
      |> put_change(:inserted_at, now())
  end

  def changeset_start(cs) do
    cs
      |> changeset
      |> put_change(:started_at, now())
  end

  def changeset_fault(cs, attrs) do
    cs
      |> changeset
      |> cast(attrs, [:faulted_at, :faulted_reason])
      |> add_faulted_at()
      |> validate_required([:faulted_reason])
  end

  def changeset_complete(cs) do
    cs 
      |> changeset
      |> put_change(:completed_at, now())
      |> put_change(:import_path, nil)
  end

  defp now() do
    DateTime.utc_now()
      |> DateTime.truncate(:second)
  end

  defp add_faulted_at(cs, nil) do
    put_change(cs, :faulted_at, now())
  end

  defp add_faulted_at(cs, _) do
    cs
  end

  defp add_faulted_at(cs) do
    add_faulted_at(cs, get_field(cs, :faulted_at))
  end

end
