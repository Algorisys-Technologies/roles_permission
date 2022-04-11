defmodule Appb.RoleContext.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Appb.AppContext.App
  alias Appb.RoleFeaturePermissionsContext.RoleFeaturePermissions

  schema "roles" do
    field :name, :string
    # field :app_id, :id
    belongs_to(:apps, App, foreign_key: :app_id)
    has_many(:rolefeaturepermissions, RoleFeaturePermissions, foreign_key: :role_id)
    timestamps()
  end

  @doc false
  def create_changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :app_id])
    |> validate_required([:name, :app_id])
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
