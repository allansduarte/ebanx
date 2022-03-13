defmodule EbanxWeb.PageController do
  use EbanxWeb, :controller

  alias Ebanx.ChangesetValidation
  alias Ebanx.Inputs.Test

  action_fallback EbanxWeb.FallbackController

  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
    Test border layer
  """
  def test(conn, params) do
    with {:ok, input} <- ChangesetValidation.cast_and_apply(Test, params) do
      IO.inspect input
      send_resp(conn, 200, "")
    end
  end
end
