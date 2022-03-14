defmodule Ebanx.Accounts.Commands.DepositTest do
  use Ebanx.DataCase, async: true

  import Ebanx.AccountsFixtures

  alias Ebanx.Accounts.Commands.Deposit

  describe "Deposit" do
    test "with existent account" do
      account = account_fixture()

      input = %{amount: 10, destination: account.id}

      assert {:ok, account} = Deposit.execute(input)
      assert Decimal.equal?(account.balance, 10)
    end

    test "creates account with invalid destination" do
      input = %{amount: 10, destination: 1234}

      assert {:ok, account} = Deposit.execute(input)
      assert Decimal.equal?(account.balance, 10)
    end
  end
end
