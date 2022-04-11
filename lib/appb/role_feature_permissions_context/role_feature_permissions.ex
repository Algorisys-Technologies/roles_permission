defmodule Appb.RoleFeaturePermissionsContext.RoleFeaturePermissions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rolefeaturepermissions" do
    field :conditionText, :string
    field :conditionjson, :map, default: %{}
    # field :app_id, :id
    belongs_to(:users, Appb.Accounts.User, foreign_key: :app_id)
    # field :feature_id, :id
    belongs_to(:features, Appb.FeatureContext.Feature, foreign_key: :feature_id)
    # field :permission_id, :id
    belongs_to(:permissions, Appb.PermissionContext.Permission, foreign_key: :permission_id)
    # field :role_id, :id
    belongs_to(:roles, Appb.RoleContext.Role, foreign_key: :role_id)

    timestamps()
  end

  @doc false
  def changeset(role_feature_permissions, attrs) do
    role_feature_permissions
    |> cast(attrs, [
      :conditionText,
      :conditionjson,
      :app_id,
      :feature_id,
      :role_id,
      :permission_id
    ])
    |> validate_required([
      :app_id,
      :feature_id,
      :role_id,
      :permission_id
    ])
  end
end
