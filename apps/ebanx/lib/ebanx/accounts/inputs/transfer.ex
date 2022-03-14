defmodule Ebanx.Accounts.Inputs.Transfer do
  @moduledoc """
  Input to get a transfer.
  """

  use Ebanx.ValueObjectSchema

  @required [:type, :destination, :origin, :amount]
  @valid_type ~w{transfer}

  embedded_schema do
    field :type, :string
    field :destination, :integer
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
