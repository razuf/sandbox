defmodule Sandbox.Data.Token do
  alias Apa
  alias Bitwise

  @private_key_1 215_732_071_525
  @private_key_2 270_248_626_247

  # example generate keys
  # def random_key(len) do
  #   :crypto.strong_rand_bytes(len)
  #   |> :crypto.bytes_to_integer()
  # end

  def generate_token({_type, "-" <> _rest = balance, _offset}) do
    raise(ArgumentError, "Wrong balance: #{inspect(balance)}")
  end

  def generate_token({type, balance, offset})
      when is_binary(type) and
             is_binary(balance) and
             is_integer(offset) and
             offset > 0 do
    enc_balance =
      balance
      |> clean_balance_to_int()
      |> encrypt(@private_key_1)

    enc_offset = encrypt(offset, @private_key_2)

    "test_#{type}_#{enc_balance}_#{enc_offset}"
  end

  def decrypt_token(token) when is_binary(token) do
    case String.split(token, "_") do
      [_test, type, enc_balance, enc_offset] ->
        balance =
          enc_balance
          |> decrypt(@private_key_1)
          |> recreate_float_string()

        offset = decrypt(enc_offset, @private_key_2)

        {type, "#{balance}", offset}

      _ ->
        :error
    end
  end

  defp encrypt(token_part_int, private_key) do
    token_part_int
    |> Bitwise.^^^(private_key)
    |> :binary.encode_unsigned()
    |> Base.url_encode64()
  end

  defp decrypt(encrypted, private_key) do
    encrypted
    |> Base.url_decode64!()
    |> :binary.decode_unsigned()
    |> Bitwise.^^^(private_key)
  end

  defp clean_balance_to_int(binary) do
    binary
    |> Apa.mul("100")
    |> Apa.parse()
    |> Apa.abs()
    |> Apa.to_string(-1, 0)
    |> String.to_integer()
  end

  defp recreate_float_string(int_value) do
    int_value
    |> Apa.div("100")
  end
end
