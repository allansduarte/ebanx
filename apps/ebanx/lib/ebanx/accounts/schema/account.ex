defmodule Ebanx.Accounts.Account do
  @moduledoc """
  Represents the accounts schema.

  This is used by user in order to create a withdraw, transfer, freeze or unfree operation.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  The account schema spec type.
  """
  @type t :: %__MODULE__{}

  @required [:number, :balance]

  schema "accounts" do
    field :number, :integer
    field :balance, :decimal

    timestamps()
  end

  @spec changeset(map()) :: Changeset.t()
  def changeset(params), do: create_changeset(%__MODULE__{}, params)

  @spec changeset(Ebanx.Account.t() | map(), map()) :: Changeset.t()
  def changeset(account, params), do: create_changeset(account, params)

  defp create_changeset(module_or_account, params) do
    module_or_account
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
