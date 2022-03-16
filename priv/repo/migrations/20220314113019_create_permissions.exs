defmodule Appb.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :string
      add :app_id, references(:apps, on_delete: :delete_all), null: false
      add :feature_id, references(:features, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:permissions, [:app_id])
    create index(:permissions, [:feature_id])
  end
end
