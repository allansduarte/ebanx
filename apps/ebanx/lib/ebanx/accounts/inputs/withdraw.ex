defmodule Ebanx.Accounts.Inputs.Withdraw do
  @moduledoc """
  Input to get a withdraw.
  """

  use Ebanx.ValueObjectSchema

  @required [:type, :origin, :amount]
  @valid_type ~w{withdraw}

  embedded_schema do
    field :type, :string
    field :origin, :integer
    field :amount, :integer
  end

  @doc false
  def changeset(model, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:type, @valid_type)
  end
end
