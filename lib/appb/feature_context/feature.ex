defmodule Appb.FeatureContext.Feature do
  use Ecto.Schema
  import Ecto.Changeset
  alias Appb.AppContext.App
  alias Appb.PermissionContext.Permission
  alias Appb.RoleFeaturePermissionsContext.RoleFeaturePermissions

  schema "features" do
    field :name, :string
    # field :app_id, :id
    belongs_to(:apps, App, foreign_key: :app_id)
    has_many(:permissions, Permission, foreign_key: :feature_id)
    has_many(:rolefeaturepermissions, RoleFeaturePermissions, foreign_key: :feature_id)
    timestamps()
  end

  def create_changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :app_id])
    |> validate_required([:name, :app_id])
  end

  @doc false
  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
