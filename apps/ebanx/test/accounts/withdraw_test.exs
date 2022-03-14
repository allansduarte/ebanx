defmodule Ebanx.Accounts.Commands.WithdrawTest do
  use Ebanx.DataCase, async: true

  import Ebanx.AccountsFixtures

  alias Ebanx.Accounts.Commands.Withdraw

  describe "Withdraw" do
    test "with existent account" do
      account = account_fixture(%{balance: 10})

      input = %{amount: 10, origin: account.number}

      assert {:ok, account} = Withdraw.execute(input)
      assert Decimal.equal?(account.balance, 0)
    end

    test "with invalid origin" do
      input = %{amount: 10, origin: 1234}

      assert {:error, :not_found} = Withdraw.execute(input)
    end
  end
end
