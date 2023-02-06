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
end
