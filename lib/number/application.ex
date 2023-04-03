defmodule Number.Application do
  use Application

  @ptkey {__MODULE__, :format_config}

  def start(_type, _args) do
    reload_config()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def config_change(changed, new, removed) do
    config =
      new
      |> Keyword.merge(changed)
      |> Keyword.drop(Keyword.keys(removed))
      |> Keyword.get(:format, %{})
      |> Map.new()

    config =
      %{
        delimiter: ",",
        separator: ".",
        precision: 2,
        unit: "$",
        format: "%u%n",
        negative_format: "-%u%n"
      }
      |> Map.merge(config)

    :persistent_term.put(@ptkey, config)
  end

  def reload_config do
    config_change([], [format: Application.get_env(:number, :format, [])], [])
  end

  def config(%{delimiter: _, separator: _, precision: _, unit: _, format: _, negative_format: _} = x) do
    x
  end
  def config(overrides) do
    Map.merge(:persistent_term.get(@ptkey), Map.new(overrides))
  end

end
