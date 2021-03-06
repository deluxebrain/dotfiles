# Python

## Python development environments

... without destroying your system in the process [https://xkcd.com/1987/]

To define the scope of a Python development environment, it should provide the following:

First, support for the development of multiple Python projects on the same system.
Projects need to be isolated from each other to allow for differing Python versions
and package dependencies to be specified at the project level.

Secondly, support for global development tooling which can be shared across Python projects.
Global tooling should remain isolated from Python projects, and not lead to dependencies with the
Python version nor package dependencies within the Python projects themselves.

### System Python

System Python is defined as the version of Python and its associated ecosystem that is packaged with
the OS distribution or that is distributed by the official distribution package manager.

On Ubuntu, the official system Python ecosystem is as follows:

```sh
which python
# /usr/bin/python

which pip
# /usr/bin/pip
```

Some OS distributions come packaged with components that have a dependency on Python.
These dependencies would be fulfilled by the system Python as defined above.

The system Python ecosystem does not natively support the side-by-side installation of different versions,
nor allow for project-level scoping of packages.

Therefore unconsidered use of Python can lead to coupling of Python development environments,
and damage to the system Python.

### An example of how to break System Python

Consider a system which has system Python and pip installed:

```sh
sudo apt-get install -y Python
sudo apt-get install -y pip
```

The Python ecosystem will be installed as `system` as follows:

```sh
which python
# /usr/bin/python

which pip
# /usr/bin/pip
```

At this stage, the Python ecosystem will be working as expected. For example:

```sh
pip install --user awscli
aws --version
```

However, observe what happens if we attempt to upgrade pip outside of the system Python ecosystem:

```sh
pip install --upgrade pip
pip install --user powerline-status
# Error
```

The upgrade of pip leads to a new version of pip being installed in the following location:
`$HOME/.local/bin/pip`.

This location is not by default on the path and hence Python continues to use the system version.
Due to breaking changes between system pip and later pip versions, this leads to the errors above.

In this case, the issue can be resolved by updating the path as follows:

```sh
PATH="$HOME/.local/bin:$PATH"
```

### Three aspects of a Python development environment

The following three aspects of the system Python ecosystem define the requirements for
a Python development environment:

#### System Python should remain the default Python version

System components with a dependency on Python require the system Python to be the default version,
regardless the context of their execution.

To be explict, no manipulation of the path should be required for this to be the case.

Consider a counter example where pip has been installed outside of the system Python ecosystem.
In this case, the newer version of pip will be installed alongside the system pip version.
This will affectively break all system pip usage unless the path is explicitly set to resolve to the newer version.

Python versions managed as part of the Python development environment should therefore require
explicit activiation and be scoped to the current environment.

#### System Python is only differentiable at the major version number

Official OS package managers distribute Python 2 and Python 3 as distinct packages. For example:

```sh
sudo apt-get install -y python
sudo apt-get install -y python3

which python
# /usr/bin/python

which python3
# /usr/bin/python3
```

Due to the nature of the packaging, system Python versions are only differentiable at the major version number.

System components with a dependency on Python can therefore only declare their dependency in terms
of the Python major version. The minor and patch versions ( and hence the specific Python version )
is expected to remain consistent with the version the depency was initiall taken again.

For this reason, system Python versions should only ever be upgraded through the official OS package manager,
which ensures the dependency graph is upgraded atomically.

#### System Python packages have limited scoping

The default Python ecosystem has very limited capabilities to control the scoping of Python packages.

Python packages installed via pip into the system Python are either global to the machine or the user.

This can lead to dependency issues where two Python packages depend on different and incompatble versions
of the same package. Installing one of these packages will by definition break the other.

For this reason, installation of packages into the sytem Python should be performed sparingly and only
for packages that are genuinley required at the system or user level.

A Python development environment should therefore allow packages to be specified and scoped at the project level.

Tensorflow would be an example of a bad candidate for a system Python package due to its complex
dependency graph and the likelihood for different projects to require different versions.
This should be specified as a project level package.

Powerline would be an example of a good candidate for a sytem Python package as this is a genuine
global component that is required across projects.
This should therefore be installed into the system python.

## Approaches for the creation of a Python development environment

Python is used in several ways on a development machine:

- As a project runtime within Python projects;
- Project-level development dependencies, such as testing frameworks;
- Machine-wide development dependencies, such as the AWS cli, Powerline, etc;

All use of Python outside of the latter are performed at the project level and can be isolated from system
python through pyenv and pipenv.

Machine-wide usage of Python is more problematic. The following approaches are possible:

- Direct usage of the system Python
- Usage of Python version managed through pyenv
- Usage of Python virtual environment through virtualenv

Pyenv managed Python versions are only accessible after activation of Pyenv, and do not prevent
the resolution of packages installed into the system Python.

The system Python and Python versions managed through pyenv are therefore completely separate.

Packages can be installed into the system python at the user level using the `--user` pip flag,
hence avoiding `sudo` requirements whilst also preventing packages contaminating other accounts.

This makes system Python a perfect choice for the global Python environment.

## Tools to support the creation of a Python development environment

These tools are used to solve the following problems associated with Python development;
managing muliple versions of Python on the same system, and providing project-level isolation of Python dependencies.

1. pyenv

    Used to isolate Python versions allowing multiple versions of Python to coexist and without impacting the system Python.
    Provides support for specifying Python version at the project level using the `pyenv local <version>` command.

2. pipenv

    Tool that provides complete Python development tooling, including virual environment and dependency management.
    Note that `pipenv` has no support for `conda` and hence is only Intended to be used for non-`conda` projects.
    By default uses the Python it is installed against to create virtual environments. This can be overriden using the `--python` option or by setting the `PIPENV_PYTHON` environment variable.

3. miniconda

    Python environment for data science that combines a Python runtime as well as virtual environment and package management. Used in preference to `anaconda` which also comes prebundles with a lot of data science packages. The mini/anaconda Python environment comes packaged with the Intel Math Kernel Library (mkl) versions of `NumPy`, etc.

4. pyenv-virtualenv

    As architected in these dotfiles `pyenv-virtualenv` is intended to be used purely integration with miniconda.
    If you find yourself writing `pyenv virtualenv` outside of conda projects please use `pipenv` instead.
    Note that it is possible to configure pipenv to use virtual environments managed by pyenv-virtualenv.
    In addition to sounding slightly perverse this does not work in practice.

5. pip

    Used for installing packages into pyenv Python versions, or virtual environments.
    In all other cases package management is natively provided by both `conda` and `pipenv`.
    E.g. `pipenv install <package>`.

## PyEnv 101

### Setting Python versions

Pyenv records the globally specified python version in the following file:
`~/.pyenv/version`

Locally specified python versions are recorded in the following file;
`.python-version`

It is also possible to override the python version using the `PYENV_VERSION` environment
variable.

It is possible to specify multiple python versions, which then define an ordered resolution scope.
Note that pip packages installed in python versions are also available when this python version
is not specified as the primary version. However - they will not appear in a `pip list`, etc.

```sh
# Set project-level Python version
pyenv local <version> ...

# Set global Python version used in all shells
pyenv global <version> ...

# Set global Python to system Python ( as determined by $PATH )
pyenv global system

# Show current Python version
pyenv version
```

### Installing Python versions

```sh
# List Python versions available to install
pyenv install --list

# Install Python <version>
pyenv install <version>

# Show installed Python versions
pyenv versions
```

## Conda 101

### Basic workflow when used with pyenv

The integration of conda virtual environments with pyenv is provied through pyenv-virtualenv.
In addition, this also provides auto activation of conda environments on project entry.

```sh
# Create conda environment
pyenv virtualenv <version> <name>
pyenv local <name>

# To load manually
pyenv activate <name>
pyenv deactivate <name>
```

### Managing environments

```sh
# List all environments ( active marked with * )
conda env list

# Removing an environment
conda env remove --name <name> --all

# List packages installed in environment
conda list [-n <name>]
```

### Sharing environments

```sh
# Export active environment file
conda env export > environment.yml

# Create environment from environment file
conda env create -f environment.yml
```

## Pipenv 101

> NOTE 20181119
> Using `pipenv install` to create a env pipenv environment using pyenv managed python no longer appears to work.
> Use `pipenv --python $(pyenv which python)` instead.

Pipenv can be configured to use pyenv for python version management through the `PIPENV_PYTHON`
environment variable.

Pipenv will install from a `Pipfile` if present in the executing directory.

Pipenv generates a `Pipfile` and `Pipfile.lock` file. Both of these should be added to source control.

### Standard workflow

```sh
# Create and enter project directory
mkdir <project> && cd $_

# Initialize Pipenv
pipenv install [--python <version>]

# Install production dependencies
pipenv install <package>

# Install development dependencies. E.g. unit testing packages
pipenv install --dev <package>

# Generate Pipfile listing all project dependencies
pipenv lock

# Activate Pipenv shell
pipenv shell
python --version

# Run Python script in Pipenv virtual environment
pipenv run python <script>
```

## Suggested development workflows

### Conda project

```sh
# Create and enter project directory
mkdir foo && cd $_

# Create conda environment
pyenv virtualenv <version> <name>

# Use conda environment locally
pyenv local <name>

# Install dependencies
conda install -y <package>
```

### Pipenv project

```sh
# Create and enter project directory
mkdir foo && cd $_

# Set local Python version
pyenv local 3.7.1

# Create pipenv environment
pipenv install --python `pyenv which python`

# Install dependencies
pipenv install <package>

# Run Python script
pipenv run python <script>

# Enter pipenv environment shell
pipenv shell
```

## Jupyter Notebook workflows

Note that the `jupyter` package installs both `notebook` and `ipykernel` as dependencies.

Jupyter server is configured using the following file:
`~/.jupyter/jupyter_notebook_config.py`

### Conda environment workflow

From within your activated conda environment:

```sh
conda install -y jupyter

# Allow the current environment to be accessed from notebook
conda install -y nb_conda

# Launch the Jupyter server
jupyter notebook
```

### Pipenv environment workflow

First, create your pipenv based project as above. Then proceed as follows:

```sh
pipenv install jupyter

pipenv run jupyter notebook
```

## Notes

### Upgrading Pip

Pip 10 was introduced in 2018 and included a lot of breaking changes.

As of writing, Pip installed through `apt` is still on version 9 and is installed here: `/usr/bin/pip`.

Upgrading Pip using Pip ( and hence outside of `apt` ), can be done as follows:

```sh
pip install --upgrade pip

```

This installs the latest version of Pip ( as of writing, version 18 ) into the following location: `$HOME/.local/bin/pip`.

I.e. you end up with two versions of pip that are not compatible. By default, the path will resolve the version of pip in `/usr/bin`.

This can be manage in one of two ways:

- Never upgrade pip outside of `apt`
- Add '/$HOME/.local/bin/pip' to the path before `/usr/bin`.

The second approach is required anyway to support `pip install --user` and hence is the preferred approach.

This leads to the following important caveat: Pip packages should not be installed until the path has been configured to prepend the local path.

### Pipenv and its interaction with system Python

> More information here: [https://github.com/pypa/pipenv/issues/2122]

Pipenv has a dependency on Pip. Importantly, it also appears to manages this dependency itself.

For example:

```sh
which pip           # /usr/bin/pip
pip install pipenv
which pip           # ~/.local/bin/pip
```

I.e. the installation of Pipenv appears to lead to an upgrade of Pip outside of `apt`.

Note that the installation of Pipenv will therefore fail if the path is not set correctly to resolve `$HOME/.local/bin` ahead of `/usr/bin`.

This leads to the following important caveat: Pipenv should not be installed until after the path is set to prepend the local path.

### Use of pyenv-virtualenv

Plugin for `pyenv` to provide `virtualenv` and `conda` environments for Python.
These provide isolated working copies of Python which prevent one project and its dependencies affecting another.

Note that `pyenv-virtualenv` is being used for a couple of explicit reasons related to the setup of the system, as follows:

1. conda integration with pyenv

    `pyenv-virtualenv` provides `conda` integrations with `pyenv` to allow `conda` to work properly with Python versions managed by `pyenv`.

    See below

2. Provision of global virtual environment

    See below.

### Using VirtualEnv for virtual environment management

```sh
# List virtual environments
pyenv virtualenvs

# Create project virtualenv
pyenv virtualenv [<version>] <name>

# To manually activate / deactive the virtual environment
pyenv activate <name>
pyenv deactivate

# Use the virtualenv as part of a pyenv environment
pyenv local <name>
```

E.g. the following would create a global virtual environment for the installation of common packages.
This helps preserve the system python by preventing packages being directly installed into it.

```sh
pyenv virtualenv 3.7.1 globalenv
pyenv activate
pip install <package> ...
pyenv deactivate
pyenv global 3.7.1 globalenv
```

### Using conda with pyenv

> NOTE 20181119
> Due to a bug with pyenv / pyenv-virtualwrapper, the above approach to managing conda virtual environment using pyenv-virtualenv does not work.
> See here: [https://github.com/pyenv/pyenv-virtualenv/issues/178]
> The suggested solution is implemented in the Python provisioner.

As per all Python versions, conda is installed through pyenv.

With pyenv-virtualenv installed, it is then possible to use conda in the normal way. E.g.

```sh
# Use miniconda
pyenv local miniconda

# Create named conda environment
# By default will use the current Python version
conda create -n <name> [python=<version>]

# Activate environment
conda activate

# Deactivate environment
conda deactivate
```

However, this approach ends up with inconsistent virtual environments, as follows:

```sh
pyenv install miniconda
```

This creates a pyenv version for miniconda that is actually a virtual environment, as demonstrated as follows:

```sh
pyenv virtualenvs
```

However, conda environments created from within this conda Python version do not appear as virtual environments.
For example, the following will not create any additional virtual environments:

```sh
pyenv activate <name>
echo $VIRTUAL_ENV       # points to <name>
conda create -yn <env>
echo $VIRTUAL_ENV       # still points to <name>
pyenv virtualenvs       # <env> not listed
```

This causes issues with Powerline, as it uses the following quasi-logic to determine the enviromnment name to display:

- Is $VIRTUAL_ENV set? Then display environment name given by $VIRTUAL_ENV
- Else is $CONDA_DEFAULT_ENV set? Then display environment given by $CONDAA_DEFAULT_ENV

Due to the above issues of inconsistencies, Powerline will always use the pyenv conda version name as the environment name.

It also causes the inconvenience that the conda environment is not automatically activated on entering the project directory.

The correct approach is therefore to use pyenv-virtualenv to manage conda virtual environments, as follows:

```sh
# Use a pyenv-virtualenv to create a virtual environment to act as the conda environment
pyenv virtualenv <version> <name>
pyenv local <name>

# Verify conda recognises the virtual environment as a conda environment
conda env list
```

### Approaches to a Python development environment that dont work

#### Global virtual environment

Alternatively, a pyenv managed virtual environment could be used to provide isolation from the system Python.

```sh
pyenv virtualenv 3.7.1 globalenv
pyenv activate
pip install awscli
pyenv deactivate
# Set global Python, including a reference to the global env
pyenv global system globalenv
```

However, for this to work the global virtual environment would need to be referenced by local python versions
in order for it to resolve global packages. This then leads to the global virtual environment becoming a development
dependency through it being referenced in the project-level `.python-version` file. For example:

```sh
pyenv local 3.7.1 globalenv
cat .python-version # references globalenv
```

#### Pyenv managed global Python version

Another approach could be to use a pyenv managed Python version globally, into which all global python packages
are installed:

```sh
pyenv global 3.7.1
pip install awscli
```

Any project-level dependency on Python 3.7.1 ( in the above case ) can access the globally installed packages.

For this to work, all global packages need to be installed into all Python versions installed through pyenv.
E.g. in the above case Python 3.7.0 projects would not be able to access the awscli package.
It is possible to automate the installation of packages into pyenv managed Python environments through a pyenv plugin.

However, this leads to the packages in the global Python becoming dependencies of local Python versions.
As they are installed into the local Python version, they also appear in the associated pip requirements file.
