defmodule Appb.RoleFeaturePermissionsContext do
  @moduledoc """
  The RoleFeaturePermissionsContext context.
  """

  import Ecto.Query, warn: false
  alias Appb.Repo

  alias Appb.RoleFeaturePermissionsContext.RoleFeaturePermissions

  @doc """
  Returns the list of rolefeaturepermissions.

  ## Examples

      iex> list_rolefeaturepermissions()
      [%RoleFeaturePermissions{}, ...]

  """
  def list_rolefeaturepermissions do
    Repo.all(RoleFeaturePermissions)
  end

  @doc """
  Gets a single role_feature_permissions.

  Raises `Ecto.NoResultsError` if the Define role level permission does not exist.

  ## Examples

      iex> get_role_feature_permissions!(123)
      %RoleFeaturePermissions{}

      iex> get_role_feature_permissions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role_feature_permissions!(id), do: Repo.get!(RoleFeaturePermissions, id)

  @doc """
  Creates a role_feature_permissions.

  ## Examples

      iex> create_role_feature_permissions(%{field: value})
      {:ok, %RoleFeaturePermissions{}}

      iex> create_role_feature_permissions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role_feature_permissions(attrs \\ %{}) do
    %RoleFeaturePermissions{}
    |> RoleFeaturePermissions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role_feature_permissions.

  ## Examples

      iex> update_role_feature_permissions(role_feature_permissions, %{field: new_value})
      {:ok, %RoleFeaturePermissions{}}

      iex> update_role_feature_permissions(role_feature_permissions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role_feature_permissions(%RoleFeaturePermissions{} = role_feature_permissions, attrs) do
    role_feature_permissions
    |> RoleFeaturePermissions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role_feature_permissions.

  ## Examples

      iex> delete_role_feature_permissions(role_feature_permissions)
      {:ok, %RoleFeaturePermissions{}}

      iex> delete_role_feature_permissions(role_feature_permissions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role_feature_permissions(%RoleFeaturePermissions{} = role_feature_permissions) do
    Repo.delete(role_feature_permissions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role_feature_permissions changes.

  ## Examples

      iex> change_role_feature_permissions(role_feature_permissions)
      %Ecto.Changeset{data: %RoleFeaturePermissions{}}

  """
  def change_role_feature_permissions(%RoleFeaturePermissions{} = role_feature_permissions, attrs \\ %{}) do
    RoleFeaturePermissions.changeset(role_feature_permissions, attrs)
  end
end
