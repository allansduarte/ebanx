defmodule EbanxWeb.AccountsControllerTest do
  use EbanxWeb.ConnCase, async: true

  import Ebanx.AccountsFixtures

  describe "GET /api/balance" do
    test "Get balance for existing account", ctx do
      account = account_fixture(%{balance: 20})

      assert 20 ==
               ctx.conn
               |> get("/api/balance", %{account_id: account.id})
               |> json_response(200)
    end

    test "Get balance for non-existing account", ctx do
      assert 0 ==
               ctx.conn
               |> get("/api/balance", %{account_id: 1234})
               |> json_response(404)
    end
  end

  describe "POST /api/event" do
    test "Create account with initial balance", ctx do
      assert %{"destination" => %{"balance" => "10", "id" => _id}} =
               ctx.conn
               |> post("/api/event", %{type: "deposit", destination: 100, amount: 10})
               |> json_response(201)
    end

    test "Deposit into existing account", ctx do
      account = account_fixture(%{balance: 10})
      account_id = account.id

      assert %{"destination" => %{"balance" => "20", "id" => ^account_id}} =
               ctx.conn
               |> post("/api/event", %{type: "deposit", destination: account.id, amount: 10})
               |> json_response(201)
    end
  end
end
