defmodule Chat.Schema do
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      @timestamp_opts [type: :utc_datetime_usec]
    end
  end
end
