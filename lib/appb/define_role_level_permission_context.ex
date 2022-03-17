defmodule Appb.DefineRoleLevelPermissionContext do
  @moduledoc """
  The DefineRoleLevelPermissionContext context.
  """

  import Ecto.Query, warn: false
  alias Appb.Repo

  alias Appb.DefineRoleLevelPermissionContext.DefineRoleLevelPermission

  @doc """
  Returns the list of definerolelevelpermissions.

  ## Examples

      iex> list_definerolelevelpermissions()
      [%DefineRoleLevelPermission{}, ...]

  """
  def list_definerolelevelpermissions do
    Repo.all(DefineRoleLevelPermission)
  end

  @doc """
  Gets a single define_role_level_permission.

  Raises `Ecto.NoResultsError` if the Define role level permission does not exist.

  ## Examples

      iex> get_define_role_level_permission!(123)
      %DefineRoleLevelPermission{}

      iex> get_define_role_level_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_define_role_level_permission!(id), do: Repo.get!(DefineRoleLevelPermission, id)

  @doc """
  Creates a define_role_level_permission.

  ## Examples

      iex> create_define_role_level_permission(%{field: value})
      {:ok, %DefineRoleLevelPermission{}}

      iex> create_define_role_level_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_define_role_level_permission(attrs \\ %{}) do
    %DefineRoleLevelPermission{}
    |> DefineRoleLevelPermission.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a define_role_level_permission.

  ## Examples

      iex> update_define_role_level_permission(define_role_level_permission, %{field: new_value})
      {:ok, %DefineRoleLevelPermission{}}

      iex> update_define_role_level_permission(define_role_level_permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_define_role_level_permission(%DefineRoleLevelPermission{} = define_role_level_permission, attrs) do
    define_role_level_permission
    |> DefineRoleLevelPermission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a define_role_level_permission.

  ## Examples

      iex> delete_define_role_level_permission(define_role_level_permission)
      {:ok, %DefineRoleLevelPermission{}}

      iex> delete_define_role_level_permission(define_role_level_permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_define_role_level_permission(%DefineRoleLevelPermission{} = define_role_level_permission) do
    Repo.delete(define_role_level_permission)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking define_role_level_permission changes.

  ## Examples

      iex> change_define_role_level_permission(define_role_level_permission)
      %Ecto.Changeset{data: %DefineRoleLevelPermission{}}

  """
  def change_define_role_level_permission(%DefineRoleLevelPermission{} = define_role_level_permission, attrs \\ %{}) do
    DefineRoleLevelPermission.changeset(define_role_level_permission, attrs)
  end
end
