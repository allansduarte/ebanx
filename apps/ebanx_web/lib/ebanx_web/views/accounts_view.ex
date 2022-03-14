defmodule EbanxWeb.AccountsView do
  use EbanxWeb, :view

  def render("balance.json", %{account: account}) do
    Decimal.to_integer(account.balance)
  end

  def render("deposit.json", %{account: account}) do
    %{
      destination: render_one(account, __MODULE__, "balance.json")
    }
  end

  def render("withdraw.json", %{account: account}) do
    %{
      origin: render_one(account, __MODULE__, "balance.json")
    }
  end

  def render("transfer.json", %{origin: origin, destination: destination}) do
    %{
      destination: render_one(destination, __MODULE__, "balance.json"),
      origin: render_one(origin, __MODULE__, "balance.json")
    }
  end

  def render("balance.json", %{accounts: account}) do
    Jason.OrderedObject.new(
      id: Integer.to_string(account.number),
      balance: Decimal.to_integer(account.balance)
    )
  end
end
