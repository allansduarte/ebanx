defmodule Ebanx.Accounts.Commands.TransferTest do
  use Ebanx.DataCase, async: true

  import Ebanx.AccountsFixtures

  alias Ebanx.Accounts.Commands.Transfer

  describe "Transfer" do
    test "with existent account" do
      origin = account_fixture(%{balance: 10})
      destination = account_fixture(%{balance: 20})

      input = %{amount: 10, origin: origin.number, destination: destination.number}

      assert {:ok, origin, destination} = Transfer.execute(input)
      assert Decimal.equal?(destination.balance, 30)
      assert Decimal.equal?(origin.balance, 0)
    end

    test "with invalid destination" do
      origin = account_fixture()
      input = %{amount: 10, destination: 1234, origin: origin.number}

      assert {:error, :not_found} = Transfer.execute(input)
    end
  end
end
