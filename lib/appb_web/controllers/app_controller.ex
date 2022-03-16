defmodule AppbWeb.AppController do
  use AppbWeb, :controller

  alias Appb.AppContext
  alias Appb.AppContext.App
  alias Appb.Repo

  # import Ecto.Query, only: [from: 2, from: 1]

  def index(conn, _params) do
    apps = AppContext.list_apps()
    render(conn, "index.html", apps: apps)
  end

  def new(conn, _params) do
    changeset = AppContext.change_app(%App{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"app" => app_params}) do
    # add a currentUser_id to form
    current_user = conn.assigns.current_user
    app_params = Map.put(app_params, "user_id", current_user.id)
    # IO.inspect(app_params)

    case AppContext.create_app(app_params) do
      {:ok, app} ->
        conn
        |> put_flash(:info, "App created successfully.")
        |> redirect(to: Routes.app_path(conn, :show, app))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    # app = AppContext.get_app!(id)

    # query =
    #   from(a in App,
    #     left_join: f in assoc(a, :features),
    #     where: a.id == ^id,
    #     preload: [features: f]
    #   )

    # app = Repo.one(query)

    app =
      Repo.get!(App, id)
      |> Repo.preload([:features, :permissions, :roles])

    permission =
      Repo.get!(App, id)
      |> Repo.preload(features: [:permissions])

    IO.inspect(app, label: "app")

    render(conn, "show.html", app: app, permission: permission.features)
  end

  def edit(conn, %{"id" => id}) do
    app = AppContext.get_app!(id)
    changeset = AppContext.change_app(app)
    render(conn, "edit.html", app: app, changeset: changeset)
  end

  def update(conn, %{"id" => id, "app" => app_params}) do
    app = AppContext.get_app!(id)

    case AppContext.update_app(app, app_params) do
      {:ok, app} ->
        conn
        |> put_flash(:info, "App updated successfully.")
        |> redirect(to: Routes.app_path(conn, :show, app))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", app: app, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    app = AppContext.get_app!(id)
    {:ok, _app} = AppContext.delete_app(app)

    conn
    |> put_flash(:info, "App deleted successfully.")
    |> redirect(to: Routes.app_path(conn, :index))
  end
end
