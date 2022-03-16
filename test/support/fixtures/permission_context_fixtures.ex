defmodule Appb.PermissionContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appb.PermissionContext` context.
  """

  @doc """
  Generate a permission.
  """
  def permission_fixture(attrs \\ %{}) do
    {:ok, permission} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Appb.PermissionContext.create_permission()

    permission
  end
end
