# Cave Story NX in Docker

A browser-ready Docker image for Cave Story NX that lets you play from any modern web browser while keeping your saves between sessions.

## Run

```bash
docker compose up -d
```

Open <http://localhost:3000>.

## Checks

```bash
python3 -m pip install pre-commit
pre-commit install
make check
```
