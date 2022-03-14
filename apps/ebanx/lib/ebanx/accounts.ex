defmodule Ebanx.Accounts do
  @moduledoc """
  Accounts context.
  """

  alias Ebanx.Accounts.Account
  alias Ebanx.Accounts.Commands.Deposit
  alias Ebanx.Repo

  @doc "See `Ebanx.Accounts.Commands.Deposit.execute/2`"
  defdelegate deposit(input), to: Deposit, as: :execute

  def balance_by_id(id), do: Repo.get(Account, id)

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
