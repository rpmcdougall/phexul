defmodule UtilTest do
  use ExUnit.Case
  doctest Util

  # "setup" is called before each test
  setup do
    mock_serv = %Server{
      hostname: "serv99",
      ip_addr: "192.168.2.25",
      os: "cent7",
      owner: "admin",
      role: "web"
    }

    ServerOps.create_server(mock_serv)

    on_exit(fn ->
      ServerOps.delete_server("serv99")
    end)
  end

  test "config_exists? finds existing config" do
    assert Util.config_exists?("serv99") == :exists
  end

  test "config_exists? returns :config_not_found atom for missing config" do
    assert Util.config_exists?("tHisSeRvErDoEsNoTeXiSt") == :config_not_found
  end
end
