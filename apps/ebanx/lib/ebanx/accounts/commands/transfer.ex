defmodule Ebanx.Accounts.Commands.Transfer do
  @moduledoc """
  Handles a Transfer.

  When handles a transfer, it's updated the destination balance.
  """

  import Ecto.Query, only: [lock: 2]

  require Logger

  alias Ebanx.Accounts.Account
  alias Ebanx.Accounts
  alias Ebanx.Accounts.Inputs.Transfer
  alias Ebanx.Repo

  @type possible_errors :: nil | Ecto.Changeset.t()

  @spec execute(input :: Transfer.t()) :: {:ok, Account.t()} | {:error, possible_errors()}
  def execute(input) do
    Logger.metadata(origin: input.origin, amount: input.amount)

    Repo.transaction(fn ->
      with  %Account{} = origin <- find_account(input.origin),
            %Account{} = destination <- find_account_with_idempotency(input.destination),
           {:ok, origin} <- do_withdraw(input.amount, origin),
           {:ok, destination} <- do_debit(input.amount, destination) do
        {:ok, origin, destination}
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
      {:ok, accounts} ->
        {:ok, origin, destination} = accounts
        {:ok, origin, destination}
      {:error, err} ->
        {:error, err}
    end
  end

  defp do_withdraw(amount, origin) do
    balance = Decimal.sub(origin.balance, amount)

    origin
    |> Account.changeset(%{balance: balance})
    |> Repo.update()
  end

  defp do_debit(amount, destination) do
    balance = Decimal.add(destination.balance, amount)

    destination
    |> Account.changeset(%{balance: balance})
    |> Repo.update()
  end

  defp find_account(id) do
    queryable = Account |> lock("FOR UPDATE")

    case Repo.get_by(queryable, number: id) do
      nil ->
        {:error, :not_found}
      account ->
        account
    end
  end

  defp find_account_with_idempotency(id) do
    queryable = Account |> lock("FOR UPDATE")

    case Repo.get_by(queryable, number: id) do
      nil ->
        {:ok, account} = Accounts.register_account(%{number: id, balance: 0})
        account
      account -> account
    end
  end
end
