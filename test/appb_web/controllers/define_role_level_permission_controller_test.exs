defmodule AppbWeb.DefineRoleLevelPermissionControllerTest do
  use AppbWeb.ConnCase

  import Appb.RoleFeaturePermissionsContextFixtures

  @create_attrs %{conditionText: "some conditionText", conditionjson: "some conditionjson"}
  @update_attrs %{conditionText: "some updated conditionText", conditionjson: "some updated conditionjson"}
  @invalid_attrs %{conditionText: nil, conditionjson: nil}

  describe "index" do
    test "lists all rolefeaturepermissions", %{conn: conn} do
      conn = get(conn, Routes.role_feature_permissions_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing rolefeaturepermissions"
    end
  end

  describe "new role_feature_permissions" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.role_feature_permissions_path(conn, :new))
      assert html_response(conn, 200) =~ "New role feature permissions"
    end
  end

  describe "create role_feature_permissions" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.role_feature_permissions_path(conn, :create), role_feature_permissions: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.role_feature_permissions_path(conn, :show, id)

      conn = get(conn, Routes.role_feature_permissions_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show role feature permissions"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.role_feature_permissions_path(conn, :create), role_feature_permissions: @invalid_attrs)
      assert html_response(conn, 200) =~ "New role feature permissions"
    end
  end

  describe "edit role_feature_permissions" do
    setup [:create_role_feature_permissions]

    test "renders form for editing chosen role_feature_permissions", %{conn: conn, role_feature_permissions: role_feature_permissions} do
      conn = get(conn, Routes.role_feature_permissions_path(conn, :edit, role_feature_permissions))
      assert html_response(conn, 200) =~ "Edit role feature permissions"
    end
  end

  describe "update role_feature_permissions" do
    setup [:create_role_feature_permissions]

    test "redirects when data is valid", %{conn: conn, role_feature_permissions: role_feature_permissions} do
      conn = put(conn, Routes.role_feature_permissions_path(conn, :update, role_feature_permissions), role_feature_permissions: @update_attrs)
      assert redirected_to(conn) == Routes.role_feature_permissions_path(conn, :show, role_feature_permissions)

      conn = get(conn, Routes.role_feature_permissions_path(conn, :show, role_feature_permissions))
      assert html_response(conn, 200) =~ "some updated conditionText"
    end

    test "renders errors when data is invalid", %{conn: conn, role_feature_permissions: role_feature_permissions} do
      conn = put(conn, Routes.role_feature_permissions_path(conn, :update, role_feature_permissions), role_feature_permissions: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit role feature permissions"
    end
  end

  describe "delete role_feature_permissions" do
    setup [:create_role_feature_permissions]

    test "deletes chosen role_feature_permissions", %{conn: conn, role_feature_permissions: role_feature_permissions} do
      conn = delete(conn, Routes.role_feature_permissions_path(conn, :delete, role_feature_permissions))
      assert redirected_to(conn) == Routes.role_feature_permissions_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.role_feature_permissions_path(conn, :show, role_feature_permissions))
      end
    end
  end

  defp create_role_feature_permissions(_) do
    role_feature_permissions = role_feature_permissions_fixture()
    %{role_feature_permissions: role_feature_permissions}
  end
end
