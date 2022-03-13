defmodule EbanxWeb.FallbackController do
  use EbanxWeb, :controller

  alias EbanxWeb.{ChangesetView, ErrorView}

  @urn_params "ern:error:invalid_params"

  @validation_errors [:invalid_params]

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ChangesetView)
    |> render("changeset_error.json", %{
      type: @urn_params,
      reason: :invalid_params,
      changeset: changeset
    })
  end

  def call(conn, {:error, reason}) when reason in @validation_errors do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("error.json", %{
      type: @urn_params,
      reason: :validation_error,
      error: reason
    })
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:bad_request)
    |> put_view(EbanxWeb.ErrorView)
    |> render("error.json", %{type: @urn_params, reason: reason})
  end
end
