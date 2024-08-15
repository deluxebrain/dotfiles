#!/bin/zsh

# CONDA
# CONDA_ENVS_PATH: location of conda environment
# CONDA_PREFIX, CONDA_DEFAULT_ENV: path to current environment
# conda info: show info about current environment
# conda info --envs: show info about all environments

# Jupyter
# jupyter notebook
# opens: http://localhost:8888/tree

# Jupyter in vscode
# Command Palette: Python: select intepreter
# Command Palette: Create: new Jupyter notebook

# Jupyter notes
# Run single code cell: ctrl+enter
# and insert new cell underneath: shift+enter

TMPL_ENVRC_PYTHON=$(
cat <<"EOF"
# load any parent .envrc files
source_up

# load any .env file next such that this .envrc overrides
dotenv

# python virtual environment
direnv_layout_dir="$(expand_path venv)"
layout python3
EOF
)

TMPL_ENVRC_CONDA=$(
cat <<"EOF"
# load any parent .envrc files
source_up

# load any .env file next such that this .envrc overrides
dotenv

# conda environment
export CONDA_ENVS_PATH=$(expand_path .)
layout anaconda baz
EOF
)

function python.init() (
    asdf install python latest
    asdf local python latest
    echo "$TMPL_ENVRC_PYTHON" > .envrc
    direnv.whitelist
)

function conda.init() (
    asdf install python miniconda3-latest
    asdf local python miniconda3-latest
    echo "$TMPL_ENVRC_CONDA" > .envrc
    direnv.whitelist
    conda install -y jupyter
)
