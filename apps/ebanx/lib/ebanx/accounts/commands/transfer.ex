defmodule Ebanx.Accounts.Commands.Transfer do
  @moduledoc """
  Handles a Transfer.

  When handles a Transfer, it's updated the balance.
  """

  import Ecto.Query, only: [lock: 2]

  require Logger

  alias Ebanx.Accounts
  alias Ebanx.Accounts.Account
  alias Ebanx.Accounts.Inputs.Transfer
  alias Ebanx.Repo

  @type possible_errors :: nil | Ecto.Changeset.t()

  @spec execute(input :: Transfer.t()) :: {:ok, Account.t()} | {:error, possible_errors()}
  def execute(input) do
    Logger.metadata(origin: input.origin, amount: input.amount)

    Repo.transaction(fn ->
      with %Account{} = account <- find_account(input),
           {:ok, account} <- do_Transfer(input.amount, account) do
        account
      else
        {:error, err} ->
          Logger.error("""
          Error processing Transfer
          error: #{inspect(err)}
          """)

          Repo.rollback(err)

        err ->
          Logger.error("""
          Unexpected error processing Transfer
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

  defp do_withdraw(amount, account) do
    balance = Decimal.sub(account.balance, amount)

    account
    |> Account.changeset(%{balance: balance})
    |> Repo.update()
  end

  defp find_account(input) do
    queryable = Account |> lock("FOR UPDATE")

    case Repo.get_by(queryable, number: input.origin) do
      nil ->
        {:error, :not_found}
      account ->
        account
    end
  end
end
