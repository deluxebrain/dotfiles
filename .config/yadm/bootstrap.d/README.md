# Bootstrappers

Bootstrap files are chunked into groups and run in numberical order. The groups are defined as follows:

1. continuation of yadm and dotfiles repository installation
2. system and package prerequisites
3. system configuration
4. windowing, terminal and ide configuration
5. app configuration

Bootstrappers that have alternate files are generated as follows:

```sh
yadm alt
```

All alternate file configurations need to be matched for that specific bootstrapper to be selected.

Yadm `Class` is used to provide alternative bootstrappers based on use-case.

It can be set and unset as follows:

```sh
yadm config local.class Foo
yadm config local.class # returns Foo
yadm config --unset local.class
yadm config local.class # returns empty
```

E.g. `class.Switch` provides overrides for when switching between dotfile repositories.

The design of the `Class` file attributes was made such that the default situation of no class attributes being set leads to a full install. This is so as to ensure `yadm clone --boostrap` works as intended ( a full installation of your dotfiles ). However this does lead to a clunky implementation with more alternate files required than would otherwise be the case.
