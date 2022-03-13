defmodule EbanxWeb.AccountsController do
  use EbanxWeb, :controller

  alias Ebanx.ChangesetValidation
  alias Ebanx.Inputs.Test
  alias Ebanx.Accounts.Inputs.Balance
  alias Ebanx.Accounts
  alias Ebanx.Accounts.Account

  action_fallback EbanxWeb.FallbackController

  @doc "Get the balance"
  @spec balance(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def balance(conn, params) do
    with {:ok, input} <- ChangesetValidation.cast_and_apply(Balance, params),
         %Account{} = account <- Accounts.balance_by_id(input.account_id) do
      conn
      |> put_status(:ok)
      |> render("balance.json", account: account)
    else
      nil -> {:error, :balance_not_found}
      err -> err
    end
  end
end
