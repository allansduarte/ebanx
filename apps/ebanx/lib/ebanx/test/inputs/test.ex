defmodule Ebanx.Inputs.Test do
  @moduledoc """
  Input for test border layer
  """

  use Ebanx.ValueObjectSchema

  @required [:id, :name]

  embedded_schema do
    field :id, :string
    field :name, :string
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(model, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
