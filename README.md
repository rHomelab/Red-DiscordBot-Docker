# Red Discord Bot Docker

[Red Discord Bot](https://discord.red), now containerised.

Note: This is an unsupported deployment method. Do not expect support from the developers of Red Discord Bot if you run into any issues.

- [Setup](#setup)
	- [Prerequisites](#prerequisites)
	- [How to run the Bot](#how-to-run-the-bot)
		- [With `docker-compose`](#with-docker-compose)
		- [With `docker run`](#with-docker-run)

# Setup

This repository contains the Dockerfile which can be used to build a Docker image of RedBot.

Alternatively, you can use the prebuilt `rhomelab/labbot` image (also specified in `docker-compose.yml`).

## Prerequisites

Create the data directories and assign permissions. You can replace `/opt/RedBot` with any path you wish.

```bash
mkdir -p /opt/RedBot
chown -R :1024 /opt/RedBot
chmod -R u=rwxg=rwx,a=rx,g+s /opt/RedBot
```

## How to run the Bot

Once running the steps below, your Red Discord Bot will be alive!

To retrieve the invitation URL, run `docker logs RedBot`. If you only started the container a few moments ago, you may need to wait a few seconds for the bot to be created, started, and connected.

### With `docker-compose`

Download [`docker-compose-example.yml`](docker-compose-example.yml), rename to `docker-compose.yml`, configure the environment variables to suit your desired configuration.

Be sure to update the `/opt/RedBot` path if you changed that in the prerequisite step above.

Now run `docker-compose up -d` and see your bot come alive!

### With `docker run`

```bash
docker run -d --name 'RedBot' -v /opt/RedBot:/redbot/data -e "INSTANCE_NAME=RedBot" -e "PREFIX=^" -e "TOKEN=yourBotToken" rhomelab/Red-DiscordBot:latest
```
