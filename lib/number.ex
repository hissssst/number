defmodule Number do
  @moduledoc """
  `Number` provides functions to convert numbers into a variety of different
  formats. Ultimately, it aims to be a partial clone of
  [ActionView::Helpers::NumberHelper](http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html)
  from Rails.

  If you want to import all of the functions provided by `Number`, simply `use`
  it in your module:

      defmodule MyModule do
        use Number
      end

  More likely, you'll want to import the functions you want from one of
  `Number`'s submodules.

      defmodule MyModule do
        import Number.Currency
      end

  ## Configuration

  Some of `Number`'s behavior can be configured through Mix. Each submodule
  contains documentation on how to configure it.
  """

  @type t :: number() | Decimal.t()

  @doc false
  defmacro __using__(_) do
    quote do
      import Number.Currency
      import Number.Delimit
      import Number.Phone
      import Number.Percentage
      import Number.Human
    end
  end

  defdelegate to_currency(number, opts \\ %{}),
    to: Number.Currency,
    as: :number_to_currency

  defdelegate to_delimited(number, opts \\ %{}),
    to: Number.Delimit,
    as: :number_to_delimited

  defdelegate to_phone(number, opts \\ %{}),
    to: Number.Phone,
    as: :number_to_phone

  defdelegate to_percentage(number, opts \\ %{}),
    to: Number.Percentage,
    as: :number_to_percentage

  defdelegate to_human(number, opts \\ %{}),
    to: Number.Human,
    as: :number_to_human

  defdelegate to_ordinal(number),
    to: Number.Human,
    as: :number_to_ordinal
end
