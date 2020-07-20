defmodule Chat.Result do
  @spec ok(term()) :: {:ok, term()}
  def ok(elt), do: {:ok, elt}

  @type persist(struct) :: {:ok, struct} | {:error, Ecto.Changeset.t()}
end
