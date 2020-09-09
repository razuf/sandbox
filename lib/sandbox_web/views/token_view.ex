defmodule SandboxWeb.TokenView do
  use SandboxWeb, :view

  def render("token.json", %{token: token}) do
    %{
      token: token
    }
  end
end
