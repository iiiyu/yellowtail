defmodule Toolkit.Helper do
  def remove_zero(hex_string) do
    hex_string
    |> String.slice(2..-1)
    |> String.to_integer(16)
    |> Integer.to_string(16)
  end

  def to_address(hex_string) do
    hex_string |> remove_zero() |> then(&("0x" <> &1))
  end

  def to_hex_list(hex_string) do
    data = hex_string
    sub_string_length = 32

    for i <- 0..(div(String.length(data), sub_string_length) - 1) do
      String.slice(data, i * sub_string_length, sub_string_length)
    end
  end
end
