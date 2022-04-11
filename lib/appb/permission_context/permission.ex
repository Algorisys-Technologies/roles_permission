defmodule Appb.PermissionContext.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Appb.AppContext.App
  alias Appb.FeatureContext.Feature
  alias Appb.RoleFeaturePermissionsContext.RoleFeaturePermissions

  schema "permissions" do
    field :name, :string
    # field :app_id, :id
    belongs_to(:apps, App, foreign_key: :app_id)
    # field :feature_id, :id
    belongs_to(:features, Feature, foreign_key: :feature_id)
    has_many(:rolefeaturepermissions, RoleFeaturePermissions, foreign_key: :permission_id)
    timestamps()
  end

  @doc false
  def create_changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name, :app_id, :feature_id])
    |> validate_required([:name, :app_id, :feature_id])
  end

  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
