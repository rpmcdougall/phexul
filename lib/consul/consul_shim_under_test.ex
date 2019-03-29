defmodule ConsulShim.UnderTest do

  def getkv(key) do

    if String.contains?(key, "serv99") do
      %{
        "hostname" => "serv99",
        "ip_addr" => "192.168.2.25",
        "os" => "cent7",
        "owner" => "admin",
        "role" => "sql"
      }
    else
      :error
    end


  end

  def deletekv(_key) do
   :ok
  end

  def updatekv(_key, %Server{hostname: _hostname} = _data) do
    :ok
  end

  def createkv(_key, %Server{hostname: _hostname} = _data) do
    :ok
  end

end
