defmodule Appb.AppContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appb.AppContext` context.
  """

  @doc """
  Generate a app.
  """
  def app_fixture(attrs \\ %{}) do
    {:ok, app} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Appb.AppContext.create_app()

    app
  end
end
