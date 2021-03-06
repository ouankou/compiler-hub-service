
# Pull base image.
FROM ubuntu:20.04

# Add user
RUN groupadd -g 9999 chs && \
    useradd -r -u 9999 -g chs -m -d /home/chs chs

# Install packages.
RUN \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        git \
        python3-flask \
        python3-requests \
        npm \
        vim \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/*

RUN npm install serve -g

# Switch user and working directory.
USER chs
COPY --chown=chs:chs [".bashrc", "/home/chs/"]

COPY --chown=chs:chs ["frontend", "/home/chs/frontend"]

WORKDIR /home/chs/frontend
RUN npm ci && \
    npm run build

# Define default command.
CMD ["serve", "-s", "build"]
