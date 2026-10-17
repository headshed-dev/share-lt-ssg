FROM node:24-bookworm

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      tini \
      procps \
    && rm -rf /var/lib/apt/lists/*

# Match host uid/gid so bind-mounted files (including node_modules) stay host-owned
RUN groupmod -o -g "$GROUP_ID" node \
    && usermod -o -u "$USER_ID" -g "$GROUP_ID" -s /bin/bash node

ENV HOME=/home/node \
    NPM_CONFIG_CACHE=/home/node/.npm

RUN corepack enable && corepack prepare pnpm@latest --activate

# chown after corepack, which writes its cache into $HOME as root
RUN chown -R node:node /home/node

WORKDIR /app
USER node

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["sleep", "infinity"]
