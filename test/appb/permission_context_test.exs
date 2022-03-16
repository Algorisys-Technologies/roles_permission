defmodule Appb.PermissionContextTest do
  use Appb.DataCase

  alias Appb.PermissionContext

  describe "permissions" do
    alias Appb.PermissionContext.Permission

    import Appb.PermissionContextFixtures

    @invalid_attrs %{name: nil}

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert PermissionContext.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert PermissionContext.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Permission{} = permission} = PermissionContext.create_permission(valid_attrs)
      assert permission.name == "some name"
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PermissionContext.create_permission(@invalid_attrs)
    end

    test "update_permission/2 with valid data updates the permission" do
      permission = permission_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Permission{} = permission} = PermissionContext.update_permission(permission, update_attrs)
      assert permission.name == "some updated name"
    end

    test "update_permission/2 with invalid data returns error changeset" do
      permission = permission_fixture()
      assert {:error, %Ecto.Changeset{}} = PermissionContext.update_permission(permission, @invalid_attrs)
      assert permission == PermissionContext.get_permission!(permission.id)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = PermissionContext.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> PermissionContext.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = PermissionContext.change_permission(permission)
    end
  end
end
