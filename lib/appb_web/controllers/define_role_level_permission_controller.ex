defmodule AppbWeb.DefineRoleLevelPermissionController do
  use AppbWeb, :controller

  alias Appb.DefineRoleLevelPermissionContext
  alias Appb.DefineRoleLevelPermissionContext.DefineRoleLevelPermission
  alias Appb.AppContext.App
  alias Appb.PermissionContext.Permission
  alias Appb.Repo
  import Ecto.Query, only: [from: 2]


  # <%= for rolelevelpermission <- @definerolelevelpermissions do %>
  # <%= permission.id %>
  # <%= if rolelevelpermission.permission_id == permission.id do %>
  #   <li>
  #     <input name="define_role_level_permission[permission_id][]" checked type="checkbox" value={permission.id}>
  #     <%= permission.name %>
  #   </li>
  # <% else %>

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

    definerolelevelpermissions =
      DefineRoleLevelPermissionContext.list_definerolelevelpermissions()

    # IO.inspect("######################")
    # IO.inspect(definerolelevelpermissions)
    # IO.inspect("######################")

    # IO.inspect("######################")
    # IO.inspect(app)
    # IO.inspect("######################")

    appRole = Enum.map(app.roles, &{"#{&1.name}", &1.id})
    appRoleId = Enum.map(app.roles, & &1.id)

    render(conn, "new.html",
      changeset: changeset,
      apps: app,
      roles: appRole,
      roles_id: appRoleId,
      definerolelevelpermissions: definerolelevelpermissions
    )
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

    definerolelevelpermissions =
      DefineRoleLevelPermissionContext.list_definerolelevelpermissions()

    if define_role_level_permission_params["permission_id"] do
      for head <- define_role_level_permission_params["permission_id"] do
        IO.inspect(define_role_level_permission_params["permission_id"])
        IO.inspect(head, label: "head")
        permissionDetail = Repo.get!(Permission, head)

        define_role_level_permission_params =
          Map.put(define_role_level_permission_params, "permission_id", head)

        define_role_level_permission_params =
          Map.put(define_role_level_permission_params, "feature_id", permissionDetail.feature_id)

        roleId = define_role_level_permission_params["role_id"]
        featureId = define_role_level_permission_params["feature_id"]

        query =
          from(d in DefineRoleLevelPermission,
            where: d.role_id == type(^roleId, :integer) and d.feature_id == ^featureId
          )

        Repo.delete_all(query)

        IO.inspect(define_role_level_permission_params)

        caseDefine(conn, define_role_level_permission_params, app, appRole, appRoleId,
          definerolelevelpermissions: definerolelevelpermissions
        )
      end
    end

    caseDefine(conn, define_role_level_permission_params, app, appRole, appRoleId,
      definerolelevelpermissions: definerolelevelpermissions
    )
  end

  defp caseDefine(
         conn,
         define_role_level_permission_params,
         app,
         appRole,
         appRoleId,
         definerolelevelpermissions
       ) do
    case DefineRoleLevelPermissionContext.create_define_role_level_permission(
           define_role_level_permission_params
         ) do
      {:ok, define_role_level_permission} ->
        conn
        |> put_flash(:info, "Define role level permission created successfully.")
        |> redirect(
          to:
            Routes.define_role_level_permission_path(
              conn,
              :show,
              define_role_level_permission
            )
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          apps: app,
          roles: appRole,
          roles_id: appRoleId,
          definerolelevelpermissions: definerolelevelpermissions
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
