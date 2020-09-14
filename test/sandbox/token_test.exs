defmodule Sandbox.TokenTest do
  use Sandbox.DataCase

  alias Sandbox.Data.Token

  @valid_params {"api", "666666666.00", 321}
  @invalid_params {"api", "-666666666.00", 321}

  describe "token" do
    test "encrypt and decrypt token" do
      token = Token.generate_token(@valid_params)
      decrypted = Token.decrypt_token(token)

      assert decrypted == @valid_params
    end

    test "error encrypt token" do
      assert_raise ArgumentError, fn -> Token.generate_token(@invalid_params) end
    end

    test "generate_random_token/1" do
      token_type = "api"

      token = Token.generate_random_token(token_type)
      {decrypted_token_type, _balance, _offset} = Token.decrypt_token(token)

      assert decrypted_token_type == token_type
    end
  end
end
