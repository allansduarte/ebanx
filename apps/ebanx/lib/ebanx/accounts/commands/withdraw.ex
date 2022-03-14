defmodule Ebanx.Accounts.Commands.Withdraw do
  @moduledoc """
  Handles a withdraw.

  When handles a withdraw, it's updated the balance.
  """

  import Ecto.Query, only: [lock: 2]

  require Logger

  alias Ebanx.Accounts
  alias Ebanx.Accounts.Account
  alias Ebanx.Accounts.Inputs.Withdraw
  alias Ebanx.Repo

  @type possible_errors :: :not_found | Ecto.Changeset.t()

  @spec execute(input :: Withdraw.t()) :: {:ok, Account.t()} | {:error, possible_errors()}
  def execute(input) do
    Logger.metadata(origin: input.origin, amount: input.amount)

    Repo.transaction(fn ->
      with %Account{} = account <- find_account(input),
           {:ok, account} <- do_withdraw(input.amount, account) do
        account
      else
        {:error, err} ->
          Logger.error("""
          Error processing Withdraw
          error: #{inspect(err)}
          """)

          Repo.rollback(err)

        err ->
          Logger.error("""
          Unexpected error processing Withdraw
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
