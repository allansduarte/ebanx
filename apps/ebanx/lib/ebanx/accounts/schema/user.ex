defmodule Ebax.Accounts.User do
  @moduledoc """
  Represents the user schema.

  This is used for personal user data.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  The user schema spec type.
  """
  @type t :: %__MODULE__{}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @required [:first_name, :last_name, :email]

  schema "accounts" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    timestamps()
  end

  @spec changeset(map()) :: Changeset.t()
  def changeset(params), do: create_changeset(%__MODULE__{}, params)

  @spec changeset(Ebanx.Account.t() | map(), map()) :: Changeset.t()
  def changeset(account, params), do: create_changeset(account, params)

  defp create_changeset(module_or_account, params) do
    module_or_account
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
