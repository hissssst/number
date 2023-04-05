# Number

`Number` is an [Elixir](https://github.com/elixir-lang/elixir) library which
provides functions to convert numbers into a variety of different formats.
Ultimately, it aims to be a partial clone of
[ActionView::Helpers::NumberHelper](http://api.rubyonrails.org/classes/ActionView/Helpers/NumberHelper.html)
from Rails.

```elixir
Number.Currency.number_to_currency(2034.46)
"$2,034.46"

Number.Phone.number_to_phone(1112223333, area_code: true, country_code: 1)
"+1 (111) 222-3333"

Number.Percentage.number_to_percentage(100, precision: 0)
"100%"

Number.Human.number_to_human(1234)
"1.23 Thousand"

Number.Delimit.number_to_delimited(12345678)
"12,345,678"
```

## Installation

Get it from Hex:

```elixir
defp deps do
  [{:number, "~> 1.0.1"}]
end
```

Then run `mix deps.get`.

## Usage

If you want to import all of the functions provided by `Number`, simply `use`
it in your module:

```elixir
defmodule MyModule do
  use Number
end
```

More likely, you'll want to import the functions you want from one of
`Number`'s submodules.

```elixir
defmodule MyModule do
  import Number.Currency
end
```

See the [Hex documentation](http://hexdocs.pm/number/) for more information
about the modules provided by `Number`.

## License
MIT. See [LICENSE](https://github.com/danielberkompas/number/blob/master/LICENSE) for more details.
