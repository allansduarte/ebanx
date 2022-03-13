defmodule Ebanx.AccountsTest do
  use Ebanx.DataCase, async: true

  import Ebanx.AccountsFixtures

  alias Ebanx.Accounts.Account
  alias Ebanx.Accounts

  describe "balance_by_id/1" do
    test "with valid account id" do
      account = account_fixture(%{balance: 100})
      id = account.id

      assert %Account{id: ^id, balance: balance} = Accounts.balance_by_id(account.id)
      assert Decimal.equal?(balance, 100)
    end

    test "with invalid account id" do
      id = 1234

      refute Accounts.balance_by_id(id)
    end
  end
end
