defmodule Appb.RoleFeaturePermissionsContextTest do
  use Appb.DataCase

  alias Appb.RoleFeaturePermissionsContext

  describe "rolefeaturepermissions" do
    alias Appb.RoleFeaturePermissionsContext.RoleFeaturePermissions

    import Appb.RoleFeaturePermissionsContextFixtures

    @invalid_attrs %{conditionText: nil, conditionjson: nil}

    test "list_rolefeaturepermissions/0 returns all rolefeaturepermissions" do
      role_feature_permissions = role_feature_permissions_fixture()
      assert RoleFeaturePermissionsContext.list_rolefeaturepermissions() == [role_feature_permissions]
    end

    test "get_role_feature_permissions!/1 returns the role_feature_permissions with given id" do
      role_feature_permissions = role_feature_permissions_fixture()
      assert RoleFeaturePermissionsContext.get_role_feature_permissions!(role_feature_permissions.id) == role_feature_permissions
    end

    test "create_role_feature_permissions/1 with valid data creates a role_feature_permissions" do
      valid_attrs = %{conditionText: "some conditionText", conditionjson: "some conditionjson"}

      assert {:ok, %RoleFeaturePermissions{} = role_feature_permissions} = RoleFeaturePermissionsContext.create_role_feature_permissions(valid_attrs)
      assert role_feature_permissions.conditionText == "some conditionText"
      assert role_feature_permissions.conditionjson == "some conditionjson"
    end

    test "create_role_feature_permissions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RoleFeaturePermissionsContext.create_role_feature_permissions(@invalid_attrs)
    end

    test "update_role_feature_permissions/2 with valid data updates the role_feature_permissions" do
      role_feature_permissions = role_feature_permissions_fixture()
      update_attrs = %{conditionText: "some updated conditionText", conditionjson: "some updated conditionjson"}

      assert {:ok, %RoleFeaturePermissions{} = role_feature_permissions} = RoleFeaturePermissionsContext.update_role_feature_permissions(role_feature_permissions, update_attrs)
      assert role_feature_permissions.conditionText == "some updated conditionText"
      assert role_feature_permissions.conditionjson == "some updated conditionjson"
    end

    test "update_role_feature_permissions/2 with invalid data returns error changeset" do
      role_feature_permissions = role_feature_permissions_fixture()
      assert {:error, %Ecto.Changeset{}} = RoleFeaturePermissionsContext.update_role_feature_permissions(role_feature_permissions, @invalid_attrs)
      assert role_feature_permissions == RoleFeaturePermissionsContext.get_role_feature_permissions!(role_feature_permissions.id)
    end

    test "delete_role_feature_permissions/1 deletes the role_feature_permissions" do
      role_feature_permissions = role_feature_permissions_fixture()
      assert {:ok, %RoleFeaturePermissions{}} = RoleFeaturePermissionsContext.delete_role_feature_permissions(role_feature_permissions)
      assert_raise Ecto.NoResultsError, fn -> RoleFeaturePermissionsContext.get_role_feature_permissions!(role_feature_permissions.id) end
    end

    test "change_role_feature_permissions/1 returns a role_feature_permissions changeset" do
      role_feature_permissions = role_feature_permissions_fixture()
      assert %Ecto.Changeset{} = RoleFeaturePermissionsContext.change_role_feature_permissions(role_feature_permissions)
    end
  end
end
