defmodule Sandbox.Data.Token do
  alias Apa
  alias Bitwise

  @private_key_1 215_732_071_525
  @private_key_2 270_248_626_247
  @private_key_3 193_839_617_024

  # example generate keys
  # def random_key(len) do
  #   :crypto.strong_rand_bytes(len)
  #   |> :crypto.bytes_to_integer()
  # end

  def generate_token({type, balance, amount_offset, description_offset})
      when is_binary(type)
      when is_binary(balance)
      when is_binary(amount_offset)
      when is_binary(description_offset) do
    enc_balance = encrypt(balance, @private_key_1)
    enc_amount_offset = encrypt(amount_offset, @private_key_2)
    enc_description_offset = encrypt(description_offset, @private_key_3)

    "test_#{type}_#{enc_balance}_#{enc_amount_offset}_#{enc_description_offset}"
  end

  def decrypt_token(token) when is_binary(token) do
    [_test, type, enc_balance, enc_amount_offset, enc_description_offset] =
      String.split(token, "_")

    balance = decrypt(enc_balance, @private_key_1)
    amount_offset = decrypt(enc_amount_offset, @private_key_2)
    description_offset = decrypt(enc_description_offset, @private_key_3)

    {type, "#{balance}", "#{amount_offset}", "#{description_offset}"}
  end

  def encrypt(token_part, private_key) do
    token_part
    |> clean_string_to_int()
    |> Bitwise.^^^(private_key)
    |> :binary.encode_unsigned()
    |> Base.url_encode64()
  end

  def decrypt(encrypted, private_key) do
    encrypted
    |> Base.url_decode64!()
    |> :binary.decode_unsigned()
    |> Bitwise.^^^(private_key)
  end

  def clean_string_to_int(binary) do
    binary
    |> Apa.parse()
    |> Apa.to_string(-1, 0)
    |> String.to_integer()
  end
end
