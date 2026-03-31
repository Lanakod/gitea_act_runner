[English](/README.md) | [Русский](/README.ru_RU.md)

# 🏃‍♂️ Custom Gitea Act Runner (Auto‑Updating Docker Image)

This repository contains a custom Docker image for **Gitea Act Runner** that:

- automatically generates `config.yaml` if it does not exist
- automatically registers the runner with your Gitea instance
- automatically updates when new `gitea/act_runner` releases are published
- publishes built images to **GitHub Container Registry (GHCR)**
- runs the runner in `daemon` mode

This image is designed for easy deployment of self‑hosted Gitea Actions runners.

---

## 📦 Docker Image

Available on GHCR:

```
ghcr.io/lanakod/gitea_act_runner:latest
ghcr.io/lanakod/gitea_act_runner:<version>
```

---

## 🚀 Quick Start

```bash
docker run -d \
  --name gitea-runner \
  -v /path/to/data:/data \
  -e GITEA_INSTANCE_URL="https://gitea.example.com" \
  -e GITEA_RUNNER_REGISTRATION_TOKEN="YOUR_TOKEN" \
  -e GITEA_RUNNER_LABELS="docker:host" \
  -e GITEA_RUNNER_NAME="my-runner" \
  ghcr.io/lanakod/gitea_act_runner:latest
```

---

## ⚙️ Environment Variables

| Variable                          | Description                   | Required |
|-----------------------------------|-------------------------------|----------|
| `GITEA_INSTANCE_URL`              | URL of your Gitea instance    | ✔        |
| `GITEA_RUNNER_REGISTRATION_TOKEN` | Runner registration token     | ✔        |
| `GITEA_RUNNER_LABELS`             | Labels assigned to the runner | ✔        |
| `GITEA_RUNNER_NAME`               | Name of the runner            | ✔        |

---

## 📁 `/data` Directory

The container uses `/data` to store:

- `config.yaml` — runner configuration
- `.runner` — registration metadata
- cache and temporary files

It is recommended to mount it as a volume:

```bash
-v /srv/gitea-runner:/data
```

---

## 🛠 Automatic `config.yaml` Generation

If `config.yaml` is missing, the container automatically generates it:

```bash
act_runner generate-config > /data/config.yaml
```

---

## 🔧 Automatic Runner Registration

If `/data/.runner` does not exist, the container performs:

```bash
act_runner register \
  --no-interactive \
  --instance $GITEA_INSTANCE_URL \
  --token $GITEA_RUNNER_REGISTRATION_TOKEN \
  --labels $GITEA_RUNNER_LABELS \
  --name $GITEA_RUNNER_NAME
```

After successful registration, `.runner` is created and registration will not repeat.

---

## ▶️ Starting the Runner

```bash
act_runner daemon --config /data/config.yaml
```

---

## 🧪 Example `docker-compose.yml`

```yaml
services:
  gitea-runner:
    image: ghcr.io/lanakod/gitea_act_runner:latest
    container_name: gitea-runner
    restart: always
    volumes:
      - ./data:/data
    environment:
      GITEA_INSTANCE_URL: "https://gitea.example.com"
      GITEA_RUNNER_REGISTRATION_TOKEN: "YOUR_TOKEN"
      GITEA_RUNNER_LABELS: "docker:host"
      GITEA_RUNNER_NAME: "my-runner"
```

---

# 🤖 Automatic Updates & GHCR Publishing

This repository includes a workflow that:

- checks for new `gitea/act_runner` releases daily
- updates the version in the Dockerfile
- builds the Docker image
- publishes it to GHCR