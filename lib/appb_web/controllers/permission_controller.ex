defmodule AppbWeb.PermissionController do
  use AppbWeb, :controller

  alias Appb.PermissionContext
  alias Appb.PermissionContext.Permission

  def index(conn, _params) do
    permissions = PermissionContext.list_permissions()
    render(conn, "index.html", permissions: permissions)
  end

  def new(conn, params) do
    changeset = PermissionContext.change_permission(%Permission{})
    render(conn, "new.html", changeset: changeset, params: params)
  end

  def create(conn, %{"permission" => permission_params}) do
    # app_id and feature_id added in permissions table
    app_id = conn.query_params["app_id"]
    feature_id = conn.query_params["feature_id"]
    permission_params = Map.put(permission_params, "app_id", app_id)
    permission_params = Map.put(permission_params, "feature_id", feature_id)

    case PermissionContext.create_permission(permission_params) do
      {:ok, permission} ->
        conn
        |> put_flash(:info, "Permission created successfully.")
        # |> redirect(to: Routes.permission_path(conn, :show, permission))
        |> redirect(to: Routes.app_path(conn, :show, permission.app_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    permission = PermissionContext.get_permission!(id)
    render(conn, "show.html", permission: permission)
  end

  def edit(conn, %{"id" => id}) do
    permission = PermissionContext.get_permission!(id)
    changeset = PermissionContext.change_permission(permission)
    render(conn, "edit.html", permission: permission, changeset: changeset)
  end

  def update(conn, %{"id" => id, "permission" => permission_params}) do
    permission = PermissionContext.get_permission!(id)

    case PermissionContext.update_permission(permission, permission_params) do
      {:ok, permission} ->
        conn
        |> put_flash(:info, "Permission updated successfully.")
        |> redirect(to: Routes.permission_path(conn, :show, permission))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", permission: permission, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    permission = PermissionContext.get_permission!(id)
    {:ok, _permission} = PermissionContext.delete_permission(permission)

    conn
    |> put_flash(:info, "Permission deleted successfully.")
    |> redirect(to: Routes.permission_path(conn, :index))
  end
end
