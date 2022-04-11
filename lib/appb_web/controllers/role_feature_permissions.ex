defmodule AppbWeb.RoleFeaturePermissionsController do
  use AppbWeb, :controller

  alias Appb.RoleFeaturePermissionsContext
  alias Appb.RoleFeaturePermissionsContext.RoleFeaturePermissions
  alias Appb.AppContext.App
  alias Appb.PermissionContext.Permission
  alias Appb.Repo
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    rolefeaturepermissions =
      RoleFeaturePermissionsContext.list_rolefeaturepermissions()

    render(conn, "index.html", rolefeaturepermissions: rolefeaturepermissions)
  end

  def new(conn, _params) do
    changeset =
      RoleFeaturePermissionsContext.change_role_feature_permissions(
        %RoleFeaturePermissions{}
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
      rolefeaturepermissions = roleBasedPermissions()
      renderPermissions = uiRender(app.features, app.permissions, rolefeaturepermissions)
      renderMaterial = uiRenderFinal(renderPermissions, 1)

      render(conn, "new.html",
        changeset: changeset,
        apps: app,
        roles: appRole,
        roles_id: appRoleId,
        renderMaterial: renderMaterial
      )
    else
      rolefeaturepermissions = roleBasedPermissions(role_id)
      renderPermissions = uiRender(app.features, app.permissions, rolefeaturepermissions)
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

  def create(conn, %{"role_feature_permissions" => role_feature_permissions_params}) do
    # app_id added in role_feature_permissions table
    app_id = conn.query_params["app"]

    role_feature_permissions_params =
      Map.put(role_feature_permissions_params, "app_id", app_id)

    app =
      Repo.get!(App, app_id)
      |> Repo.preload([:features, :permissions, :roles])

    appRole = Enum.map(app.roles, &{"#{&1.name}", &1.id})
    # appRoleId = Enum.map(app.roles, & &1.id)
    role_id = role_feature_permissions_params["role_id"]
    rolefeaturepermissions = roleBasedPermissions(role_id)

    renderPermissions = uiRender(app.features, app.permissions, rolefeaturepermissions)
    renderMaterial = uiRenderFinal(renderPermissions, role_id)

    deleteRows(role_feature_permissions_params)

    if role_feature_permissions_params["permission_id"] do
      for head <- role_feature_permissions_params["permission_id"] do
        permissionDetail = Repo.get!(Permission, head)

        conditionText = rolesPermissionText(role_feature_permissions_params, head)
        finalConditions = rolePermissionJson(conditionText)

        role_feature_permissions_params =
          Map.put(role_feature_permissions_params, "conditionjson", %{
            data: finalConditions
          })

        role_feature_permissions_params =
          Map.put(role_feature_permissions_params, "conditionText", conditionText)

        role_feature_permissions_params =
          Map.put(role_feature_permissions_params, "permission_id", head)

        role_feature_permissions_params =
          Map.put(role_feature_permissions_params, "feature_id", permissionDetail.feature_id)

        caseDefine(
          conn,
          role_feature_permissions_params,
          app,
          appRole,
          role_id,
          renderMaterial
        )
      end
    end

    conn
    |> redirect(to: Routes.role_feature_permissions_path(conn, :new, app: app.id))
  end

  defp rolePermissionJson(conditionText) do
    if conditionText do
      conditions = String.split(conditionText, "/n", trim: true)

      conditions
      |> Enum.map(fn c ->
        cList = String.split(c, " ", trim: true)
        IO.inspect(cList, label: "cList")

        if Enum.count(cList) == 4 do
          %{
            c1: Enum.at(cList, 0),
            c2: Enum.at(cList, 2),
            operator: Enum.at(cList, 1),
            conditionOperator: Enum.at(cList, 4, "and")
          }
        end
      end)
    end
  end

  defp rolesPermissionText(role_feature_permissions_params, head) do
    if role_feature_permissions_params["conditionText"] do
      conditionText = role_feature_permissions_params["conditionText"]

      indexList =
        conditionText
        |> Enum.with_index()
        |> Enum.filter(fn {text, _} ->
          length = String.length(text)
          sliceString = String.slice(text, 0..(length - 2))

          if text == "#{sliceString}#{head}" do
            text
          end
        end)
        |> Enum.map(fn {_, i} -> i end)

      _first = indexList |> List.first()
      last = indexList |> List.last()
      count = indexList |> Enum.count()

      if last do
        conditionText
        |> Enum.slice((last - count * 4 + 1)..last)
        |> Enum.map(fn text ->
          length = String.length(text)
          sliceString = String.slice(text, 0..(length - 2))

          if text == "#{sliceString}#{head}" do
            "#{sliceString}/n"
          else
            text
          end
        end)
        |> Enum.join(" ")
      end
    end
  end

  defp caseDefine(
         conn,
         role_feature_permissions_params,
         app,
         appRole,
         role_id,
         renderMaterial
       ) do
    case RoleFeaturePermissionsContext.create_role_feature_permissions(
           role_feature_permissions_params
         ) do
      {:ok, _role_feature_permissions} ->
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

  defp uiRender(_features, permissions, rolefeaturepermissions) do
    for permission <- permissions do
      if rolefeaturepermissions && rolefeaturepermissions !== [] do
        for define <- rolefeaturepermissions do
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
              from d in RoleFeaturePermissions,
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
      from(d in RoleFeaturePermissions,
        join: p in Permission,
        where: p.id == d.permission_id and d.role_id == type(^role_id, :integer)
      )

    Repo.all(query)
  end

  defp deleteRows(role_feature_permissions_params) do
    role_id = role_feature_permissions_params["role_id"]

    query =
      from(d in RoleFeaturePermissions,
        where: d.role_id == type(^role_id, :integer)
      )

    Repo.delete_all(query)
  end

  def show(conn, %{"id" => id}) do
    role_feature_permissions =
      RoleFeaturePermissionsContext.get_role_feature_permissions!(id)

    render(conn, "show.html", role_feature_permissions: role_feature_permissions)
  end

  def edit(conn, %{"id" => id}) do
    role_feature_permissions =
      RoleFeaturePermissionsContext.get_role_feature_permissions!(id)

    changeset =
      RoleFeaturePermissionsContext.change_role_feature_permissions(
        role_feature_permissions
      )

    render(conn, "edit.html",
      role_feature_permissions: role_feature_permissions,
      changeset: changeset
    )
  end

  def update(conn, %{
        "id" => id,
        "role_feature_permissions" => role_feature_permissions_params
      }) do
    role_feature_permissions =
      RoleFeaturePermissionsContext.get_role_feature_permissions!(id)

    case RoleFeaturePermissionsContext.update_role_feature_permissions(
           role_feature_permissions,
           role_feature_permissions_params
         ) do
      {:ok, role_feature_permissions} ->
        conn
        |> put_flash(:info, "Define role level permission updated successfully.")
        |> redirect(
          to: Routes.role_feature_permissions_path(conn, :show, role_feature_permissions)
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          role_feature_permissions: role_feature_permissions,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    role_feature_permissions =
      RoleFeaturePermissionsContext.get_role_feature_permissions!(id)

    {:ok, _role_feature_permissions} =
      RoleFeaturePermissionsContext.delete_role_feature_permissions(
        role_feature_permissions
      )

    conn
    |> put_flash(:info, "Define role level permission deleted successfully.")
    |> redirect(to: Routes.role_feature_permissions_path(conn, :index))
  end
end
