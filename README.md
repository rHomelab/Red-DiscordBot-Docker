# Red Discord Bot Docker

![Docker Hub Pulls](https://img.shields.io/docker/pulls/rhomelab/red-discordbot?logo=docker&label=docker%20hub%20pulls&style=for-the-badge)
![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/rhomelab/red-discordbot/latest?label=red%20version&logo=discord&style=for-the-badge)

[Red Discord Bot](https://discord.red), now containerised.

> [!NOTE]  
> This is an unsupported deployment method for Red. Do not expect support from the developers of Red Discord Bot if you run into any issues.

* [Tags](#tags)
* [Environment Variables](#environment-variables)
* [Setup](#setup)
  * [Prerequisites](#prerequisites)
  * [Running the bot with `docker compose`](#running-the-bot-with-docker-compose)
  * [Running the bot with `docker run`](#running-the-bot-with-docker-run)
* [Migrating from `rhomelab:labbot`](#migrating-from-rhomelablabbot)

## Tags

|   **Tags**   |                                  **Red version**                                 |
|:------------:|:--------------------------------------------------------------------------------:|
| `latest`     | [Latest release](https://github.com/Cog-Creators/Red-DiscordBot/releases/latest) |
| x.x.x        | See tag                                                                          |

## Environment Variables

| Name                      | Description                                                                                                                                                            |
|---------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `INSTANCE_NAME`           | The name of your Red Bot instance.<br>Example: `MyBot`                                                                                                                 |
| `PREFIX`                  | Your bot's command prefix.<br>Example: `!`                                                                                                                             |
| `TOKEN`                   | Your bot token from Discord Developers.                                                                                                                                |
| `RPC_ENABLED`             | Whether [RPC](https://docs.discord.red/en/stable/framework_rpc.html) is enabled or not.<br>Options: `true` or `false` <br>Default: `false`                             |
| `RPC_PORT`                | The port used by Red's RPC server, if enabled.<br>Default: `6133`                                                                                                      |
| `TEAM_MEMBERS_ARE_OWNERS` | Treat Discord Developers application team members as owners.<br>Options: `true` or `false` <br>Default: `false`                                                        |
| `EXTRA_ARGS`              | Any* extra arguments accepted by the `redbot` command. See full list [here](https://github.com/rHomelab/Red-DiscordBot-Docker/blob/main/.github/redbot-arguments.txt). |
| `PIP_REQUIREMENTS`        | Space-separated list of pip packages to install.                                                                                                                       |

\* `EXTRA_ARGS` note: Do not add arguments which conflict with existing environment variables, such as `--prefix`, `--rpc`, etc.

## Setup

See the [`docker-compose-example.yml`](docker-compose-example.yml) for a basic example of a working bot with Docker Compose.

After running the steps below, your Red Discord Bot will be alive!

### Running the bot with Docker Compose

Create a `docker-compose.yml` file based on the [example](docker-compose-example.yml) and configure the environment variables to suit your desired configuration.

Be sure to update the `/opt/RedBot` path if you wish your bot's persistent data to be stored elsewhere.

Now run `docker compose up -d` and see your bot come alive!

To retrieve the invitation URL, run `docker compose logs RedBot`. If you only started the container a few moments ago, you may need to wait a few seconds for the bot to be created, started, and connected.

### Running the bot with `docker run`

Basic setup:

```bash
docker run -d \
  --name 'RedBot' \
  -v /opt/RedBot:/redbot/data \
  -e "INSTANCE_NAME=RedBot" \
  -e "PREFIX=^" \
  -e "TOKEN=yourBotToken" \
  ghcr.io/rhomelab/red-discordbot:latest
```

To retrieve the invitation URL, run `docker logs RedBot`. If you only started the container a few moments ago, you may need to wait a few seconds for the bot to be created, started, and connected.

## Migrating from `rhomelab:labbot`

The old `rhomelab:labbot` image used different mount paths for Red.

Before using this image, you must make a few changes.

1. Modify `./Red-DiscordBot/config.json`:  
  The `DATA_PATH` value must be changed from `/home/redbot/.local/share/Red-DiscordBot/data/your-instance-name` to `/redbot/data`.
2. Move the files and directories shown below.

| **Old path**                                           | **New path**    |
|--------------------------------------------------------|-----------------|
| `./Red-DiscordBot/config.json`                         | `./config.json` |
| `./share/Red-DiscordBot/data/your-instance-name>/cogs` | `./cogs`        |
| `./share/Red-DiscordBot/data/your-instance-name>/core` | `./core`        |

Example of layout in `rhomelab:labbot`:

```plaintext
Red-DiscordBot/
├─ config.json
share/
├─ Red-DiscordBot/
│  ├─ data/
│  │  ├─ your-instance-name/
│  │  │  ├─ cogs/
│  │  │  ├─ core/

```

Example of new layout:

```plaintext
config.json
cogs/
core/
```
