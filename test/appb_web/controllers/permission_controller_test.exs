defmodule AppbWeb.PermissionControllerTest do
  use AppbWeb.ConnCase

  import Appb.PermissionContextFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all permissions", %{conn: conn} do
      conn = get(conn, Routes.permission_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Permissions"
    end
  end

  describe "new permission" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.permission_path(conn, :new))
      assert html_response(conn, 200) =~ "New Permission"
    end
  end

  describe "create permission" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.permission_path(conn, :create), permission: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.permission_path(conn, :show, id)

      conn = get(conn, Routes.permission_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Permission"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.permission_path(conn, :create), permission: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Permission"
    end
  end

  describe "edit permission" do
    setup [:create_permission]

    test "renders form for editing chosen permission", %{conn: conn, permission: permission} do
      conn = get(conn, Routes.permission_path(conn, :edit, permission))
      assert html_response(conn, 200) =~ "Edit Permission"
    end
  end

  describe "update permission" do
    setup [:create_permission]

    test "redirects when data is valid", %{conn: conn, permission: permission} do
      conn = put(conn, Routes.permission_path(conn, :update, permission), permission: @update_attrs)
      assert redirected_to(conn) == Routes.permission_path(conn, :show, permission)

      conn = get(conn, Routes.permission_path(conn, :show, permission))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, permission: permission} do
      conn = put(conn, Routes.permission_path(conn, :update, permission), permission: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Permission"
    end
  end

  describe "delete permission" do
    setup [:create_permission]

    test "deletes chosen permission", %{conn: conn, permission: permission} do
      conn = delete(conn, Routes.permission_path(conn, :delete, permission))
      assert redirected_to(conn) == Routes.permission_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.permission_path(conn, :show, permission))
      end
    end
  end

  defp create_permission(_) do
    permission = permission_fixture()
    %{permission: permission}
  end
end
