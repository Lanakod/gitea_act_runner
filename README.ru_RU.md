[English](/README.md) | [Русский](/README.ru_RU.md)

![GitHub Release](https://img.shields.io/github/v/release/lanakod/gitea_act_runner)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/lanakod/gitea_act_runner/build.yml)
![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/lanakod/gitea_act_runner/total)

# 🏃‍♂️ Custom Gitea Act Runner (Auto‑Updating Docker Image)

Этот репозиторий содержит кастомный Docker‑образ для **Gitea Act Runner**, который:

- автоматически генерирует `config.yaml`, если он отсутствует
- автоматически регистрирует раннер в Gitea
- автоматически обновляется при выходе новых релизов `gitea/act_runner`
- публикует образы в **GitHub Container Registry (GHCR)**
- запускает раннер в режиме `daemon`

Образ предназначен для удобного развёртывания self‑hosted раннеров Gitea Actions.

---

## 📦 Docker Image

GHCR:

```
ghcr.io/lanakod/gitea_act_runner:latest
ghcr.io/lanakod/gitea_act_runner:<version>
```

---

## 🚀 Быстрый старт

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

## ⚙️ Переменные окружения

| Переменная                        | Описание                  | Обязательно |
|-----------------------------------|---------------------------|-------------|
| `GITEA_INSTANCE_URL`              | URL вашего Gitea сервера  | ✔           |
| `GITEA_RUNNER_REGISTRATION_TOKEN` | Токен регистрации раннера | ✔           |
| `GITEA_RUNNER_LABELS`             | Лейблы раннера            | ✔           |
| `GITEA_RUNNER_NAME`               | Имя раннера               | ✔           |

---

## 📁 Директория `/data`

Контейнер использует `/data` для хранения:

- `config.yaml` — конфигурация раннера
- `.runner` — файл регистрации
- кеша и временных файлов

Рекомендуется монтировать volume:

```bash
-v /srv/gitea-runner:/data
```

---

## 🛠 Автоматическая генерация config.yaml

Если `config.yaml` отсутствует, контейнер создаёт его автоматически:

```bash
act_runner generate-config > /data/config.yaml
```

---

## 🔧 Автоматическая регистрация раннера

Если файл `/data/.runner` отсутствует, выполняется:

```bash
act_runner register \
  --no-interactive \
  --instance $GITEA_INSTANCE_URL \
  --token $GITEA_RUNNER_REGISTRATION_TOKEN \
  --labels $GITEA_RUNNER_LABELS \
  --name $GITEA_RUNNER_NAME
```

После регистрации создаётся `.runner`, и повторная регистрация не выполняется.

---

## ▶️ Запуск раннера

```bash
act_runner daemon --config /data/config.yaml
```

---

## 🧪 Пример docker-compose.yml

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

# 🤖 Автоматическое обновление и публикация в GHCR

Этот репозиторий содержит workflow, который:

- раз в сутки проверяет новые релизы `gitea/act_runner`
- обновляет версию в Dockerfile
- собирает Docker‑образ
- публикует его в GHCR