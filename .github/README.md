# DOTFILES

## Overview

Highly opinionated dotfiles managed using [yadm](https://yadm.io) and adhering as far is possible to the XDG path spec.

## Before you start

yadm is a thin wrapper around git providing management of your dotfiles using a [bare git repository](https://www.atlassian.com/git/tutorials/dotfiles)

yamd manages the installation of the files in the dotfiles repository through a git checkout. Files that already exist will be left unmodified and you will have to review and resolve all differences.

> To simplify this reconciliation process it is best to backup and delete any preexisting files before installation.

The specifics of how to peform this archival process depends on the relationship between pre-existing files and yadm managed files.

### Direct association between existing file and yadm managed file

### Indirect association between existing file and yadm managed file

### No association between existing file and yadm managed file

Sugggested archival approach:

## Installation

## Usage

## Features

-   rough lay of the land .config, .local
-   Local backup
-   .gitconfig.local
-   making updates ( yadm usage, .gitignore )
-   installation
