defmodule Sandbox.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Sandbox.Data

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Sandbox.DataCase
    end
  end
end
