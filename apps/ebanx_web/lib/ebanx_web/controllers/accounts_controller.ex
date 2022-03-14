defmodule EbanxWeb.AccountsController do
  use EbanxWeb, :controller

  alias Ebanx.Accounts
  alias Ebanx.Accounts.Account
  alias Ebanx.ChangesetValidation
  alias Ebanx.Inputs.Test
  alias Ebanx.Accounts.Inputs.{Balance, Deposit}

  action_fallback EbanxWeb.FallbackController

  @doc "Get the balance"
  @spec balance(Conn.t(), params :: map()) :: Conn.t()
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

  @doc "Handles an operation"
  @spec event(conn :: Conn.t(), params :: map()) :: Conn.t()
  def event(conn, %{"type" => "deposit"} = params) do
    with {:ok, input} <- ChangesetValidation.cast_and_apply(Deposit, params),
         {:ok, account} <- Accounts.deposit(input) do
      conn
      |> put_status(:created)
      |> render("deposit.json", account: account)
    end
  end
end
