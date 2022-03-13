defmodule Ebanx.Accounts.Inputs.Balance do
  @moduledoc """
  Input to get a balance.
  """

  use Ebanx.ValueObjectSchema

  @required [:account_id]

  embedded_schema do
    field :account_id, :integer
  end

  @doc false
  def changeset(model, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
