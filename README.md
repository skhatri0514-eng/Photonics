# Photonics

## Set up a fresh clone

Install Python 3.12, clone the repository, and run the bootstrap script from
the repository root.

Windows PowerShell:

```powershell
.\scripts\bootstrap.ps1
.\.venv\Scripts\Activate.ps1
```

macOS or Linux:

```bash
sh scripts/bootstrap.sh
source .venv/bin/activate
```

The script installs a local copy of Poetry and then installs the exact
dependency versions recorded in `poetry.lock`. Both Poetry and the project
environment stay inside the repository in ignored `.poetry` and `.venv`
directories.

Run the bootstrap script again whenever `pyproject.toml` or `poetry.lock`
changes.

## Meep

Meep/PyMeep is optional and is not available from PyPI, so Poetry cannot
install it from `pyproject.toml`. For FDTD work, install it separately from
conda-forge:

```bash
conda install -c conda-forge pymeep
```

Code that does not use Meep can run without it. `devices.py` records a helpful
message in `MISSING_OPTIONAL_PACKAGES` when Meep is unavailable.
