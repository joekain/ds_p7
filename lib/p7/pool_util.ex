defmodule P7.PoolUtil do
  def into(enum, col, opts) do
    pool = opts[:via]
    {:ok, receiver} = P7.Receiver.start_link(pool)

    spawn_link fn ->
      enum
      |> Enum.map(fn x -> {x, :poolboy.checkout(pool)} end)
      |> Enum.map(fn {x, worker} -> P7.Worker.work(worker, {receiver, x}) end)
    end

    Stream.repeatedly(fn -> P7.Receiver.get(receiver) end)
    |> Stream.into(col, fn x -> x end)
  end
end
