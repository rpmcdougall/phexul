defmodule Server do
  @derive[Poison.Encoder]
  defstruct [:hostname, :role, :ip_addr, :owner, :os]
end
