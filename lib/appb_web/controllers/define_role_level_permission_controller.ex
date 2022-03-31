defmodule AppbWeb.DefineRoleLevelPermissionController do
  use AppbWeb, :controller

  alias Appb.DefineRoleLevelPermissionContext
  alias Appb.DefineRoleLevelPermissionContext.DefineRoleLevelPermission
  alias Appb.AppContext.App
  alias Appb.PermissionContext.Permission
  # alias Appb.FeatureContext.Feature
  alias Appb.Repo
  import Ecto.Query, only: [from: 2]

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
    role_id = conn.query_params["amp;filter"]

    app =
      Repo.get!(App, app_id)
      |> Repo.preload([:features, :permissions, :roles])

    appRole = Enum.map(app.roles, &{"#{&1.name}", &1.id})
    # appRoleId = Enum.map(app.roles, & &1.id)
    appRoleId = role_id

    if is_nil(role_id) do
      definerolelevelpermissions = roleBasedPermissions()
      renderPermissions = uiRender(app.features, app.permissions, definerolelevelpermissions)
      renderMaterial = uiRenderFinal(renderPermissions, 1)

      render(conn, "new.html",
        changeset: changeset,
        apps: app,
        roles: appRole,
        roles_id: appRoleId,
        renderMaterial: renderMaterial
      )
    else
      definerolelevelpermissions = roleBasedPermissions(role_id)
      renderPermissions = uiRender(app.features, app.permissions, definerolelevelpermissions)
      renderMaterial = uiRenderFinal(renderPermissions, role_id)

      render(conn, "new.html",
        changeset: changeset,
        apps: app,
        roles: appRole,
        roles_id: appRoleId,
        renderMaterial: renderMaterial
      )
    end
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
    # appRoleId = Enum.map(app.roles, & &1.id)
    role_id = define_role_level_permission_params["role_id"]
    definerolelevelpermissions = roleBasedPermissions(role_id)

    renderPermissions = uiRender(app.features, app.permissions, definerolelevelpermissions)
    renderMaterial = uiRenderFinal(renderPermissions, role_id)

    deleteRows(define_role_level_permission_params)

    if define_role_level_permission_params["permission_id"] do
      for head <- define_role_level_permission_params["permission_id"] do
        permissionDetail = Repo.get!(Permission, head)

        define_role_level_permission_params =
          Map.put(define_role_level_permission_params, "permission_id", head)

        define_role_level_permission_params =
          Map.put(define_role_level_permission_params, "feature_id", permissionDetail.feature_id)

        caseDefine(
          conn,
          define_role_level_permission_params,
          app,
          appRole,
          role_id,
          renderMaterial
        )
      end
    end

    conn
    |> redirect(to: Routes.define_role_level_permission_path(conn, :new, app: app.id))
  end

  defp caseDefine(
         conn,
         define_role_level_permission_params,
         app,
         appRole,
         role_id,
         renderMaterial
       ) do
    case DefineRoleLevelPermissionContext.create_define_role_level_permission(
           define_role_level_permission_params
         ) do
      {:ok, _define_role_level_permission} ->
        conn
        |> put_flash(:info, "Define role level permission created successfully.")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          apps: app,
          roles: appRole,
          roles_id: role_id,
          renderMaterial: renderMaterial
        )
    end
  end

  defp uiRender(_features, permissions, definerolelevelpermissions) do
    for permission <- permissions do
      if definerolelevelpermissions && definerolelevelpermissions !== [] do
        for define <- definerolelevelpermissions do
          if define.permission_id == permission.id do
            Map.put(permission, :flag, true)
          else
            Map.put(permission, :flag, false)
          end
        end
      else
        Map.put(permission, :flag, false)
      end
    end
  end

  defp uiRenderFinal(renderPermissions, role_id) do
    [head | _tail] = renderPermissions

    if !is_map(head) do
      if head == nil or Enum.count(head) >= 2 do
        for [s1, s2 | _] <- renderPermissions do
          isPermissionIdExist =
            Repo.exists?(
              from d in DefineRoleLevelPermission,
                where: d.permission_id == ^s1.id and d.role_id == ^role_id
            )

          if s1.id == s2.id and isPermissionIdExist do
            %{s1 | flag: true}
          else
            %{s1 | flag: false}
          end
        end
      else
        for s1 <- renderPermissions, s2 <- s1, do: s2
      end
    else
      renderPermissions
    end
  end

  defp roleBasedPermissions(role_id \\ 1) do
    query =
      from(d in DefineRoleLevelPermission,
        join: p in Permission,
        where: p.id == d.permission_id and d.role_id == type(^role_id, :integer)
      )

    Repo.all(query)
  end

  defp deleteRows(define_role_level_permission_params) do
    role_id = define_role_level_permission_params["role_id"]

    query =
      from(d in DefineRoleLevelPermission,
        where: d.role_id == type(^role_id, :integer)
      )

    Repo.delete_all(query)
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
