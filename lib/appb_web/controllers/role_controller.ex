defmodule AppbWeb.RoleController do
  use AppbWeb, :controller

  alias Appb.RoleContext
  alias Appb.RoleContext.Role

  def index(conn, _params) do
    roles = RoleContext.list_roles()
    render(conn, "index.html", roles: roles)
  end

  def new(conn, _params) do
    changeset = RoleContext.change_role(%Role{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"role" => role_params}) do
    # app_id added in roles table
    app_id = conn.query_params["app_id"]
    role_params = Map.put(role_params, "app_id", app_id)

    case RoleContext.create_role(role_params) do
      {:ok, role} ->
        conn
        |> put_flash(:info, "Role created successfully.")
        # |> redirect(to: Routes.role_path(conn, :show, role))
        |> redirect(to: Routes.app_path(conn, :show, role.app_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    role = RoleContext.get_role!(id)
    render(conn, "show.html", role: role)
  end

  def edit(conn, %{"id" => id}) do
    role = RoleContext.get_role!(id)
    changeset = RoleContext.change_role(role)
    render(conn, "edit.html", role: role, changeset: changeset)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = RoleContext.get_role!(id)

    case RoleContext.update_role(role, role_params) do
      {:ok, role} ->
        conn
        |> put_flash(:info, "Role updated successfully.")
        |> redirect(to: Routes.role_path(conn, :show, role))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", role: role, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = RoleContext.get_role!(id)
    {:ok, _role} = RoleContext.delete_role(role)

    conn
    |> put_flash(:info, "Role deleted successfully.")
    |> redirect(to: Routes.role_path(conn, :index))
  end
end
