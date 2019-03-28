# Phexul

**ph** (**_Phoenix_**) **ex** (**_Elixir_**) **ul** (**_Consul_**) is a demo application for me to learn some Phoenix and Elixir using some familiarity I have with Consul.

This api will take some server config and store it as a KV pair in Consul to which you can also read back, update or delete.

### Endpoints

| Path                     | Method | Description                                            |
| ------------------------ | ------ | ------------------------------------------------------ |
| /api/config/:server_name | GET    | Returns a server config                                |
| /api/config              | POST   | Creates a new server config (Requires Body)            |
| /api/config/:server_name | PUT    | Updates a server config with a new one (Requires Body) |
| /api/config/:server_name | DELETE | Removes a server config                                |

A sample config body might look like:

```
{
	"hostname": "serv3",
	"ip_addr": "192.168.2.25",
	"os": "cent7",
	"owner": "admin",
	"role": "web"
}
```

## Running tests

Tests currently require a runnining instance of Consul. You can start up a Consul instance with the included docker compose file by running:

```
docker-compose up -d
```

Tests can be run with

```
mix test
```

## Todo

- Register Consul Services to monitor real servers with health checks
- Setup CI
- Deploy somewhere?

## Usage

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Start Phoenix endpoint with `mix phx.server`
