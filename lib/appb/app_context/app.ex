defmodule Appb.AppContext.App do
  use Ecto.Schema
  import Ecto.Changeset
  alias Appb.Accounts.User
  alias Appb.FeatureContext.Feature
  alias Appb.RoleContext.Role
  alias Appb.PermissionContext.Permission
  alias Appb.RoleFeaturePermissionsContext.RoleFeaturePermissions

  schema "apps" do
    field :name, :string
    # field :user_id, :id
    belongs_to(:users, User, foreign_key: :user_id)

    has_many(:features, Feature, foreign_key: :app_id)
    has_many(:roles, Role, foreign_key: :app_id)
    has_many(:permissions, Permission, foreign_key: :app_id)
    has_many(:rolefeaturepermissions, RoleFeaturePermissions, foreign_key: :app_id)
    timestamps()
  end

  def create_changeset(app, attrs) do
    app
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end

  @doc false
  def changeset(app, attrs) do
    app
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
