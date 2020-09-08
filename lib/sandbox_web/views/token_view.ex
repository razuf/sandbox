defmodule SandboxWeb.TokenView do
  use SandboxWeb, :view
  alias SandboxWeb.TokenView

  def render("token.json", %{token: token}) do
    %{
      token: token
    }
  end
end
