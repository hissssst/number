defmodule Number.Delimit do
  @moduledoc """
  Provides functions to delimit numbers into strings.
  """

  alias Number.Application
  alias Number.Conversion

  @doc """
  Formats a number into a string with grouped thousands using `delimiter`.

  ## Parameters

  * `number` - A float or integer to convert.

  * `options` - A keyword list of options. See the documentation of all
    available options below for more information.

  ## Options

  * `:precision` - The number of decimal places to include. Default: 2

  * `:delimiter` - The character to use to delimit the number by thousands.
    Default: ","

  * `:separator` - The character to use to separate the number from the decimal
    places. Default: "."

  Default configuration for these options can be specified in the `Number`
  application configuration.

      config :number,
        format: [
          precision: 3,
          delimiter: ",",
          separator: "."
        ]

  ## Examples

      iex> Number.Delimit.number_to_delimited(nil)
      nil

      iex> Number.Delimit.number_to_delimited(998.999)
      "999.00"

      iex> Number.Delimit.number_to_delimited(-234234.234)
      "-234,234.23"

      iex> Number.Delimit.number_to_delimited("998.999")
      "999.00"

      iex> Number.Delimit.number_to_delimited("-234234.234")
      "-234,234.23"

      iex> Number.Delimit.number_to_delimited(12345678)
      "12,345,678.00"

      iex> Number.Delimit.number_to_delimited(12345678.05)
      "12,345,678.05"

      iex> Number.Delimit.number_to_delimited(12345678, delimiter: ".")
      "12.345.678.00"

      iex> Number.Delimit.number_to_delimited(12345678, delimiter: ",")
      "12,345,678.00"

      iex> Number.Delimit.number_to_delimited(12345678.05, separator: " ")
      "12,345,678 05"

      iex> Number.Delimit.number_to_delimited(98765432.98, delimiter: " ", separator: ",")
      "98 765 432,98"

      iex> Number.Delimit.number_to_delimited(Decimal.from_float(9998.2))
      "9,998.20"

      iex> Number.Delimit.number_to_delimited "123456789555555555555555555555555"
      "123,456,789,555,555,555,555,555,555,555,555.00"

      iex> Number.Delimit.number_to_delimited Decimal.new("123456789555555555555555555555555")
      "123,456,789,555,555,555,555,555,555,555,555.00"
  """
  @spec number_to_delimited(nil, any()) :: nil
  @spec number_to_delimited(Number.t(), Keyword.t() | Map.t()) :: String.t()
  def number_to_delimited(number, options \\ %{})
  def number_to_delimited(nil, _options), do: nil
  def number_to_delimited(number, options) do
    float = Conversion.to_float(number)
    %{} = options = Application.config(options)
    prefix = if float < 0, do: "-", else: ""

    delimited =
      case Conversion.to_integer(number) do
        {:ok, number} ->
          number = delimit_integer(number, options.delimiter)

          if options.precision > 0 do
            decimals = String.pad_trailing("", options.precision, "0")
            Enum.join([to_string(number), options.separator, decimals])
          else
            number
          end

        {:error, other} ->
          other
          |> to_string()
          |> Conversion.to_decimal()
          |> delimit_decimal(options.delimiter, options.separator, options.precision)
      end

    delimited = String.Chars.to_string(delimited)
    prefix <> delimited
  end

  defp delimit_integer(number, delimiter) do
    abs(number)
    |> Integer.to_charlist()
    |> :lists.reverse()
    |> delimit_integer(delimiter, [])
  end

  defp delimit_integer([a, b, c, d | tail], delimiter, acc) do
    delimit_integer([d | tail], delimiter, [delimiter, c, b, a | acc])
  end

  defp delimit_integer(list, _, acc) do
    :lists.reverse(list) ++ acc
  end

  @doc false
  def delimit_decimal(decimal, delimiter, separator, precision) do
    string =
      decimal
      |> Decimal.round(precision)
      |> Decimal.to_string(:normal)

    [number, decimals] =
      case String.split(string, ".") do
        [number, decimals] -> [number, decimals]
        [number] -> [number, ""]
      end

    decimals = String.pad_trailing(decimals, precision, "0")

    integer =
      number
      |> String.to_integer()
      |> delimit_integer(delimiter)

    separator = if precision == 0, do: "", else: separator
    Enum.join([integer, separator, decimals])
  end
end
