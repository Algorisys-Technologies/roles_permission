defmodule Appb.RoleFeaturePermissionsContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appb.RoleFeaturePermissionsContext` context.
  """

  @doc """
  Generate a role_feature_permissions.
  """
  def role_feature_permissions_fixture(attrs \\ %{}) do
    {:ok, role_feature_permissions} =
      attrs
      |> Enum.into(%{
        conditionText: "some conditionText",
        conditionjson: "some conditionjson"
      })
      |> Appb.RoleFeaturePermissionsContext.create_role_feature_permissions()

    role_feature_permissions
  end
end
