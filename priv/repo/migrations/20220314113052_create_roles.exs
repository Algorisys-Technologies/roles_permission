defmodule Appb.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :app_id, references(:apps, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:roles, [:app_id])
  end
end
