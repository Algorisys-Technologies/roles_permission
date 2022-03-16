defmodule Appb.AppContextTest do
  use Appb.DataCase

  alias Appb.AppContext

  describe "apps" do
    alias Appb.AppContext.App

    import Appb.AppContextFixtures

    @invalid_attrs %{name: nil}

    test "list_apps/0 returns all apps" do
      app = app_fixture()
      assert AppContext.list_apps() == [app]
    end

    test "get_app!/1 returns the app with given id" do
      app = app_fixture()
      assert AppContext.get_app!(app.id) == app
    end

    test "create_app/1 with valid data creates a app" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %App{} = app} = AppContext.create_app(valid_attrs)
      assert app.name == "some name"
    end

    test "create_app/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AppContext.create_app(@invalid_attrs)
    end

    test "update_app/2 with valid data updates the app" do
      app = app_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %App{} = app} = AppContext.update_app(app, update_attrs)
      assert app.name == "some updated name"
    end

    test "update_app/2 with invalid data returns error changeset" do
      app = app_fixture()
      assert {:error, %Ecto.Changeset{}} = AppContext.update_app(app, @invalid_attrs)
      assert app == AppContext.get_app!(app.id)
    end

    test "delete_app/1 deletes the app" do
      app = app_fixture()
      assert {:ok, %App{}} = AppContext.delete_app(app)
      assert_raise Ecto.NoResultsError, fn -> AppContext.get_app!(app.id) end
    end

    test "change_app/1 returns a app changeset" do
      app = app_fixture()
      assert %Ecto.Changeset{} = AppContext.change_app(app)
    end
  end
end
