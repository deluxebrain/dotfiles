# DOTFILES

## Overview

Highly opinionated cross-platform dotfiles managed using [yadm](https://yadm.io) and adhering (as far is possible) to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html#:~:text=should%20be%20located.-,Basics,by%20the%20environment%20variable%20%24XDG_DATA_HOME%20.).

## Motivation

Cross-platform dotfiles management has the following main concerns:

-   Relating to installation:
    -   a centralized remote repository to store the dotfiles;
    -   logic to coordinate the installation of the dotfiles, and perform any additional processing;
    -   an approach to selecting the correct logic to run, based on the target architecture and other pivot points;
-   Relating to management:
    -   reconciliation of local dotfiles with remote repository to ensure all changes remain in sync;
    -   an approach to testing dotfile changes independently from the users primary dotfiles;

`yadm` is one of several tools available to help with the management of dotfiles. It has been selected as part of the solution due to how it maps the above concerns to familiar technologies.

The resulting dotfiles repository is largely independant of `yadm`, making it immediately familiar. This also makes it simple to migrate away from `yadm` at a future date if so required.

Adherence to the `XDG` specification was decided upon to address the above concerns around dotfiles management through the support for a configurable and centralized location for the dofiles.

Through the use of the `XDG` path configuration environment variables, multiple copies of the dotfiles repository can be run at once, with a specific version being configured as live. This makes visual regression testing very simple and straightforward to perform.

## Familiarisation

Before proceeding, its worth getting a rough feel for the structure of the repository.

The XDG Base Directory Specification ( `XDG` herein ) specifies that there should be a single base directory for all user-specific configuration.

Through adoption of the `XDG` spec therefore, user dotfiles are centralized to the corresponding `XDG_CONFIG_HOME` directory ( typically `.config` ), rather than being scattered around `$HOME` and other various OS specific configuration directories.

It is not possible to adopt XDG completely however, and hence there are a few top-level files in `$HOME` ( the root of the git repo ) corresponding to these cases.

Additionally, the project `README` and associated documentation makes use of githubs support for these being centralized to the top-level `.github` directory.

## Preparation

`yadm` is a thin wrapper around git providing management of your dotfiles using a [bare git repository](https://www.atlassian.com/git/tutorials/dotfiles).

`yadm` manages the installation of the files in the dotfiles repository through a git checkout. Files that already exist will be left unmodified and you will have to review and resolve all differences.

> To simplify any reconciliation  - and therefore the installation - it is best to manually backup and delete any preexisting files before installation.

File archival is a manual process. The specifics of how to peform this archival process depends on the relationship between pre-existing files and `yadm` managed files.

### Direct association between existing file and yadm managed file

Through adoption of the XDG path spec, the dotfiles are largely centered around the `XDG_CONFIG_HOME` directory ( root level `.config` directory ). There are also a few top-level files for situations where XDG is not supported.

> This dotfiles path structure is defined within the root `.gitignore` file. This file should be reviewed against corresponding pre-existing files and folders. Anything pre-existing should be backed up and deleted.

### Indirect association between existing file and yadm managed file

In the case where an application supports the `XDG` specification, the corresponding dotfile can usually be located in either the users home directory or an application specific location within the `XDG` path.

> Pre-existing dotfiles located in the users home directory should be cross-referenced to files in the project `.config` directory tree. In the case where they correspond, the file should be backed up and deleted.

Any differences between the two versions of the dotfile can then be reconciled in your fork of this project.

### No association between existing file and yadm managed file

> Pre-existing dotfiles with no corresponding version anywere in the project will need to be added to your fork of this project. They do not need to be archived at this stage.

When adding dotfiles to this project it is important to understand if the corresponding application is `XDG` compliant. This will determine if the dotfile is added to the root of the project or somethere within the `XDG_CONFIG_HOME` directory.

When adding files to the project, the [list of applications that support XDG](https://wiki.archlinux.org/title/XDG_Base_Directory#Supported) work out where the dotfiles should live. Note this is not 100% compete.

Another useful tool is the [xdg-ninja](https://formulae.brew.sh/formula/xdg-ninja#default) package. This analyzes the dotfiles on your machine and highlights any that can be made `XDG` compliant. This tool is installed along with this repo.

## Installation

> This repository is managed using `yadm`. Although it is just a `git` repository, installation is not done using a `git clone`.

The project is configured such that no user specific configuration is checked into the repository. As such, it is safe to use this repository directly. If you intend to make any non-configuration related user specific changes then you should take a fork first.

### Prerequisites

Installation assumes `yadm` and `git` have previously been installed.

Assuming a clean machine install, this can be done as follows:

- Install the xcode developer tools:

    ```sh
    # ensure machine up-to-date
    sudo softwareupdate -i -a

    # install the developer tools
    xcode-select --install
    ```
- Install [Homebrew](https://brew.sh):

    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
- Install git and yadm

    ```sh
    brew install git yadm
    ```

### Dotfiles installation

Assuming all prerequisites have been met, `yadm` can now be used to install the dotfiles:

```yadm
yadm clone <repo_url> --bootstrap
```

This will clone the repository to your home directory and run the installation bootstrap files.

### Verification

Following installation, it is assumed that `iterm` will be used going forward ( over `Terminal` ).

To verify installation has completed successfully, perform the following steps:

- Close `Terminal` and open `item`
- Verify there is no outstanding reconciliation to perform:

    ```sh
    yadm status
    ```
- Verify `yadm` is configured to the correct `git` remote and is pointing at your user home directory:

    ```sh
    # Note the `.` - this is a custom yadm function
    yadm.info
    ```

### User-specific configuration

#### Global git configuration

User-specific `git` configuration should be set in the root level `.gitconfig.local` file created by the installer.

Note this file should not be checked in and has been added to the dotfiles `.gitignore` accordingly.

### Install development environments

Installing specific development languages and runtimes, etc, can run to very large downloads and are hence not done by default.

These can instead be installed at any time as follows:

```sh
# list supported development environments
yadm.list-dev

# install the development environment
yadm.install-dev <environment>
# e.g. yadm.install-dev Mobile
```

The hard work is done in boostrap files located in the `$XDG_CONFIG_HOME/yadm.bootstrap.d/post` directory. To extend this for a new development environment, create one or more bootstrap files using the established naming convention.

E.g. to add support for `Foo`, create a file ensure it ends with `class=Foo`.

## Usage

`yadm` wraps `git` and as such, anything can do anything `git` can do. The management of your dotfiles repo is therefore down to your personal preference wrt `git` usage.

The installer configures `yadm` to display untracked files when performing a `git status`. Combined with the top-level `.gitignore` file, this allows the following simple workflow for committing local changes to your dotfiles to your repos:

```sh
# show the changes ( includes untracked files )
yadm status

# stage and commit them ( made easy through the .gitignore file)
yadm add .
yadm commit -m "your message here"

# push to your remote
yadm push
```

## Testing

Through adoption of `XDG` the project supports running multiple copies of your dotfiles, with one being _live_ at any given time.

### Test repository creation

This allows you to create and test a new copy of your dotfiles in a specific testing path on your machine.

```sh
# create and enter testing directory
mkdir ~/your-testing-location && cd _

# clone dotfiles repository into current directory
yadm.clone
```

This new dotfiles repository will now be live due to root level `.zshenv` file having been created which points to it.

Note that currently it will point to the same remote as the root level dotfiles repository. This can be changed as folllows:

```sh
yadm remote set-url origin <url>
```

### Returning to main dotfiles

Your main dotfiles always live in your root home directory.

These can be restored as follows:

```sh
yadm.restore
```
