defmodule Mix.Tasks.Sandbox.Gen.TokenTest do
  use ExUnit.Case

  import Mix.Tasks.Sandbox.Gen.Token
  import ExUnit.CaptureIO

  test "mix sandbox.gen.token 999999.12 8" do
    token =
      capture_io(fn ->
        run(["999999.12", "8"])
      end)
      |> String.trim()

    assert token ==
             "Generated Api Token: test_api_GI7VPTGN_H3WBFSCP\n\nPut it in your config.exs or ENV vars."
  end

  test "mix sandbox.gen.token wrong params" do
    token =
      capture_io(fn ->
        run(["wrong_params"])
      end)
      |> String.trim()

    assert token ==
             "Wrong parameter please use: mix sandbox.gen.token start_balance:float offset:integer"
  end
end
