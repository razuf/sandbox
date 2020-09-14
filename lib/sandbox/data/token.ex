defmodule Sandbox.Data.Token do
  alias Apa
  alias Bitwise

  @private_key_balance 215_732_071_525
  @private_key_offset 270_248_626_247

  def random_key(len) do
    :crypto.strong_rand_bytes(len)
    |> :crypto.bytes_to_integer()
  end

  def generate_random_token(type) do
    balance = random_key(4) |> to_string()
    offset = random_key(4)
    generate_token({type, balance, offset})
  end

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
      |> encrypt(@private_key_balance)

    enc_offset = encrypt(offset, @private_key_offset)

    "test_#{type}_#{enc_balance}_#{enc_offset}"
  end

  def decrypt_token(token) when is_binary(token) do
    case String.split(token, "_") do
      [_test, type, enc_balance, enc_offset] ->
        balance =
          enc_balance
          |> decrypt(@private_key_balance)
          |> recreate_float_string()

        offset = decrypt(enc_offset, @private_key_offset)

        {type, "#{balance}", offset}

      _ ->
        :error
    end
  end

  defp encrypt(token_part_int, private_key) do
    token_part_int
    |> Bitwise.^^^(private_key)
    |> :binary.encode_unsigned()
    |> Base.encode32(padding: false)
  end

  defp decrypt(encrypted, private_key) do
    encrypted
    |> Base.decode32!(padding: false)
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
