defmodule EbanxWeb.AccountsControllerTest do
  use EbanxWeb.ConnCase, async: true

  import Ebanx.AccountsFixtures

  describe "GET /balance" do
    test "Get balance for existing account", ctx do
      account = account_fixture(%{balance: 20})

      assert 20 ==
               ctx.conn
               |> get("/balance", %{account_id: account.number})
               |> json_response(200)
    end

    test "Get balance for non-existing account", ctx do
      assert 0 ==
               ctx.conn
               |> get("/balance", %{account_id: 1234})
               |> json_response(404)
    end
  end

  describe "POST /event" do
    test "Create account with initial balance", ctx do
      assert %{"destination" => %{"balance" => "10", "id" => 100}} =
               ctx.conn
               |> post("/event", %{type: "deposit", destination: 100, amount: 10})
               |> json_response(201)
    end

    test "Deposit into existing account", ctx do
      account = account_fixture(%{balance: 10})
      account_number = account.number

      assert %{"destination" => %{"balance" => "20", "id" => ^account_number}} =
               ctx.conn
               |> post("/event", %{type: "deposit", destination: account.number, amount: 10})
               |> json_response(201)
    end

    test "Withdraw from non-existing account", ctx do
      assert 0 ==
               ctx.conn
               |> post("/event", %{type: "withdraw", origin: 200, amount: 10})
               |> json_response(404)
    end

    test "Withdraw from existing account", ctx do
      account = account_fixture(%{balance: 10})
      account_number = account.number

      assert %{"origin" => %{"balance" => "0", "id" => ^account_number}} =
               ctx.conn
               |> post("/event", %{type: "withdraw", origin: account.number, amount: 10})
               |> json_response(201)
    end

    test "Transfer from existing account", ctx do
      origin = account_fixture(%{balance: 10})
      destination = account_fixture(%{balance: 20})

      origin_number = origin.number
      destination_number = destination.number

      assert %{"destination" => %{"balance" => "30", "id" => ^destination_number}, "origin" => %{"balance" => "0", "id" => ^origin_number}} =
               ctx.conn
               |> post("/event", %{type: "transfer", origin: origin.number, destination: destination.number, amount: 10})
               |> json_response(201)
    end

    test "Transfer from non-existing origin account", ctx do
      origin = account_fixture(%{balance: 20})

      assert 0 =
               ctx.conn
               |> post("/event", %{type: "transfer", origin: origin.number, destination: 1234, amount: 10})
               |> json_response(404)
    end

    test "Transfer from non-existing destination account", ctx do
      destination = account_fixture(%{balance: 20})

      assert 0 =
               ctx.conn
               |> post("/event", %{type: "transfer", origin: 1234, destination: destination.number, amount: 10})
               |> json_response(404)
    end
  end
end
