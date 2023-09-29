# Red Discord Bot Docker

![Docker Hub Pulls](https://img.shields.io/docker/pulls/rhomelab/red-discordbot?logo=docker&label=docker%20hub%20pulls&style=for-the-badge)
![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/rhomelab/red-discordbot/latest?label=red%20version&logo=discord&style=for-the-badge)

[Red Discord Bot](https://discord.red), now containerised.

Note: This is an unsupported deployment method. Do not expect support from the developers of Red Discord Bot if you run into any issues.

* [Tags](#tags)
* [Environment Variables](#environment-variables)
* [Setup](#setup)
  * [Prerequisites](#prerequisites)
  * [Running the bot with `docker-compose`](#running-the-bot-with-docker-compose)
  * [Running the bot with `docker run`](#running-the-bot-with-docker-run)
* [Migrating from `rhomelab:labbot`](#migrating-from-rhomelablabbot)

## Tags

This image is built on both Debian and Alpine.

The Alpine image is approximately 60% smaller than the Debian image; this variant is useful when image size is a primary concern. The main caveat to note is that it does use musl libc instead of glibc and friends, so it's possible that some software may run into issues.  
This image has functioned perfectly in basic testing, however, please raise an issue if you see any problems.

|   **Tags**   |                                  **Red version**                                 |    **Base Image**   |
|:------------:|:--------------------------------------------------------------------------------:|:-------------------:|
| `latest`     | [Latest release](https://github.com/Cog-Creators/Red-DiscordBot/releases/latest) | `python:3.9-debian` |
| `alpine`     | [Latest release](https://github.com/Cog-Creators/Red-DiscordBot/releases/latest) | `python:3.9-alpine` |
| x.x.x        | See tag                                                                          | `python:3.9-debian` |
| x.x.x-alpine | See tag                                                                          | `python:3.9-alpine` |

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

This repository contains two Dockerfiles which can be used to run this Docker image.

* Debian-based: [`docker-compose-example.yml`](docker-compose-example.yml)
* Alpine-based: [`docker-compose-alpine-example.yml`](docker-compose-alpine-example.yml)

For more information, see [Tags](#tags) above.

After running the steps below, your Red Discord Bot will be alive!

To retrieve the invitation URL, run `docker logs RedBot`. If you only started the container a few moments ago, you may need to wait a few seconds for the bot to be created, started, and connected.

### Prerequisites

Create the data directories and assign permissions. You can replace `/opt/RedBot` with any path you wish.

```bash
sudo mkdir -p /opt/RedBot
sudo chown -R :1024 /opt/RedBot
sudo chmod -R 770 /opt/RedBot
```

Note: You, and any other user with access to the host, will now need root access (or `sudo`) to read or write any of the contents of `/opt/RedBot`. If you wish to allow all users to read (but not write) the contents of the directory, run `sudo chmod -R 774 /opt/RedBot`.

### Running the bot with `docker-compose`

Download one of the `docker-compose` files (differences listed [above](#setup)), rename to `docker-compose.yml`, and configure the environment variables to suit your desired configuration.

Be sure to update the `/opt/RedBot` path if you changed that in the prerequisite step above.

Now run `docker-compose up -d` and see your bot come alive!

### Running the bot with `docker run`

Debian-based image:

```bash
docker run -d --name 'RedBot' -v /opt/RedBot:/redbot/data -e "INSTANCE_NAME=RedBot" -e "PREFIX=^" -e "TOKEN=yourBotToken" rhomelab/red-discordbot:latest
```

Alpine-based image:

```bash
docker run -d --name 'RedBot' -v /opt/RedBot:/redbot/data -e "INSTANCE_NAME=RedBot" -e "PREFIX=^" -e "TOKEN=yourBotToken" rhomelab/red-discordbot:alpine
```

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
