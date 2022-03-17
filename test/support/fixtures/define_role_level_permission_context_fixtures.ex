defmodule Appb.DefineRoleLevelPermissionContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appb.DefineRoleLevelPermissionContext` context.
  """

  @doc """
  Generate a define_role_level_permission.
  """
  def define_role_level_permission_fixture(attrs \\ %{}) do
    {:ok, define_role_level_permission} =
      attrs
      |> Enum.into(%{
        conditionText: "some conditionText",
        conditionjson: "some conditionjson"
      })
      |> Appb.DefineRoleLevelPermissionContext.create_define_role_level_permission()

    define_role_level_permission
  end
end
