defmodule Ebanx.Accounts.Commands.Deposit do
  @moduledoc """
  Handles a deposit.

  When creating a deposit, it's updated the balance.
  """

  import Ecto.Query, only: [lock: 2]

  require Logger

  alias Ebanx.Accounts
  alias Ebanx.Accounts.Account
  alias Ebanx.Accounts.Inputs.Deposit
  alias Ebanx.Repo

  @type possible_errors :: nil | Ecto.Changeset.t()

  @spec execute(input :: Deposit.t()) :: {:ok, Account.t()} | {:error, possible_errors()}
  def execute(input) do
    Logger.metadata(destination: input.destination, amount: input.amount)

    Repo.transaction(fn ->
      with %Account{} = account <- find_account(input),
           {:ok, account} <- do_deposit(input.amount, account) do
        account
      else
        {:error, err} ->
          Logger.error("""
          Error processing Deposit
          error: #{inspect(err)}
          """)

          Repo.rollback(err)

        err ->
          Logger.error("""
          Unexpected error processing Deposit
          error: #{inspect(err)}
          """)

          Repo.rollback(err)
      end
    end)
    |> case do
      {:ok, account} -> {:ok, account}
      {:error, err} -> {:error, err}
    end
  end

  defp do_deposit(amount, account) do
    balance = Decimal.add(account.balance, amount)

    account
    |> Account.changeset(%{balance: balance})
    |> Repo.update()
  end

  defp find_account(input) do
    queryable = Account |> lock("FOR UPDATE")

    case Repo.get_by(queryable, number: input.destination) do
      nil ->
        {:ok, account} = Accounts.register_account(%{number: input.destination, balance: 0})
        account
      account -> account
    end
  end
end
