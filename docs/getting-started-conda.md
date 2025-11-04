# Getting Started with Conda

This guide explains how Conda is configured and used in this setup. It assumes
you already have Python experience, but are new to Conda.

---

## 1. Installation and Initialization

Conda is installed via **Homebrew**, not through asdf:

```sh
brew install --cask miniconda
```

After installation, it is **initialized for your current shell** (`zsh`)
automatically. This is handled in your `.zshrc` file with:

```sh
eval "$(/opt/homebrew/Caskroom/miniconda/base/bin/conda shell.zsh hook)"
```

The base Conda environment is **not activated by default** to avoid cluttering
your shell. You can activate it manually when needed:

```sh
conda activate
```

---

## 2. Channels and Priorities

**Channels** are sources (repositories) from which Conda installs packages —
similar to PyPI for `pip`. This setup uses the following configuration:

1. **conda-forge** – primary channel (preferred source for most packages)
2. **defaults** – fallback channel maintained by Anaconda, Inc.

The configuration also enables **strict channel priority**, which means:

> Conda will only install packages from lower-priority channels (like
> `defaults`) if the package is _not available at all_ in higher-priority
> channels (like `conda-forge`).

This prevents mismatched dependencies between channels.

You can verify this configuration with:

```sh
conda config --show channels
conda config --show channel_priority
```

---

## 3. Environments

A **Conda environment** is an isolated Python environment with its own packages,
dependencies, and Python version — similar to a `venv`, but more powerful and
language-agnostic.

You define environments using an `environment.yml` file, for example:

```yaml
name: myenv
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.12
  - numpy
  - pandas
  - pip
  - pip:
      - black
```

This allows you to recreate environments consistently across systems.

---

## 4. Installing Packages

To install packages, prefer Conda packages whenever possible:

```sh
conda install numpy
```

If a package isn’t available via Conda, fall back to `pip` within the same
environment:

```sh
pip install some-package
```

### Why prefer Conda over pip?

- Conda packages include **precompiled binaries**, avoiding compiler setup and
  dependency issues.
- Conda manages **non-Python dependencies** (e.g., `libxml2`, `openssl`) that
  pip cannot.
- Pip should only be used for packages unavailable on Conda channels.

---

## 5. Using Direnv for Automatic Environment Activation

[direnv](https://direnv.net/) automatically loads environment variables when you
`cd` into a directory. To integrate with Conda, use the following directive in
your project’s `.envrc` file:

```sh
layout anaconda myenv
```

This automatically activates the Conda environment named `myenv` when entering
the directory, and deactivates it when leaving.

Remember to allow the `.envrc` once:

```sh
direnv allow
```

---

## 6. Jupyter Notebook

### Install

Install Jupyter Notebook inside your environment:

```sh
conda install jupyter
```

### Launch

Start Jupyter Notebook:

```sh
jupyter notebook
```

This opens the notebook interface in your default browser.

### Common Keyboard Shortcuts

| Action                 | Shortcut        |
| ---------------------- | --------------- |
| Run cell               | `Shift + Enter` |
| Insert cell below      | `B`             |
| Insert cell above      | `A`             |
| Delete cell            | `D` `D`         |
| Change to command mode | `Esc`           |
| Change to edit mode    | `Enter`         |
| Interrupt kernel       | `I` `I`         |
| Restart kernel         | `0` `0`         |

---

## 7. Common Conda Usage

| Task                                                | Command                                             |
| --------------------------------------------------- | --------------------------------------------------- |
| **Create environment** with specific Python version | `conda create -n myenv python=3.11`                 |
| **Activate environment**                            | `conda activate myenv`                              |
| **Deactivate environment**                          | `conda deactivate`                                  |
| **Remove environment**                              | `conda remove -n myenv --all`                       |
| **Install a package**                               | `conda install numpy`                               |
| **Export environment**                              | `conda env export --from-history > environment.yml` |
| **List environments**                               | `conda env list`                                    |
| **List packages in environment**                    | `conda list`                                        |

Tip: The `--from-history` flag ensures only explicitly installed packages are
listed, not their dependencies.

---

## 8. Best Practices

- Prefer **conda-forge** packages; only use pip when strictly necessary.
- Always pin key package versions in `environment.yml` for reproducibility.
- Use **one environment per project** — don’t overload a single global one.
- Keep `base` environment clean; use it only for managing Conda itself.
- Use `conda clean --all` periodically to remove cached packages.
- Combine Conda with **direnv** to streamline environment activation.
- When collaborating, always share and update your `environment.yml`.
