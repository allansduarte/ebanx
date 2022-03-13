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
end
