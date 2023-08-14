# DOTFILES

## Overview

Highly opinionated cross-platform dotfiles managed using [`yadm`](https://yadm.io) and adhering as far is possible to the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-0.6.html#:~:text=should%20be%20located.-,Basics,by%20the%20environment%20variable%20%24XDG_DATA_HOME%20.)

## Motivation

The implementation of an approach to cross-platform dotfiles addresses the following main concerns:

-   relating to installation:
    -   a centralized remote repository to store the dotfiles;
    -   logic to coordinate the installation of the dotfiles and perform any additional processing;
    -   an approach to selecting the correct logic to run based on the target architecture and other pivot points;
-   relating to management:
    -   reconciliation of local dotfiles with remote repository to ensure all changes remain in sync;
    -   an approach to testing dotfile changes independently from the users primary dotfiles;

`yadm` is one of several approaches to dotfile management and has been selected due to how it maps the above concerns relating to installation to familiar technologies.

The resulting implementation of your dotfiles is largely independant of `yadm`, making it immediately familiar when reviewing the repository. This also makes it simple to migrate away from `yadm` at a future date if so required.

Adherence to XDG was decided upon to centralize the dotfiles in their own specific and configurable location so as to address the above concerns relating to dotfiles management.

Through the use of the XDG path configuration environment variables, multiple copies of the dotfiles repository can be run at once, with a specific version being configured as live. This makes visual regression testing very simple and straightforward to perform.

## Familiarisation

Before proceeding, its worth getting a rough feel for the structure of the repository.

The XDG Base Directory Specification ( XDG herein ) specifies that there should be a single base directory for all user-specific configuration.

Through adoption of the XDG spec therefore, user dotfiles are centralized to the corresponding `XDG_CONFIG_HOME` directory ( typically `.config` ), rather than being scattered around `$HOME` and other various OS specific configuration directories.

It is not possible to adopt XDG completely however, and hence there are a few top-level files in `$HOME` ( the root of the git repo ) corresponding to these cases.

Lastly, the project README and association documentation makes use of githubs support for these being centralized to the top-level `.github` directory.

## Preparation

`yadm` is a thin wrapper around git providing management of your dotfiles using a [bare git repository](https://www.atlassian.com/git/tutorials/dotfiles)

`yadm` manages the installation of the files in the dotfiles repository through a git checkout. Files that already exist will be left unmodified and you will have to review and resolve all differences.

> To simplify any reconciliation - and therefore the installation - it is best to backup and delete any preexisting files before installation.

The specifics of how to peform this archival process depends on the relationship between pre-existing files and `yadm` managed files.

### Direct association between existing file and yadm managed file

Through adoption of the XDG path spec, the dotfiles are largely centered around the `XDG_CONFIG_HOME` directory ( `.config` ). There are also a few top-level files in situations where XDG is not supported. All github documention is

### Indirect association between existing file and yadm managed file

### No association between existing file and yadm managed file

https://wiki.archlinux.org/title/XDG_Base_Directory#Supported
xdg-ninja

Sugggested archival approach:

## Installation

Fork or .gitconfig.local

## Usage

## Features

-   rough lay of the land .config, .local
-   Local backup
-   .gitconfig.local
-   making updates ( yadm usage, .gitignore )
-   installation

## Testing

-   yadm clone -w path --bootstrap
-   kevin flynn using test class
