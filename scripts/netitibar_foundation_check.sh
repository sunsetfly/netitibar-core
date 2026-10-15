#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-smoke}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ "$MODE" != "smoke" && "$MODE" != "full" ]]; then
  echo "Usage: $0 [smoke|full]" >&2
  exit 2
fi

if [[ -x "$ROOT/.venv/bin/python" ]]; then
  PY="$ROOT/.venv/bin/python"
elif command -v python3.12 >/dev/null 2>&1; then
  PY="$(command -v python3.12)"
else
  echo "ERROR: .venv/bin/python or python3.12 not found." >&2
  echo "Create the parity venv first: python3.12 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt" >&2
  exit 3
fi

PY_VER="$($PY -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
if [[ "$PY_VER" != "3.12" ]]; then
  echo "WARNING: parity target is Python 3.12; current interpreter is $PY_VER." >&2
fi

RUFF="$ROOT/.venv/bin/ruff"
MYPY="$ROOT/.venv/bin/mypy"
PYTEST="$ROOT/.venv/bin/pytest"

for bin in "$RUFF" "$MYPY"; do
  if [[ ! -x "$bin" ]]; then
    echo "ERROR: missing $bin. Run: source .venv/bin/activate && pip install -r requirements.txt" >&2
    exit 4
  fi
done

export SECRET_KEY="netitibar-foundation-local-only"
export ENCRYPTION_KEY_SALT="netitibar-foundation-local-only"
export DEBUG="true"
export ALLOWED_HOSTS="localhost,127.0.0.1"
export APP_URL="http://localhost:8000"
export EMAIL_BACKEND_TYPE="console"
export STORAGE_BACKEND="local"

SMOKE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/netitibar-smoke.XXXXXX")"
trap 'rm -rf "$SMOKE_DIR"' EXIT
export DATABASE_URL="sqlite:///$SMOKE_DIR/db.sqlite3"
export DJANGO_SETTINGS_MODULE="config.settings.development"

echo "== Netİtibar foundation smoke =="
echo "repo: $ROOT"
echo "python: $($PY --version 2>&1)"
echo "database: temporary SQLite"

echo "[1/7] dependency consistency"
"$PY" -m pip check

echo "[2/7] migrations"
"$PY" manage.py migrate --noinput >/dev/null

echo "[3/7] Django system check"
"$PY" manage.py check

echo "[4/7] migration drift"
"$PY" manage.py makemigrations --check --dry-run

echo "[5/7] ruff lint"
"$RUFF" check .

echo "[6/7] ruff format"
"$RUFF" format --check .

echo "[7/7] mypy"
"$MYPY" apps/ config/ providers/ tests/ --ignore-missing-imports

echo "SMOKE PASS"

if [[ "$MODE" == "full" ]]; then
  if [[ ! -x "$PYTEST" ]]; then
    echo "ERROR: missing $PYTEST. Run: source .venv/bin/activate && pip install -r requirements.txt" >&2
    exit 5
  fi

  export DJANGO_SETTINGS_MODULE="config.settings.test"
  export DB_HOST="${DB_HOST:-localhost}"
  export DB_USER="${DB_USER:-postgres}"
  export DB_PASSWORD="${DB_PASSWORD:-postgres}"
  export DB_PORT="${DB_PORT:-5432}"

  echo "== PostgreSQL full parity =="
  echo "host: $DB_HOST:$DB_PORT"
  echo "database: brightbean_test (defined by upstream test settings)"
  echo "Running full pytest suite..."
  "$PYTEST" --cov=apps --cov-report=term-missing
  echo "FULL PASS"
fi
