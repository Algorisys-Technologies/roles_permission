defmodule Appb.DefineRoleLevelPermissionContextTest do
  use Appb.DataCase

  alias Appb.DefineRoleLevelPermissionContext

  describe "definerolelevelpermissions" do
    alias Appb.DefineRoleLevelPermissionContext.DefineRoleLevelPermission

    import Appb.DefineRoleLevelPermissionContextFixtures

    @invalid_attrs %{conditionText: nil, conditionjson: nil}

    test "list_definerolelevelpermissions/0 returns all definerolelevelpermissions" do
      define_role_level_permission = define_role_level_permission_fixture()
      assert DefineRoleLevelPermissionContext.list_definerolelevelpermissions() == [define_role_level_permission]
    end

    test "get_define_role_level_permission!/1 returns the define_role_level_permission with given id" do
      define_role_level_permission = define_role_level_permission_fixture()
      assert DefineRoleLevelPermissionContext.get_define_role_level_permission!(define_role_level_permission.id) == define_role_level_permission
    end

    test "create_define_role_level_permission/1 with valid data creates a define_role_level_permission" do
      valid_attrs = %{conditionText: "some conditionText", conditionjson: "some conditionjson"}

      assert {:ok, %DefineRoleLevelPermission{} = define_role_level_permission} = DefineRoleLevelPermissionContext.create_define_role_level_permission(valid_attrs)
      assert define_role_level_permission.conditionText == "some conditionText"
      assert define_role_level_permission.conditionjson == "some conditionjson"
    end

    test "create_define_role_level_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DefineRoleLevelPermissionContext.create_define_role_level_permission(@invalid_attrs)
    end

    test "update_define_role_level_permission/2 with valid data updates the define_role_level_permission" do
      define_role_level_permission = define_role_level_permission_fixture()
      update_attrs = %{conditionText: "some updated conditionText", conditionjson: "some updated conditionjson"}

      assert {:ok, %DefineRoleLevelPermission{} = define_role_level_permission} = DefineRoleLevelPermissionContext.update_define_role_level_permission(define_role_level_permission, update_attrs)
      assert define_role_level_permission.conditionText == "some updated conditionText"
      assert define_role_level_permission.conditionjson == "some updated conditionjson"
    end

    test "update_define_role_level_permission/2 with invalid data returns error changeset" do
      define_role_level_permission = define_role_level_permission_fixture()
      assert {:error, %Ecto.Changeset{}} = DefineRoleLevelPermissionContext.update_define_role_level_permission(define_role_level_permission, @invalid_attrs)
      assert define_role_level_permission == DefineRoleLevelPermissionContext.get_define_role_level_permission!(define_role_level_permission.id)
    end

    test "delete_define_role_level_permission/1 deletes the define_role_level_permission" do
      define_role_level_permission = define_role_level_permission_fixture()
      assert {:ok, %DefineRoleLevelPermission{}} = DefineRoleLevelPermissionContext.delete_define_role_level_permission(define_role_level_permission)
      assert_raise Ecto.NoResultsError, fn -> DefineRoleLevelPermissionContext.get_define_role_level_permission!(define_role_level_permission.id) end
    end

    test "change_define_role_level_permission/1 returns a define_role_level_permission changeset" do
      define_role_level_permission = define_role_level_permission_fixture()
      assert %Ecto.Changeset{} = DefineRoleLevelPermissionContext.change_define_role_level_permission(define_role_level_permission)
    end
  end
end
