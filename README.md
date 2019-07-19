[![Build Status](https://travis-ci.org/iamhsa/pkenv.svg?branch=master)](https://travis-ci.org/iamhsa/pkenv)

# pkenv
[Packer](https://www.packer.io/) version manager mainly inspired by [tfenv](https://github.com/tfutils/tfenv)

## Support
Currently pkenv supports the following OSes
- Linux (64bit)
- Mac OS X (64bit)
- Arm
- Windows - tested in Cygwin and WSL.

## Installation
On Mac OS X, you can install pkenv with [Homebrew](http://brew.sh/):

  ```console
  $ brew tap kwilczynski/homebrew-pkenv
  $ brew install pkenv
  ```

On any other platform, you can install pkenv as follows:

1. Check out pkenv into any path (here is `${HOME}/.pkenv`)

  ```console
  $ git clone https://github.com/iamhsa/pkenv.git ~/.pkenv
  ```

2. Add `~/.pkenv/bin` to your `$PATH` any way you like

  ```console
  $ echo 'export PATH="$HOME/.pkenv/bin:$PATH"' >> ~/.bash_profile
  ```

  OR you can make symlinks for `pkenv/bin/*` scripts into a path that is already added to your `$PATH` (e.g. `/usr/local/bin`) `OSX/Linux Only!`

  ```console
  $ ln -s ~/.pkenv/bin/* /usr/local/bin
  ```
  
  On Ubuntu/Debian touching `/usr/local/bin` might require sudo access, but you can create `${HOME}/bin` or `${HOME}/.local/bin` and on next login it will get added to the session `$PATH`
  or by running `. ${HOME}/.profile` it will get added to the current shell session's `$PATH`.
  
  ```console
  $ mkdir -p ~/.local/bin/
  $ . ~/.profile
  $ ln -s ~/.pkenv/bin/* ~/.local/bin
  $ command -v pkenv
  ```
  

## Usage
### pkenv install [version]
Install a specific version of Packer. Available options for version:
- `i.j.k` exact version to install
- `latest` is a syntax to install latest version
- `latest:<regex>` is a syntax to install latest version matching regex (used by grep -e)

```console
$ pkenv install 1.1.1
$ pkenv install latest
$ pkenv install latest:^1.3
$ pkenv install
```

If `shasum` is present in the path, pkenv will verify the download against Hashicorp's published sha256 hash.
If [keybase](https://keybase.io/) is available in the path it will also verify the signature for those published hashes using Hashicorp's published public key.

You can opt-in to using GnuPG tools for PGP signature verification if keybase is not available:

```console
$ echo 'trust-pkenv: yes' > ~/.pkenv/use-gpgv
$ pkenv install
```

The `trust-pkenv` directive means that verification uses a copy of the
Hashicorp OpenPGP key found in the pkenv repository.  Skipping that directive
means that the Hashicorp key must be in the existing default trusted keys.
Use the file `~/.pkenv/use-gnupg` to instead invoke the full `gpg` tool and
see web-of-trust status; beware that a lack of trust path will not cause a
validation failure.

#### .packer-version
If you use [.packer-version](#packer-version), `pkenv install` (no argument) will install the version written in it.
### Specify architecture

Architecture other than the default amd64 can be specified with the `PKENV_ARCH` environment variable

```console
PKENV_ARCH=arm pkenv install 1.3.1
```

### pkenv use
Switch a version to use
`latest` is a syntax to use the latest installed version
`latest:<regex>` is a syntax to use latest installed version matching regex (used by grep -e)
```console
$ pkenv use 0.12.3
$ pkenv use latest
$ pkenv use latest:^0.12

```
### pkenv uninstall
Uninstall a specific version of Packer
`latest` is a syntax to uninstall latest version
`latest:<regex>` is a syntax to uninstall latest version matching regex (used by grep -e)
```console
$ pkenv uninstall 0.7.0
$ pkenv uninstall latest
$ pkenv uninstall latest:^0.8
```

### pkenv list
List installed versions
```console
$ pkenv list
* 1.1.1 (set by /opt/pkenv-build/work/pkenv/version)
  0.12.3
  0.12.2
  0.7.5
  0.6.1
```

### pkenv list-remote
List installable versions
```console
$ pkenv list-remote
1.4.2
1.4.1
1.4.0
1.3.5
1.3.4
1.3.3
1.3.2
1.3.1
1.3.0
1.2.5
1.2.4
1.2.3
1.2.2
1.2.1
1.2.0
1.1.3
1.1.2
1.1.1
...
```

## .packer-version
If you put `.packer-version` file on your project root, or in your home directory, pkenv detects it and use the version written in it. If the version is `latest` or `latest:<regex>`, the latest matching version currently installed will be selected.

```console
$ cat .packer-version
1.4.2

$ packer --version
1.4.2

$ echo 1.4.2 > .packer-version

$ packer --version
1.4.2

$ echo latest:^1.4 > .packer-version

$ packer version
1.4.2
```

## Upgrading
```console
$ git --git-dir=${HOME}/.pkenv/.git pull
```

## Uninstalling
```console
$ rm -rf /some/path/to/pkenv
```

## LICENSE
- [pkenv itself](https://github.com/iamhsa/pkenv/blob/master/LICENSE)
- [tfenv](https://github.com/tfutils/tfenv/blob/master/LICENSE) : pkenv mainly uses tfenv's source code
