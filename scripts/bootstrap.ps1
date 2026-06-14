$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$PoetryVersion = "2.4.1"
$PoetryEnvironment = Join-Path $ProjectRoot ".poetry"
$PoetryPython = Join-Path $PoetryEnvironment "Scripts\python.exe"

function Find-Python312 {
    $candidates = @(
        @{ Command = "py"; Arguments = @("-3.12") },
        @{ Command = "python3.12"; Arguments = @() },
        @{ Command = "python"; Arguments = @() }
    )

    foreach ($candidate in $candidates) {
        if (-not (Get-Command $candidate.Command -ErrorAction SilentlyContinue)) {
            continue
        }

        $version = & $candidate.Command $candidate.Arguments -c `
            "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"
        if ($LASTEXITCODE -eq 0 -and $version -eq "3.12") {
            return $candidate
        }
    }

    throw "Python 3.12 is required. Install it from https://www.python.org/downloads/ and run this script again."
}

function Assert-LastCommandSucceeded([string]$Description) {
    if ($LASTEXITCODE -ne 0) {
        throw "$Description failed with exit code $LASTEXITCODE."
    }
}

$python = Find-Python312

if (-not (Test-Path $PoetryPython)) {
    Write-Host "Creating the local Poetry environment..."
    & $python.Command $python.Arguments -m venv $PoetryEnvironment
    Assert-LastCommandSucceeded "Creating the Poetry environment"
}

Write-Host "Installing Poetry $PoetryVersion..."
& $PoetryPython -m pip install --disable-pip-version-check --quiet --upgrade pip
Assert-LastCommandSucceeded "Upgrading pip"
& $PoetryPython -m pip install --disable-pip-version-check --quiet "poetry==$PoetryVersion"
Assert-LastCommandSucceeded "Installing Poetry"

$env:POETRY_VIRTUALENVS_IN_PROJECT = "true"
Push-Location $ProjectRoot
try {
    Write-Host "Installing dependencies from poetry.lock..."
    & $PoetryPython -m poetry sync --no-root
    Assert-LastCommandSucceeded "Installing project dependencies"
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "Setup complete. Run Python with:"
Write-Host "  .\.venv\Scripts\python.exe devices.py"
