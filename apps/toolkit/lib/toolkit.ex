defmodule Toolkit do
  alias Ethereumex.HttpClient
  alias Toolkit.Helper

  @moduledoc """
  Documentation for `Toolkit`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Toolkit.hello()
      :world

  """
  def hello do
    :world
  end

  def test do
    result = HttpClient.eth_protocol_version()
    result
  end

  def get_uniswap_v2_all_pairs_length do
    contract_address = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"

    abi_encoded_data = ABI.encode("allPairsLength()", []) |> Base.encode16(case: :lower)

    {:ok, all_pairs_length_bytes} =
      HttpClient.eth_call(%{data: "0x" <> abi_encoded_data, to: contract_address})

    all_pairs_length_bytes
    |> String.slice(2..-1)
    |> String.to_integer(16)
  end

  def get_information(index) do
    # uniswapFactory
    uniswap_factory_address = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"

    abi_all_paris_encoded_data =
      ABI.encode("allPairs(uint)", [index]) |> Base.encode16(case: :lower)

    {:ok, pair_contract_address_hex} =
      HttpClient.eth_call(%{data: "0x" <> abi_all_paris_encoded_data, to: uniswap_factory_address})

    pair_contract_address =
      pair_contract_address_hex
      |> Helper.to_address()

    abi_token_0_encoded_data = ABI.encode("token0()", []) |> Base.encode16(case: :lower)
    abi_token_1_encoded_data = ABI.encode("token1()", []) |> Base.encode16(case: :lower)

    {:ok, token_0_address_hex} =
      HttpClient.eth_call(%{data: "0x" <> abi_token_0_encoded_data, to: pair_contract_address})

    token_0_address = token_0_address_hex |> Helper.to_address()

    {:ok, token_1_address_hex} =
      HttpClient.eth_call(%{data: "0x" <> abi_token_1_encoded_data, to: pair_contract_address})

    token_1_address = token_1_address_hex |> Helper.to_address()

    abi_name_encoded_data = ABI.encode("name()", []) |> Base.encode16(case: :lower)
    abi_symbol_encoded_data = ABI.encode("symbol()", []) |> Base.encode16(case: :lower)
    abi_total_supply_encoded_data = ABI.encode("totalSupply()", []) |> Base.encode16(case: :lower)

    {:ok, token_0_name_hex} =
      HttpClient.eth_call(%{data: "0x" <> abi_name_encoded_data, to: token_0_address})

    {:ok, token_0_symbol_hex} =
      HttpClient.eth_call(%{data: "0x" <> abi_symbol_encoded_data, to: token_0_address})

    {:ok, token_0_total_supply_hex} =
      HttpClient.eth_call(%{data: "0x" <> abi_total_supply_encoded_data, to: token_0_address})

    # token_0_symbol_hex
    # |> String.slice(2..-1)
    # |> Base.decode16!(case: :lower)
    # |> TypeDecoder.decode_raw([{:uint, 256}])
    # |> List.first()

    token_0_name =
      token_0_name_hex
      |> String.slice(2..-1)
      |> Base.decode16!(case: :lower)
      |> ABI.TypeDecoder.decode(%ABI.FunctionSelector{
        function: nil,
        types: [
          :string
        ]
      })

    token_0_symbol =
      token_0_symbol_hex
      |> String.slice(2..-1)
      |> Base.decode16!(case: :lower)
      |> ABI.TypeDecoder.decode(%ABI.FunctionSelector{
        function: nil,
        types: [
          :string
        ]
      })

    token_0_total_supply =
      token_0_total_supply_hex
      |> String.slice(2..-1)
      |> Base.decode16!(case: :lower)
      |> ABI.TypeDecoder.decode(%ABI.FunctionSelector{
        function: nil,
        types: [
          {:uint, 256}
        ]
      })

    {{:token0, token_0_name, token_0_symbol, token_0_total_supply}, {:token1}}

    # ABI.decode("(string)", data)

    # |> Helper.to_hex_list()
    # |> List.flatten()
    # |> Enum.map(fn i -> Hexate.decode_to_list(i) end)

    # sub_string_length = 32

    # for i <- 0..(div(String.length(data), sub_string_length) - 1) do
    #   String.slice(data, i * sub_string_length, sub_string_length)
    #   |> Hexate.decode_to_list()
    #   |> Kernel.inspect()
    # end
  end
end
