defmodule AppbWeb.DefineRoleLevelPermissionController do
  use AppbWeb, :controller

  alias Appb.DefineRoleLevelPermissionContext
  alias Appb.DefineRoleLevelPermissionContext.DefineRoleLevelPermission
  alias Appb.AppContext.App
  alias Appb.PermissionContext.Permission
  alias Appb.FeatureContext.Feature
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

    app =
      Repo.get!(App, app_id)
      |> Repo.preload([:features, :permissions, :roles])

    # definerolelevelpermissions =
    #   DefineRoleLevelPermissionContext.list_definerolelevelpermissions()

    roleId = 3

    definerolelevelpermissions = roleBasedPermissions(roleId)

    render = uiRender(app.features, app.permissions, definerolelevelpermissions)
    renderMaterial = uiRenderFinal(render, roleId)

    appRole = Enum.map(app.roles, &{"#{&1.name}", &1.id})
    appRoleId = Enum.map(app.roles, & &1.id)

    render(conn, "new.html",
      changeset: changeset,
      apps: app,
      roles: appRole,
      roles_id: appRoleId,
      definerolelevelpermissions: definerolelevelpermissions,
      renderMaterial: renderMaterial
    )
  end

  defp uiRenderFinal(render, roleId) do
    [head | _tail] = render

    if !is_map(head) do
      if Enum.count(head) >= 2 do
        for [s1, s2 | _] <- render do
          if s1 !== nil do
            isPermissionIdExist =
              Repo.exists?(
                from d in DefineRoleLevelPermission,
                  where: d.permission_id == ^s1.id and d.role_id == ^roleId
              )

            if s1 !== nil and s2 !== nil do
              if s1.id == s2.id and isPermissionIdExist do
                s1 = %{s1 | flag: true}
                _s2 = %{s2 | flag: true}
                s1
              else
                s1
              end
            else
              if s1 !== nil and (s2 == nil and isPermissionIdExist) do
                s1 = %{s1 | flag: true}
                s1
              else
                s1
              end
            end
          else
            s2
          end
        end
      else
        for s1 <- render, s2 <- s1, do: s2
      end
    else
      render
    end
  end

  defp uiRender(_features, permissions, definerolelevelpermissions) do
    for permission <- permissions do
      featureDetails = Repo.get!(Feature, permission.feature_id)
      p = permission.feature_id

      if definerolelevelpermissions && definerolelevelpermissions !== [] do
        for define <- definerolelevelpermissions do
          if define.feature_id == permission.feature_id do
            if define.id == permission.id do
              permission = Map.put(permission, :flag, true)
              Map.put(permission, :feature_name, featureDetails.name)
            else
              permission = Map.put(permission, :flag, false)
              Map.put(permission, :feature_name, featureDetails.name)
            end
          else
            if p == define.feature_id do
              nil
            else
              permission = Map.put(permission, :flag, false)
              Map.put(permission, :feature_name, featureDetails.name)
            end
          end
        end
      else
        permission = Map.put(permission, :flag, false)
        Map.put(permission, :feature_name, featureDetails.name)
      end
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
    appRoleId = Enum.map(app.roles, & &1.id)

    # definerolelevelpermissions =
    #   DefineRoleLevelPermissionContext.list_definerolelevelpermissions()

    roleId = define_role_level_permission_params["role_id"]
    IO.inspect(roleId)
    definerolelevelpermissions = roleBasedPermissions(roleId)
    # IO.inspect(definerolelevelpermissions)

    deleteRows(define_role_level_permission_params)

    if define_role_level_permission_params["permission_id"] do
      roleId = define_role_level_permission_params["role_id"]

      for head <- define_role_level_permission_params["permission_id"] do
        permissionDetail = Repo.get!(Permission, head)

        define_role_level_permission_params =
          Map.put(define_role_level_permission_params, "permission_id", head)

        define_role_level_permission_params =
          Map.put(define_role_level_permission_params, "feature_id", permissionDetail.feature_id)

        render = uiRender(app.features, app.permissions, definerolelevelpermissions)
        renderMaterial = uiRenderFinal(render, roleId)

        caseDefine(
          conn,
          define_role_level_permission_params,
          app,
          appRole,
          appRoleId,
          definerolelevelpermissions,
          renderMaterial: renderMaterial
        )
      end
    end

    # caseDefine(conn, define_role_level_permission_params, app, appRole, appRoleId,
    #   definerolelevelpermissions,renderMaterial: renderMaterial
    # )

    conn
    |> redirect(to: Routes.define_role_level_permission_path(conn, :new, app: app.id))
  end

  defp caseDefine(
         conn,
         define_role_level_permission_params,
         app,
         appRole,
         appRoleId,
         definerolelevelpermissions,
         renderMaterial: renderMaterial
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
          roles_id: appRoleId,
          definerolelevelpermissions: definerolelevelpermissions,
          renderMaterial: renderMaterial
        )
    end
  end

  defp roleBasedPermissions(roleId) do
    query =
      from(d in DefineRoleLevelPermission,
        where: d.role_id == type(^roleId, :integer),
        select: d.permission_id
      )

    definerolelevelpermissionsIds = Repo.all(query)

    for definerolelevelpermissionsId <- definerolelevelpermissionsIds do
      permission = Repo.get(Permission, definerolelevelpermissionsId)
      permission
    end
  end

  defp deleteRows(define_role_level_permission_params) do
    roleId = define_role_level_permission_params["role_id"]

    query =
      from(d in DefineRoleLevelPermission,
        where: d.role_id == type(^roleId, :integer)
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
