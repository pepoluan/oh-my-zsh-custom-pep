#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys

from pathlib import Path
from typing import Protocol, cast

RE_NOT_ZSH: re.Pattern = re.compile(r"/(a|c|k|ba|da|fi|tc)sh$")

RE_PROBABLE_ZSH: list[re.Pattern] = [
    re.compile(r"if\s+\[.*?;\s*then"),
    re.compile(r"setopt\s+extendedglob"),
]

ZSH_SUFFIXES: set[str] = {
    ".zsh",
    ".zsh-theme",
}
SKIP_NAMES: set[str] = {
    "LICENSE",
    "Makefile",
}
SKIP_SUFFIXES: set[str] = {
    ".conf",
    ".gif",
    ".json",
    ".md",
    ".png",
    ".py",
    ".pyc",
    ".pyo",
    ".svg",
    ".txt",
    ".zwc",
}
SKIP_DIRS: list[str] = [
    ".git",
    ".github",
    "__pycache__",
]


class _Options(Protocol):
    exclude_compiled: bool
    dirs: list[str]


def _get_options() -> _Options:
    parser = argparse.ArgumentParser()
    parser.add_argument("--exclude-compiled", "-C", action="store_true", default=False)
    parser.add_argument("dirs", nargs="+")
    _opts = parser.parse_args()
    return cast(_Options, _opts)


def is_zsh(fp: Path) -> bool:
    if fp.suffix in ZSH_SUFFIXES:
        return True
    with fp.open("rt") as fin:
        for lnum, line in enumerate(fin, start=1):
            line = line.strip()
            if lnum == 1:
                if line.startswith("#!"):
                    if line.endswith("/bin/zsh"):
                        return True
                    if RE_NOT_ZSH.search(line):
                        return False
                if line.startswith("#compdef"):
                    return True
            if any(p.search(line) for p in RE_PROBABLE_ZSH):
                return True
    return False


def main(opts: _Options) -> None:
    for p in opts.dirs:
        for f in Path(p).expanduser().rglob("*"):
            if f.is_dir():
                continue
            if f.name in SKIP_NAMES:
                continue
            if f.suffix in SKIP_SUFFIXES:
                continue
            if f.name.startswith("."):
                continue
            if opts.exclude_compiled and f.with_suffix(f.suffix + ".zwc").exists():
                continue
            if any(d in f.parts for d in SKIP_DIRS):
                continue
            try:
                if is_zsh(f):
                    print(f"{f}")
            except Exception as e:
                print(f"{e} => {f}")


if __name__ == "__main__":
    main(_get_options())

# vi: ts=4 sts=4 et
