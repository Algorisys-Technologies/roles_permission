defmodule AppbWeb.FeatureController do
  use AppbWeb, :controller

  alias Appb.FeatureContext
  alias Appb.FeatureContext.Feature

  def index(conn, _params) do
    features = FeatureContext.list_features()
    render(conn, "index.html", features: features)
  end

  def new(conn, params) do
    changeset = FeatureContext.change_feature(%Feature{})
    render(conn, "new.html", changeset: changeset, params: params)
  end

  def create(conn, %{"feature" => feature_params}) do
    # app_id added in features table
    app_id = conn.query_params["app_id"]
    feature_params = Map.put(feature_params, "app_id", app_id)

    case FeatureContext.create_feature(feature_params) do
      {:ok, feature} ->
        conn
        |> put_flash(:info, "Feature created successfully.")
        # |> redirect(to: Routes.feature_path(conn, :show, feature))
        |> redirect(to: Routes.app_path(conn, :show, feature.app_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    feature = FeatureContext.get_feature!(id)
    render(conn, "show.html", feature: feature)
  end

  def edit(conn, %{"id" => id}) do
    feature = FeatureContext.get_feature!(id)
    changeset = FeatureContext.change_feature(feature)
    render(conn, "edit.html", feature: feature, changeset: changeset)
  end

  def update(conn, %{"id" => id, "feature" => feature_params}) do
    feature = FeatureContext.get_feature!(id)

    case FeatureContext.update_feature(feature, feature_params) do
      {:ok, feature} ->
        conn
        |> put_flash(:info, "Feature updated successfully.")
        |> redirect(to: Routes.feature_path(conn, :show, feature))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", feature: feature, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    feature = FeatureContext.get_feature!(id)
    {:ok, _feature} = FeatureContext.delete_feature(feature)

    conn
    |> put_flash(:info, "Feature deleted successfully.")
    |> redirect(to: Routes.feature_path(conn, :index))
  end
end
