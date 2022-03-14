defmodule Ebanx.Accounts do
  @moduledoc """
  Accounts context.
  """

  alias Ebanx.Accounts.Account
  alias Ebanx.Accounts.Commands.{Deposit, Transfer, Withdraw}
  alias Ebanx.Repo

  @doc "See `Ebanx.Accounts.Commands.Deposit.execute/1`"
  defdelegate deposit(input), to: Deposit, as: :execute

  @doc "See `Ebanx.Accounts.Commands.Deposit.execute/1`"
  defdelegate withdraw(input), to: Withdraw, as: :execute

  @doc "See `Ebanx.Accounts.Commands.Transfer.execute/1`"
  defdelegate transfer(input), to: Transfer, as: :execute

  def balance_by_id(number), do: Repo.get_by(Account, number: number)

  @doc """
  Registers an account.

  ## Examples

      iex> register_account(%{field: value})
      {:ok, %Account{}}

      iex> register_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
