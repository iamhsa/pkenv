[![Build Status](https://travis-ci.org/iamhsa/pkenv.svg?branch=master)](https://travis-ci.org/iamhsa/pkenv)

# pkenv
[Packer](https://www.packer.io/) version manager mainly inspired by [tfenv](https://github.com/kamatama41/tfenv)

## Support
Currently pkenv supports the following OSes
- Linux (64bit) (tested)

## Installation
1. Check out pkenv into any path (here is `${HOME}/.pkenv`)

  ```sh
  $ git clone https://github.com/iamhsa/pkenv.git ~/.pkenv
  ```

2. Add `~/.pkenv/bin` to your `$PATH` any way you like

  ```sh
  $ echo 'export PATH="$HOME/.pkenv/bin:$PATH"' >> ~/.bash_profile
  ```

  OR you can make symlinks for `pkenv/bin/*` scripts into a path that is already added to your `$PATH` (e.g. `/usr/local/bin`) `OSX/Linux Only!`

  ```sh
  $ echo 'export PATH="$HOME/.pkenv/bin:$PATH"' >> ~/.bash_profile
  ```

  OR you can make symlinks for `pkenv/bin/*` scripts into a path that is already added to your `$PATH` (e.g. `/usr/local/bin`) `OSX/Linux Only!`

  ```sh
  ln -s ~/.pkenv/bin/* /usr/local/bin
  ``` 

## Usage
### pkenv install
Install a specific version of Packer  
`latest` is a syntax to install latest version
`latest:<regex>` is a syntax to install latest version matching regex (used by grep -e)
```sh
$ pkenv install 0.7.0
$ pkenv install latest
$ pkenv install latest:^0.12
```

If shasum is present in the path, pkenv will verify the download against Hashicorp's published sha256 hash. If [keybase](https://keybase.io/) is available in the path it will also verify the signature for those published hashes using hashicorp's published public key. 

If you use [.packer-version](#packer-version), `pkenv install` (no argument) will install the version written in it.

### pkenv use
Switch a version to use
`latest` is a syntax to use the latest installed version
`latest:<regex>` is a syntax to use latest installed version matching regex (used by grep -e)
```sh
$ pkenv use 0.12.3
$ pkenv use latest
$ pkenv use latest:^0.12

```
### pkenv uninstall
Uninstall à specific version of Packer
`latest` is a syntax to uninstall the latest version
`latest:<regex>` is a syntax to uninstall latest version matching regex (used by grep -e)
```sh
$ pkenv uninstall 0.7.0
$ pkenv install latest
$ pkenv install latest:^0.12
```

### pkenv list
List installed versions
```sh
% pkenv list
1.0.0
0.12.3
0.12.2
0.7.5
0.7.2
0.6.1
```

### pkenv list-remote
List installable versions
```sh
% pkenv list-remote
0.12.3
0.12.2
0.12.1
0.12.0
0.11.0
0.10.2
0.10.1
0.10.0
...
```

## .packer-version
If you put `.packer-version` file on your project root, pkenv detects it and use the version written in it.

```sh
$ cat .packer-version
0.12.2

$ packer version
Packer v0.12.2

$ echo 0.12.0 > .packer-version

$ packer version
Packer v0.12.0

$ echo latest:^0.12 > .packer-version

$ packer version
Packer v0.12.3
```

## Upgrading
```sh
$ git --git-dir=~/.pkenv/.git pull
```

## Uninstalling
```sh
$ rm -rf /some/path/to/pkenv
```

## LICENSE
- [pkenv itself](https://github.com/iamhsa/pkenv/blob/master/LICENSE)
- [tfenv](https://github.com/kamatama41/tfenv/blob/master/LICENSE) : pkenv mainly uses tfenv's source code
