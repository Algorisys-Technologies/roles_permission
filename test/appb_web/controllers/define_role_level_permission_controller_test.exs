defmodule AppbWeb.DefineRoleLevelPermissionControllerTest do
  use AppbWeb.ConnCase

  import Appb.DefineRoleLevelPermissionContextFixtures

  @create_attrs %{conditionText: "some conditionText", conditionjson: "some conditionjson"}
  @update_attrs %{conditionText: "some updated conditionText", conditionjson: "some updated conditionjson"}
  @invalid_attrs %{conditionText: nil, conditionjson: nil}

  describe "index" do
    test "lists all definerolelevelpermissions", %{conn: conn} do
      conn = get(conn, Routes.define_role_level_permission_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Definerolelevelpermissions"
    end
  end

  describe "new define_role_level_permission" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.define_role_level_permission_path(conn, :new))
      assert html_response(conn, 200) =~ "New Define role level permission"
    end
  end

  describe "create define_role_level_permission" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.define_role_level_permission_path(conn, :create), define_role_level_permission: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.define_role_level_permission_path(conn, :show, id)

      conn = get(conn, Routes.define_role_level_permission_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Define role level permission"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.define_role_level_permission_path(conn, :create), define_role_level_permission: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Define role level permission"
    end
  end

  describe "edit define_role_level_permission" do
    setup [:create_define_role_level_permission]

    test "renders form for editing chosen define_role_level_permission", %{conn: conn, define_role_level_permission: define_role_level_permission} do
      conn = get(conn, Routes.define_role_level_permission_path(conn, :edit, define_role_level_permission))
      assert html_response(conn, 200) =~ "Edit Define role level permission"
    end
  end

  describe "update define_role_level_permission" do
    setup [:create_define_role_level_permission]

    test "redirects when data is valid", %{conn: conn, define_role_level_permission: define_role_level_permission} do
      conn = put(conn, Routes.define_role_level_permission_path(conn, :update, define_role_level_permission), define_role_level_permission: @update_attrs)
      assert redirected_to(conn) == Routes.define_role_level_permission_path(conn, :show, define_role_level_permission)

      conn = get(conn, Routes.define_role_level_permission_path(conn, :show, define_role_level_permission))
      assert html_response(conn, 200) =~ "some updated conditionText"
    end

    test "renders errors when data is invalid", %{conn: conn, define_role_level_permission: define_role_level_permission} do
      conn = put(conn, Routes.define_role_level_permission_path(conn, :update, define_role_level_permission), define_role_level_permission: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Define role level permission"
    end
  end

  describe "delete define_role_level_permission" do
    setup [:create_define_role_level_permission]

    test "deletes chosen define_role_level_permission", %{conn: conn, define_role_level_permission: define_role_level_permission} do
      conn = delete(conn, Routes.define_role_level_permission_path(conn, :delete, define_role_level_permission))
      assert redirected_to(conn) == Routes.define_role_level_permission_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.define_role_level_permission_path(conn, :show, define_role_level_permission))
      end
    end
  end

  defp create_define_role_level_permission(_) do
    define_role_level_permission = define_role_level_permission_fixture()
    %{define_role_level_permission: define_role_level_permission}
  end
end
