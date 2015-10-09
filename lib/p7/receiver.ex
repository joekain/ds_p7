# This is effectively needs to be an infinite blocking queue (blocks when empty)
# Can I implement an infinite blocking queue by passing size of :infinity and comparison against maximum size always fails?
defmodule P7.Receiver do
  use ExActor.GenServer

  defstart start_link(pool) do
    {:ok, queue} = BlockingQueue.start_link(:infinity)
    initial_state {pool, queue}
  end

  defhandleinfo {:result, worker, result}, state: {pool, queue} do
    :poolboy.checkin(pool, worker)
    BlockingQueue.push(queue, result)
    new_state({pool, queue})
  end

  defcall get_queue, state: {pool, queue} do
    set_and_reply({pool, queue}, queue)
  end

  def get(pid) do
    queue = get_queue(pid)
    BlockingQueue.pop(queue)
  end
end
