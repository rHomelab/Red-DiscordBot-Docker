# LabBot
r/Homelab's Red-DiscordBot instance.

- [Red Docker Setup](#red-docker-setup)
	- [Prerequisites](#prerequisites)
    - [Building the Bot Image Manually](#building-the-bot-image-manually)
    - [Configuring the Bot](#configuring-the-bot)
    - [Running the Bot with `docker-compose`](#running-the-bot-with--docker-compose-)
    - [Running the Bot with `docker run`](#running-the-bot-with--docker-run-)
## Red Docker Setup

This repository contains the Dockerfile which can be used to build a Docker image of RedBot.

Alternatively, you can use the prebuilt `rhomelab/labbot` image (also specified in `docker-compose.yml`).

### Prerequisites

Create the data directories and assign permissions:
```bash
$ mkdir -p /opt/LabBot/Red-DiscordBot
$ mkdir /opt/LabBot/share
$ chown -R :1024 /opt/LabBot
$ chmod -R 775 /opt/LabBot
$ chmod -R g+s /opt/LabBot
```

### Building the Bot Image Manually

If you wish to make changes to the prebuilt image for testing or development purposes, you must build it manually.

To do this you must clone this repository, `cd` into it, and run the following:
```bash
docker build -t rhomelab/labbot:dev .
```

You can now reference the `rhomelab/labbot:dev` image instead of `rhomelab/labbot:latest` for all following instructions.

### Configuring the Bot

This method will run the bot from a pre-built image. Alternatively, skip to the next step to build it yourself.

1. Start the image in order to set up the bot for the first time:
	```bash
	docker run -it -v /opt/LabBot/share:/home/redbot/.local/share -v /opt/LabBot/Red-DiscordBot:/usr/local/share/Red-DiscordBot rhomelab/labbot:latest /bin/bash
	```
2. Run `redbot-setup` and follow the setup process to configure Red.
3. Run `redbot LabBot` to set the name, then add your token and prefix.
4. Once the bot has initialised, press Ctrl + C to exit the bot, then Ctrl + D to exit the container.

### Running the Bot with `docker-compose`

Note that `docker-compose.yml` has the `rhomelab/labbot:latest` image hardcoded, so you must change this if you wish to use a locally built or other image.
```bash
$ docker-compose pull
$ docker-compose up -d
```

### Running the Bot with `docker run`

```bash
docker run -it --detach --name 'LabBot' -v /opt/LabBot/share:/home/redbot/.local/share -v /opt/LabBot/Red-DiscordBot:/usr/local/share/Red-DiscordBot rhomelab/labbot:latest /bin/bash -c "redbot LabBot --team-members-are-owners"
```
