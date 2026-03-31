FROM node:16-bullseye

LABEL org.opencontainers.image.title="gitea_act_runner"
LABEL org.opencontainers.image.description="Custom auto-updating Gitea Act Runner image with auto-config and auto-registration"
LABEL org.opencontainers.image.source="https://github.com/lanakod/gitea_act_runner"
LABEL org.opencontainers.image.url="https://github.com/lanakod/gitea_act_runner"
LABEL org.opencontainers.image.vendor="lanakod"
LABEL org.opencontainers.image.licenses="MIT"

SHELL ["/bin/bash", "-c"]

ARG ACT_RUNNER_VERSION=0.3.1

RUN wget https://dl.gitea.com/act_runner/${ACT_RUNNER_VERSION}/act_runner-${ACT_RUNNER_VERSION}-linux-amd64 \
    -O /usr/local/bin/act_runner && \
    chmod +x /usr/local/bin/act_runner

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]