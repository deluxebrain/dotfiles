# Interaction Between Homebrew and asdf Installations

When a package is installed using both **Homebrew** and **asdf**, the way the
system resolves which version is executed depends on **PATH ordering** and
**asdf’s shim mechanism**.

---

## 1. Default Precedence: Homebrew First

When only Homebrew is installed, binaries from `/usr/local/bin` or
`/opt/homebrew/bin` (on Apple Silicon) typically appear early in your `$PATH`.
This means any command installed by Homebrew (e.g., `python3`, `node`, `ruby`)
will run **the Homebrew version** by default.

---

## 2. Installing an asdf Plugin

When you install an `asdf` plugin for a package (e.g.,
`asdf plugin add nodejs`), asdf creates a **shim** for that command in
`~/.asdf/shims`. If your shell initialization loads asdf (usually via `.zshrc`
or `.bashrc`), this shim directory is placed **before Homebrew** in the `$PATH`.

At that point, running the command (e.g., `node`) will invoke the **asdf shim**,
not the Homebrew binary.

---

## 3. Version Resolution

Each shim delegates execution to the version defined by asdf. If no version is
configured (globally, locally, or for your home directory), the shim cannot
resolve which binary to use, and the command will fail with an error.

Therefore, you must define a version, or explicitly fall back to the system
version:

```sh
asdf set --home nodejs system
```

---

## 4. Edge Case: Commands Used Before asdf Initialization

If commands are executed **before asdf is initialized**, for example by
**oh-my-zsh (OMZ)** plugins during shell startup, the shims will exist but won’t
yet be functional because the `asdf` environment isn’t loaded. This can cause
“command not found” or version resolution errors at startup.

Set the system (Homebrew) version for affected packages using:

```sh
asdf set --home <package> system
```

This ensures that even if asdf isn’t initialized yet, the command still resolves
to the system-installed (Homebrew) binary.

---

## 5. Special Case: Python System Version

Homebrew installs **Python 3** as the `python3` and `pip3` commands, but it does
**not** create a `python` or `pip` binary. As a result, if you run:

```sh
asdf set --home python system
```

the `python` shim will point to a binary that does not exist, and commands like
`python --version` will fail.

Alias `python` to `python3` (and optionally `pip` to `pip3`) in your shell
configuration:

```sh
alias python="python3"
alias pip="pip3"
```

This ensures that `asdf` shims or OMZ plugins expecting a `python` command will
still resolve correctly when falling back to the system (Homebrew) version.

---

## 7. Key Takeaways

- Homebrew binaries are used **until asdf is initialized**.
- Once initialized, **asdf shims override Homebrew** for any managed packages.
- Always define an asdf version to prevent command failures.
- Use `asdf set --home <package> system` for packages that may run **before asdf
  is loaded** (e.g., in OMZ startup).
- For **Python**, alias `python` to `python3` if using the system (Homebrew)
  version.
