defmodule EbanxWeb.AccountsView do
  use EbanxWeb, :view

  def render("balance.json", %{account: account}) do
    Decimal.to_integer(account.balance)
  end

  def render("deposit.json", %{account: account}) do
    %{
      destination: %{
        id: account.number,
        balance: account.balance
      }
    }
  end

  def render("withdraw.json", %{account: account}) do
    %{
      origin: %{
        id: account.number,
        balance: account.balance
      }
    }
  end
end
