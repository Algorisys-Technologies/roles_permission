defmodule Appb.Repo.Migrations.Createrolefeaturepermissions do
  use Ecto.Migration

  def change do
    create table(:rolefeaturepermissions) do
      add :conditionText, :string
      add :conditionjson, :jsonb
      add :app_id, references(:apps, on_delete: :nothing)
      add :feature_id, references(:features, on_delete: :nothing)
      add :permission_id, references(:permissions, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index(:rolefeaturepermissions, [:app_id])
    create index(:rolefeaturepermissions, [:feature_id])
    create index(:rolefeaturepermissions, [:permission_id])
    create index(:rolefeaturepermissions, [:role_id])
  end
end
