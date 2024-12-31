# Dotfiles Managed by Chezmoi

This repository contains my dotfiles, managed by
[Chezmoi](https://www.chezmoi.io/). It provides a streamlined way to set up and
maintain a consistent development environment across multiple systems.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Post-installation Steps](#post-installation-steps)
5. [Chezmoi Usage Guide](#chezmoi-usage-guide)
   - [Adding Files](#adding-files)
   - [Editing Managed Files](#editing-managed-files)
   - [Deleting or Renaming Files](#deleting-or-renaming-files)
   - [Pushing Changes](#pushing-changes)
   - [Updating from Upstream](#updating-from-upstream)
6. [Advanced Use Cases](#advanced-use-cases)
   - [Creating a New Dotfiles Repository](#creating-a-new-dotfiles-repository)
7. [Contribution Guidelines](#contribution-guidelines)
8. [Additional Notes](#additional-notes)
   - [File Ordering](#file-ordering)
   - [Seed Configuration](#seed-configuration)
   - [Run-on-Change Scripts](#run-on-change-scripts)
9. [FAQ](#faq)
10. [License](#license)

---

## Overview

This repository contains dotfiles managed by `chezmoi`, enabling easy setup and
consistent configuration across different systems.

---

## Prerequisites

Before installing, ensure the following:

1. **Xcode or Command Line Developer Tools**: Install via:

   ```sh
   sudo softwareupdate -i -a
   xcode-select --install
   ```

2. **Homebrew** (optional): Homebrew will be installed automatically if not
   already present.

3. **Chezmoi**: Installed as part of the setup process.

---

## Installation

To set up your dotfiles, run the following command in your terminal, replacing
`GITHUB_USERNAME` with your GitHub username. This assumes your repository is
named `dotfiles` and uses HTTPS by default.

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

---

## Post-installation Steps

1. **Add SSH Key to GitHub** (if generated):

   ```sh
   pbcopy < ~/.ssh/id_ed25519.pub
   # Paste into your GitHub account SSH settings
   ```

2. **Verify GitHub SSH Access**:

   ```sh
   ssh -T git@github.com
   ```

3. **View Managed Files**:
   ```sh
   chezmoi managed
   ```

---

## Chezmoi Usage Guide

### Adding Files

#### Without Templating:

```sh
chezmoi add ~/.config/zsh/.zprofile
```

#### With Templating:

```sh
chezmoi add --template ~/.config/zsh/.zshrc
```

### Editing Managed Files

#### Non-templated Files:

```sh
chezmoi edit ~/.config/zsh/.zprofile
```

Or edit directly:

```sh
$EDITOR ~/.config/zsh/.zprofile
chezmoi add ~/.config/zsh/.zprofile
```

#### Templated Files:

```sh
chezmoi cd
$EDITOR dot_config/zsh/dot_zshrc.tmpl
chezmoi apply
```

### Deleting or Renaming Files

#### Delete:

```sh
chezmoi forget ~/.config/zsh/.zprofile
```

#### Rename:

```sh
chezmoi forget ~/.config/zsh/zprofile
mv ~/.config/zsh/zprofile ~/.config/zsh/.zprofile
chezmoi add ~/.config/zsh/.zprofile
```

### Pushing Changes

```sh
chezmoi cd
git add -A .
git commit -m "Your message"
git push
```

### Updating Configuration

```sh
chezmoi init --prompt --apply
```

### Updating from Upstream

```sh
chezmoi update
```

For new configurations:

```sh
chezmoi update --init
```

---

## Advanced Use Cases

### Creating a New Dotfiles Repository

For a fresh `chezmoi` setup:

```sh
chezmoi init
chezmoi cd
git remote add origin git@github.com:$GITHUB_USERNAME/dotfiles.git
git add -A .
git commit -m "Initial commit"
git push -u origin main
```

---

## Contribution Guidelines

Contributions are welcome! Please follow these guidelines:

- **Error Visibility**: Ensure errors are easy to spot and debug.
- **Troubleshooting**: Maintain simplicity in troubleshooting.
- **Commit Messages**: Write clear, descriptive messages.
- **Testing**: Test changes thoroughly.
- **Pull Requests**: Include relevant information for reviewers.

---

## Additional Notes

### File Ordering

Scripts are executed in order based on their names. For example:

- `run_once_002_foo` runs **after** `run_onchange_001_bar`.

### Seed Configuration

Some configurations are "seeded" into place for personalization. Changes made to
live configurations won’t affect the seed unless explicitly updated.

### Run-on-Change Scripts

These scripts are triggered when associated files are modified, ensuring updates
(e.g., package installations) are automatically applied.

---

## FAQ

**Q: Can I use this with SSH-based repositories?** A: Yes. Update the clone URL
to use SSH instead of HTTPS.

**Q: What happens if I encounter errors during installation?** A: Ensure
prerequisites are installed and revisit the error message for troubleshooting.

---

## License

This project is licensed under the MIT License. See `LICENSE` for details.

---
