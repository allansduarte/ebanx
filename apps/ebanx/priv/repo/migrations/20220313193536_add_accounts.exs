defmodule Ebanx.Repo.Migrations.AddAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :decimal
      add :number, :integer

      timestamps()
    end

    create index(:accounts, [:number], unique: true)
  end
end
