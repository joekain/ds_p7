defmodule P7.Worker do
  use ExActor.GenServer

  defstart start_link(_), do: initial_state(0)

  defcast work({caller, x}) do
    send caller, {:result, self, x + 1}
    new_state(0)
  end
end
