defmodule Appb.RoleContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appb.RoleContext` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Appb.RoleContext.create_role()

    role
  end
end
