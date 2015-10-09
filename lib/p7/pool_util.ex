defmodule P7.PoolUtil do
  defp stream_through_pool(enum, pool, queue) do
    enum
    |> Enum.map(fn x -> {x, :poolboy.checkout(pool)} end)
    |> Enum.map(fn {x, worker} -> P7.Worker.work(worker, queue, x) end)
  end

  defp extract_and_checkin(stream, pool) do
    Stream.map stream, fn {worker, result} ->
      :poolboy.checkin(pool, worker)
      result
    end
  end

  def into(enum, col, opts) do
    pool = opts[:via]
    {:ok, queue} = BlockingQueue.start_link(:infinity)

    spawn_link fn -> stream_through_pool(enum, pool, queue) end

    queue
    |> BlockingQueue.pop_stream
    |> extract_and_checkin(pool)
    |> Stream.into(col, fn x -> x end)
  end
end
