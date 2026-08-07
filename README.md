# Cave Story NX

Cave Story NX running in the browser with Selkies, including audio and keyboard/mouse input.

## Run

```bash
docker compose up --build
```

Open <http://localhost:8081>.

Saves are stored in the `cavestory-data` Docker volume.

## Checks

```bash
python3 -m pip install pre-commit
pre-commit install
make check
```
