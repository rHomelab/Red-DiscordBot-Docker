FROM python:3.11-slim-trixie

ARG DEBIAN_FRONTEND=noninteractive \
   RED_UID=1024 \
   RED_GID=1024

ENV PYTHONUNBUFFERED=1 \
   PIP_DISABLE_PIP_VERSION_CHECK=1 \
   RED_HOME=/redbot \
   RED_USER=reduser

ENV PATH="${RED_HOME}/.local/bin:${PATH}"

RUN groupadd -r -g $RED_GID ${RED_USER} && \
   useradd -rm -g $RED_GID -u ${RED_UID} -d ${RED_HOME} ${RED_USER} && \
   mkdir -pv ${RED_HOME}/data ${RED_HOME}/.config && \
   ln -sv ${RED_HOME}/data ${RED_HOME}/.config/Red-DiscordBot && \
   chown -Rv ${RED_USER}:${RED_USER} $RED_HOME

# Keep extra apt caches to speed up subsequent builds
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
   --mount=type=cache,target=/var/lib/apt,sharing=locked \
   --mount=type=cache,target=${RED_HOME}/.cache/pip,sharing=locked \
   --mount=type=bind,source=redbot/requirements.txt,target=${RED_HOME}/requirements.txt \
   apt update && \
   apt --no-install-recommends -y install build-essential git openjdk-21-jre-headless units tini && \
   su $RED_USER -c "python -m pip install --user -r ${RED_HOME}/requirements.txt" && \
   apt remove -y build-essential && \
   apt autoremove -y

COPY --chmod=755 redbot/*.sh ${RED_HOME}/

VOLUME ["${RED_HOME}/data"]

ENTRYPOINT ["/usr/bin/tini", "--", "/redbot/entrypoint.sh"]
