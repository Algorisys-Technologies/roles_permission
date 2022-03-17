defmodule AppbWeb.DefineRoleLevelPermissionController do
  use AppbWeb, :controller

  alias Appb.DefineRoleLevelPermissionContext
  alias Appb.DefineRoleLevelPermissionContext.DefineRoleLevelPermission
  alias Appb.AppContext.App
  alias Appb.Repo
  # import Ecto.Query, only: [from: 2, from: 1]
  alias Appb.PermissionContext.Permission

  def index(conn, _params) do
    definerolelevelpermissions =
      DefineRoleLevelPermissionContext.list_definerolelevelpermissions()

    render(conn, "index.html", definerolelevelpermissions: definerolelevelpermissions)
  end

  def new(conn, _params) do
    changeset =
      DefineRoleLevelPermissionContext.change_define_role_level_permission(
        %DefineRoleLevelPermission{}
      )

    app_id = conn.query_params["app"]

    app =
      Repo.get!(App, app_id)
      |> Repo.preload([:features, :permissions, :roles])

    # query =
    #   from(a in App,
    #     where: a.id == ^app_id,
    #     left_join: r in assoc(a, :roles),
    #     preload: [roles: r]
    #   )

    # appRole = Repo.one(query)

    appRole = Enum.map(app.roles, &{"#{&1.name}", &1.id})
    appRoleId = Enum.map(app.roles, & &1.id)

    # IO.inspect("#######create define_role_level_permission_controller#########")
    # IO.inspect(app, label: "app")
    # IO.inspect(appRole)
    # IO.inspect("################")

    render(conn, "new.html", changeset: changeset, apps: app, roles: appRole, roles_id: appRoleId)
  end

  def create(conn, %{"define_role_level_permission" => define_role_level_permission_params}) do
    # app_id added in define_role_level_permission table
    app_id = conn.query_params["app"]

    define_role_level_permission_params =
      Map.put(define_role_level_permission_params, "app_id", app_id)

    app =
      Repo.get!(App, app_id)
      |> Repo.preload([:features, :permissions, :roles])

    appRole = Enum.map(app.roles, &{"#{&1.name}", &1.id})
    appRoleId = Enum.map(app.roles, & &1.id)

    # IO.inspect("#######create define_role_level_permission_controller#########")
    # IO.inspect(app, label: "app")
    # IO.inspect("################")

    if define_role_level_permission_params["permission_id"] &&
         Enum.count(define_role_level_permission_params["permission_id"]) > 1 do
      for head <- define_role_level_permission_params["permission_id"] do
        permissionDetail = Repo.get!(Permission, head)

        if permissionDetail.feature_id ==
             String.to_integer(define_role_level_permission_params["feature_id"]) do
          define_role_level_permission_params =
            Map.put(define_role_level_permission_params, "permission_id", head)

          IO.inspect(define_role_level_permission_params)
        end
      end
    end

    case DefineRoleLevelPermissionContext.create_define_role_level_permission(
           define_role_level_permission_params
         ) do
      {:ok, define_role_level_permission} ->
        conn
        |> put_flash(:info, "Define role level permission created successfully.")
        |> redirect(
          to: Routes.define_role_level_permission_path(conn, :show, define_role_level_permission)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          apps: app,
          roles: appRole,
          roles_id: appRoleId
        )
    end
  end

  def show(conn, %{"id" => id}) do
    define_role_level_permission =
      DefineRoleLevelPermissionContext.get_define_role_level_permission!(id)

    render(conn, "show.html", define_role_level_permission: define_role_level_permission)
  end

  def edit(conn, %{"id" => id}) do
    define_role_level_permission =
      DefineRoleLevelPermissionContext.get_define_role_level_permission!(id)

    changeset =
      DefineRoleLevelPermissionContext.change_define_role_level_permission(
        define_role_level_permission
      )

    render(conn, "edit.html",
      define_role_level_permission: define_role_level_permission,
      changeset: changeset
    )
  end

  def update(conn, %{
        "id" => id,
        "define_role_level_permission" => define_role_level_permission_params
      }) do
    define_role_level_permission =
      DefineRoleLevelPermissionContext.get_define_role_level_permission!(id)

    case DefineRoleLevelPermissionContext.update_define_role_level_permission(
           define_role_level_permission,
           define_role_level_permission_params
         ) do
      {:ok, define_role_level_permission} ->
        conn
        |> put_flash(:info, "Define role level permission updated successfully.")
        |> redirect(
          to: Routes.define_role_level_permission_path(conn, :show, define_role_level_permission)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          define_role_level_permission: define_role_level_permission,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    define_role_level_permission =
      DefineRoleLevelPermissionContext.get_define_role_level_permission!(id)

    {:ok, _define_role_level_permission} =
      DefineRoleLevelPermissionContext.delete_define_role_level_permission(
        define_role_level_permission
      )

    conn
    |> put_flash(:info, "Define role level permission deleted successfully.")
    |> redirect(to: Routes.define_role_level_permission_path(conn, :index))
  end
end
