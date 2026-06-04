"""Photonic integrated device simulation imports and utilities.

This module centralizes the common numerical, layout, circuit, mode-solver,
and electromagnetic-solver packages used in PIC simulation workflows.
"""

from __future__ import annotations

import importlib
import os
from pathlib import Path
from typing import Any

_WORKSPACE = Path(__file__).resolve().parent
os.environ.setdefault("MPLCONFIGDIR", str(_WORKSPACE / ".matplotlib"))
os.makedirs(os.environ["MPLCONFIGDIR"], exist_ok=True)

import h5py
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy.constants as const
import scipy.interpolate as interpolate
import scipy.linalg as linalg
import scipy.optimize as optimize
import scipy.signal as signal
import scipy.sparse as sparse
import xarray as xr
from scipy import integrate
from shapely import affinity, geometry, ops

import gdspy
import gdstk
import gdsfactory as gf
import jax
import jax.numpy as jnp
import klayout.db as kdb
import modesolverpy
import pya
import sax
import simphony
import skrf as rf
import tidy3d as td


MISSING_OPTIONAL_PACKAGES: dict[str, str] = {}


def _optional_import(module_name: str, install_hint: str) -> Any | None:
    """Import optional solver backends without breaking the rest of the stack."""
    try:
        return importlib.import_module(module_name)
    except ImportError:
        MISSING_OPTIONAL_PACKAGES[module_name] = install_hint
        return None


mp = _optional_import(
    "meep",
    "Install the real Meep/PyMeep package from conda-forge, for example: "
    "conda install -c conda-forge pymeep",
)

__all__ = [
    "MISSING_OPTIONAL_PACKAGES",
    "affinity",
    "const",
    "gdspy",
    "gdstk",
    "geometry",
    "gf",
    "h5py",
    "integrate",
    "interpolate",
    "jax",
    "jnp",
    "kdb",
    "linalg",
    "modesolverpy",
    "mp",
    "np",
    "ops",
    "optimize",
    "pd",
    "plt",
    "pya",
    "rf",
    "sax",
    "signal",
    "simphony",
    "sparse",
    "td",
    "xr",
]
