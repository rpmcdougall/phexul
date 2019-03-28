defmodule ConsulShim do
  alias Consul.HTTP.Raw, as: ConsulRaw

  def getkv(key) do
    try do
      %Consul.KV{value: kv} = Consul.KV.get(key)
      kv
    rescue
      ArgumentError -> :error
    end
  end

  def deletekv(key) do
    %HTTPoison.Response{status_code: status} = ConsulRaw.kv_delete(key)

    case status do
      200 ->
        :ok

      _ ->
        :error
    end
  end

  def putkv(key, data) do
    try do
      ConsulRaw.kv_put(key, data)
    rescue
      ArgumentError -> :error
    end
  end
end
