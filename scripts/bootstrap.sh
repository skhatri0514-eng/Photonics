#!/usr/bin/env sh
set -eu

PROJECT_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
POETRY_VERSION=2.4.1
POETRY_ENVIRONMENT="$PROJECT_ROOT/.poetry"
POETRY_PYTHON="$POETRY_ENVIRONMENT/bin/python"

find_python312() {
    for candidate in python3.12 python3 python; do
        if command -v "$candidate" >/dev/null 2>&1 &&
            [ "$("$candidate" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')" = "3.12" ]; then
            printf '%s\n' "$candidate"
            return
        fi
    done

    printf '%s\n' \
        "Python 3.12 is required. Install it from https://www.python.org/downloads/ and run this script again." >&2
    exit 1
}

PYTHON=$(find_python312)

if [ ! -x "$POETRY_PYTHON" ]; then
    printf '%s\n' "Creating the local Poetry environment..."
    "$PYTHON" -m venv "$POETRY_ENVIRONMENT"
fi

printf '%s\n' "Installing Poetry $POETRY_VERSION..."
"$POETRY_PYTHON" -m pip install --disable-pip-version-check --quiet --upgrade pip
"$POETRY_PYTHON" -m pip install --disable-pip-version-check --quiet "poetry==$POETRY_VERSION"

printf '%s\n' "Installing dependencies from poetry.lock..."
(
    cd "$PROJECT_ROOT"
    POETRY_VIRTUALENVS_IN_PROJECT=true "$POETRY_PYTHON" -m poetry sync --no-root
)

printf '\n%s\n' "Setup complete. Run Python with:"
printf '%s\n' "  ./.venv/bin/python devices.py"
