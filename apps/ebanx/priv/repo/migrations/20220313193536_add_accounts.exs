defmodule Ebanx.Repo.Migrations.AddAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :balance, :decimal

      add :user_id, references(:users, type: :uuid)

      timestamps()
    end
  end
end
