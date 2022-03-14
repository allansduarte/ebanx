defmodule EbanxWeb.AccountsView do
  use EbanxWeb, :view

  def render("balance.json", %{account: account}) do
    Decimal.to_integer(account.balance)
  end

  def render("deposit.json", %{account: account}) do
    %{
      destination: %{
        balance: account.balance,
        id: account.number
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

  def render("transfer.json", %{origin: origin, destination: destination}) do
    %{
      origin: %{
        balance: origin.balance,
        id: origin.number
      },
      destination: %{
        balance: destination.balance,
        id: destination.number
      }
    }
  end
end
