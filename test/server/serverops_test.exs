defmodule ServerOpsTest do
  use ExUnit.Case
  doctest Util

  # "setup" is called before each test
  setup do
    on_exit(fn ->
      Consul.HTTP.Raw.kv_delete("/server/config/serv99.json")
    end)
  end

  test "create server successfully creates a server config" do
    mock_serv = %Server{
      hostname: "serv99",
      ip_addr: "192.168.2.25",
      os: "cent7",
      owner: "admin",
      role: "web"
    }

    %{"hostname" => hostname} = ServerOps.create_server(mock_serv)
    assert hostname == "serv99"
  end

  test "get_server will sucessfully fetch a config" do
    mock_serv = %Server{
      hostname: "serv99",
      ip_addr: "192.168.2.25",
      os: "cent7",
      owner: "admin",
      role: "web"
    }

    ServerOps.create_server(mock_serv)
    %{"hostname" => hostname} = ServerOps.get_server("serv99")
    assert hostname == "serv99"
  end

  test "delete_server will sucessfully remove a server" do
    mock_serv = %Server{
      hostname: "serv99",
      ip_addr: "192.168.2.25",
      os: "cent7",
      owner: "admin",
      role: "web"
    }

    ServerOps.create_server(mock_serv)
    ServerOps.delete_server("serv99")
    assert ServerOps.get_server("serv99") == :error
  end

  test "update_server will sucessfully update a value on a server" do
    mock_serv = %Server{
      hostname: "serv99",
      ip_addr: "192.168.2.25",
      os: "cent7",
      owner: "admin",
      role: "web"
    }

    updated = %Server{
      hostname: "serv99",
      ip_addr: "192.168.2.29",
      os: "cent8",
      owner: "admin2",
      role: "sql"
    }

    ServerOps.create_server(mock_serv)
    ServerOps.update_server("serv99", updated)
    %{"role" => role} = ServerOps.get_server("serv99")
    assert role == "sql"
  end
end