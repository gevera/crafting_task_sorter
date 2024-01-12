# CraftingSoftware

**Description**

- clone the repo
- make sure to have Elixir installed
- ```mix deps.get``` to get the dependencies
- ```iex -S mix``` to run the project

There are two endpoints in order to check the functionality of the service

- ```POST /process``` to get a JSON response with properly sorted tasks 
- ```POST /bash``` to get a multiline string response with a bash script

Both of the requests require a body with correct tasks 

Here is an example of a body

```json
{
	"tasks": [
		{
			"name": "task-1",
			"command": "touch /tmp/file1"
		},
		{
			"name": "task-2",
			"command": "cat /tmp/file1",
			"requires": [
				"task-3"
			]
		},
		{
			"name": "task-3",
			"command": "echo 'Hello World!' > /tmp/file1",
			"requires": [
				"task-1"
			]
		},
		{
			"name": "task-4",
			"command": "rm /tmp/file1",
			"requires": [
				"task-2",
				"task-3"
			]
		}
	]
}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `crafting_software` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:crafting_software, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/crafting_software>.

