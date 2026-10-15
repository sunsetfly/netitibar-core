#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v python3.12 >/dev/null 2>&1; then
  echo "ERROR: python3.12 not found." >&2
  echo "Netİtibar foundation parity target is Python 3.12." >&2
  echo "Install Python 3.12, then rerun this script." >&2
  exit 3
fi

if [[ ! -d "$ROOT/.venv" ]]; then
  echo "Creating Python 3.12 virtual environment..."
  python3.12 -m venv .venv
fi

source "$ROOT/.venv/bin/activate"

PY_VER="$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}")')"
echo "Using Python $PY_VER"

python -m pip install --upgrade pip
pip install -r requirements.txt

# The smoke script injects safe local-only settings and uses a temporary SQLite DB.
bash "$ROOT/scripts/netitibar_foundation_check.sh" smoke

echo
echo "BOOTSTRAP + SMOKE PASS"
echo "Next: configure PostgreSQL parity and run:"
echo "  bash scripts/netitibar_foundation_check.sh full"
