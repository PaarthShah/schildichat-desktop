# SchildiChat Web/Desktop

SchildiChat Web/Desktop is a fork of Element [Web](https://github.com/vector-im/element-web)/[Desktop](https://github.com/vector-im/element-desktop).

The most important changes of SchildiChat Web/Desktop compared to Element Web/Desktop are:
- Customizable room list style (compact single line, intermediate and roomy with two line preview)
- Option to show direct and group chats in a combined list
- Improved theming options
- Message bubbles
- &hellip; and more!

Desktop downloads with installation instructions are listed on our website: [https://schildi.chat/desktop](https://schildi.chat/desktop)  
Hosted web variant: [https://app.schildi.chat/](https://app.schildi.chat/)

Feel free to [join the discussion on matrix](https://matrix.to/#/#schildichat-web:matrix.org).

<img src="https://raw.githubusercontent.com/SchildiChat/schildichat-desktop/sc/screenshots/1.png"/>

<details>
<summary>Public key used to sign the Debian packages</summary>

```
pub   rsa4096 2020-12-08 [SC]
      560BB70DA86A6633A39CEC6023358905FE294D01
uid           Super apt repo key <apt@supercable.onl>
sub   rsa4096 2020-12-08 [E]
```

</details>


## Building SchildiChat Web/Desktop

This particular repo is a wrapper project for element-desktop, element-web, matrix-react-sdk and matrix-js-sdk. It's the recommended starting point to build SchildiChat for Web **and** Desktop.

The `master` branch contains the latest release.  
Development happens in the `sc` branch, which might be **broken at any time**!

<pre><code><b>schildichat-desktop</b> <i>&lt;-- this repo</i> (recommended starting point to build SchildiChat for Web <b>and</b> Desktop)
|-- <a href="https://github.com/SchildiChat/element-desktop">element-desktop</a> (electron wrapper)
|-- <a href="https://github.com/SchildiChat/element-web">element-web</a> ("skin" for matrix-react-sdk)
|-- <a href="https://github.com/SchildiChat/matrix-react-sdk">matrix-react-sdk</a> (most of the development happens here)
`-- <a href="https://github.com/SchildiChat/matrix-js-sdk">matrix-js-sdk</a> (Matrix client js sdk)
</code></pre>

### Install dependencies

#### Debian build dependencies

Since Debian is usually slow to update packages on its stable releases,
some dependencies might not be recent enough to build SchildiChat.  
The following are the dependencies required to build SchildiChat Web/Desktop on Debian 11 (bullseye):

```
# apt install vim curl git make gcc g++ python jq libsqlcipher-dev pkg-config libsecret-1-dev libarchive-tools openssl libssl-dev tcl

# curl -sL https://deb.nodesource.com/setup_14.x | bash -
# apt update
# apt install nodejs

# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# apt update
# apt install yarn

$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
$ echo 'export PATH="$PATH:$HOME/.cargo/bin"' >> .bashrc
$ source .bashrc
```

#### macOS build dependencies

##### Install brew package manager
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

##### Install packages

```
brew install tcl rust node gpg vim curl git yarn git make gcc
```

#### Signed macOS builds

To sign a macOS build set the environment or make variable `CSC_IDENTITY_AUTO_DISCOVERY` to true
or set `CSC_NAME` to your certificate name or id.

To notarize a build with Apple set `NOTARIZE_APPLE_ID` to your AppleID and set the keychain item
`NOTARIZE_CREDS` to an App specific AppleID password.  


### Initial setup

As already noted above, **`master` contains the latest release** and **`sc` is the development branch**!

```
git clone -b master --recurse-submodules https://github.com/SchildiChat/schildichat-desktop.git
cd schildichat-desktop
make setup # optional step if using the other make targets
```

### Create release builds

```
# The single make targets are explained below
make {web|debian|windows-setup|windows-portable|macos|...}-release
```

After that these packages which belong to their respective make target should appear in release/\<version\>/.

#### Builds distributed via GitHub releases
- `web`: _schildichat-web-\<version\>.tar.gz_: Archive that can be unpacked and served by a **web** server (copy `config.sample.json` to `config.json` and adjust the [configuration](https://github.com/SchildiChat/element-web/blob/sc/docs/config.md) to your likings)
- `debian`: File ready for installation on a **Debian Linux** (based) system via `dpkg -i schildichat-desktop_<version>_amd64.deb`
- `windows-setup`: _SchildiChat_Setup_v\<version\>.exe_: File ready for **installation** on a **Windows** system
- `windows-portable`: _SchildiChat_win-portable_v\<version\>.zip_: **Portable** version for a **Windows** system – take SchildiChat together with your login data around with you (the archive contains a readme with **instructions** and **notes**)
- `macos`: Build a *.dmg for **macOS**

#### Additional `{...}-release` targets not used for GitHub releases
- `pacman`: File ready for installation on an **Arch Linux** (based) system via `pacman -U schildichat-desktop-<version>.pacman`
- `rpm`: Build a *.rpm for Linux
- `windows-unpacked`: _SchildiChat_win-unpacked_v\<version\>.zip_: **unpacked** archive for a **Windows** system
- `macos-mas`: Build a *.pkg for release in the Mac App Store

### Build SchildiChat Web and deploy it directly to your web server

Put the `config.json` with the [configuration](https://github.com/SchildiChat/element-web/blob/sc/docs/config.md) you want for your hosted instance in a subfolder of the `configs` folder.  
Then create a file named `release.mk` and fill it similar to that:
```
.PHONY: your-deploy-web

YOUR_CFGDIR := configs/your_subfolder
your-deploy-%: CFGDIR := $(YOUR_CFGDIR)

your-deploy-web: web
	rsync --info=progress2 -rup --del element-web/webapp/ you@yourwebserver:/the/folder/served/for/schildi/
```
