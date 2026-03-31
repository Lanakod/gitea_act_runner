FROM node:16-bullseye

SHELL ["/bin/bash", "-c"]

ARG ACT_RUNNER_VERSION=0.3.1

RUN wget https://dl.gitea.com/act_runner/${ACT_RUNNER_VERSION}/act_runner-${ACT_RUNNER_VERSION}-linux-amd64 \
    -O /usr/local/bin/act_runner && \
    chmod +x /usr/local/bin/act_runner

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]