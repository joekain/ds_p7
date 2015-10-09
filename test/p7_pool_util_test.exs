defmodule P7.PoolUtilTest do
  use ExUnit.Case
  alias P7.PoolUtil

  test "it should collect via the the pool" do
    assert [2, 3, 4] ==
      [1, 2, 3]
      |> PoolUtil.into([], via: P7.pool_name())
      |> Enum.take(3)
      |> Enum.sort
  end
end
