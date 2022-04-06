defmodule Appb.Repo.Migrations.CreateDefinerolelevelpermissions do
  use Ecto.Migration

  def change do
    create table(:definerolelevelpermissions) do
      add :conditionText, :string
      add :conditionjson, :jsonb
      add :app_id, references(:apps, on_delete: :nothing)
      add :feature_id, references(:features, on_delete: :nothing)
      add :permission_id, references(:permissions, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index(:definerolelevelpermissions, [:app_id])
    create index(:definerolelevelpermissions, [:feature_id])
    create index(:definerolelevelpermissions, [:permission_id])
    create index(:definerolelevelpermissions, [:role_id])
  end
end
