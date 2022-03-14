defmodule Ebanx.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ebanx.Accounts` context.
  """

  alias Ebanx.Accounts

  def valid_balance, do: 0

  def valid_account_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      number: :rand.uniform(9999),
      balance: valid_balance()
    })
  end

  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> valid_account_attributes()
      |> Accounts.register_account()

    account
  end

  defp build_user() do

  end
end
