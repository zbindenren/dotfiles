# Dotfiles Repository

<!-- vim-markdown-toc GitLab -->

- [Prerequisites](#prerequisites)
  - [Linux](#linux)
- [Manual Installation](#manual-installation)
- [Configuration](#configuration)
- [Updating](#updating)
- [Customizing](#customizing)
  - [Adding New Dotfiles](#adding-new-dotfiles)
- [Extending](#extending)
  - [Adding New Tools](#adding-new-tools)
  - [Organization Best Practices](#organization-best-practices)
  - [Repository](#repository)
- [Encryption with Age](#encryption-with-age)
  - [Setup Age Encryption](#setup-age-encryption)
  - [Encrypting Files](#encrypting-files)
  - [Encrypting Template Variables](#encrypting-template-variables)
  - [Moving to a New Machine](#moving-to-a-new-machine)
- [Package Installation](#package-installation)
  - [Customizing Packages](#customizing-packages)
  - [Skipping Package Installation](#skipping-package-installation)

<!-- vim-markdown-toc -->

A cross-platform dotfiles repository managed with Chezmoi. This repository contains configuration files for various applications and tools, organized to work seamlessly across macOS and Linux environments.

## Prerequisites

- Git
- [Chezmoi](https://www.chezmoi.io/)
- [Age](https://github.com/FiloSottile/age) (for encrypted files)

### Linux

The following shortcuts are configured:

```txt
<hyper>+t: jumpapp kitty --start-as=fullscreen
<hyper>+c: jumpapp chromium
```

## Manual Installation

1. Install Chezmoi:

   - macOS: `brew install chezmoi`
   - Linux: `sh -c "$(curl -fsLS get.chezmoi.io)"`

2. Initialize with this repository:

   ```sh
   chezmoi init https://github.com/username/dotfiles.git
   ```

3. Check what changes would be made:

   ```sh
   chezmoi diff
   ```

4. Apply the changes:

   ```sh
   chezmoi apply -v
   ```

## Configuration

### Work Environment

Create the following file `~./config/chezmoi/chezmoi-work.yaml`:

```yaml
---
email: < work email address >
sshuttle_default_host: < default shottle jump host >
sshuttle_paam_host: < paam shottle jump host >
jump_hosts:
  - < jump host 1 >
  - < jump host 2 >
  - < jump host 3 >
network:
  domain: < domain >
  noproxy: < list of no proxy addr >
  proxy: http://localhost:3128
```

### Private Environment

Create the following file `~./config/chezmoi/chezmoi-private.yaml`:

```yaml
---
email: < private email address >
```

## Updating

To update your dotfiles to the latest version:

```sh
# Pull the latest changes
chezmoi update

# Review changes before applying
chezmoi diff

# Apply the changes if they look good
chezmoi apply
```

## Customizing

### Adding New Dotfiles

To add a new configuration file to be managed:

```sh
# Add a file to chezmoi
chezmoi add ~/.config/some-app/config

# For template files (with platform/environment specifics)
chezmoi add --template ~/.config/some-app/config

# Edit the newly added file
chezmoi edit ~/.config/some-app/config

# Apply changes
chezmoi apply
```

## Extending

### Adding New Tools

This repository is designed to be extended with your preferred tools:

1. Install the tool (via package manager)
2. Add its configuration with `chezmoi add`
3. Use templating if configurations differ between platforms:

   ```txt
   {{ if eq .chezmoi.os "darwin" }}
   # macOS specific settings
   {{ else }}
   # Linux specific settings
   {{ end }}
   ```

### Organization Best Practices

- Group related configurations in directories
- Use Chezmoi's `run_` scripts for installation steps
- Document complex setups in comments

### Repository

The repository contains the following helper files:

- `.chezmoiignore`: List of files that are ignored by chezmoi
- `packages-arch-pacman.txt`: Packages installed with pacman
- `packages-arch-yay.txt`: Packages installed with yay
- `run_once_before_decrypt-private-key.sh.tmpl`: Decrypt age key by asking for the passphrase
- `run_once_install-packages.darwin.sh.tmpl`: macOS package installation script
- `run_once_install-packages.linux.sh.tmpl`: linux package installation script

## Encryption with Age

This repository supports encrypting sensitive files and variables using [Age](https://github.com/FiloSottile/age).

### Setup Age Encryption

1. Install Age:

   ```sh
   # macOS
   brew install age

   # Linux
   # Download from https://github.com/FiloSottile/age/releases
   ```

2. Generate an Age key (if it does not exist already):

   ```sh
   age-keygen -o ~/.local/share/chezmoi/key.txt.age -p
   ```

### Encrypting Files

To add an encrypted file:

```sh
# Add and encrypt a file (e.g., API tokens)
chezmoi add --encrypt ~/.config/some-service/credentials

# Edit the encrypted file
chezmoi edit ~/.config/some-service/credentials
```

### Encrypting Template Variables

For sensitive variables in templates:

1. Create an encrypted data file:

   ```sh
   chezmoi cd
   echo '{"github_token":"secret-token-here"}' | chezmoi encrypt --output data/secrets.json
   ```

2. Access encrypted values in templates:

   ```txt
   {{ (index . "github_token") }}
   ```

## Package Installation

This repository automatically installs necessary packages defined in `.chezmoi.yaml.tmpl`. The installation uses:

- Homebrew for macOS
- Native package managers Arch Linux

### Customizing Packages

Add packages to:

- `packages-arch-pacman.txt` for packages installed with pacman
- `packages-arch-yay.txt` for packages installed with yay

### Skipping Package Installation

To skip automatic package installation:

```sh
chezmoi apply --exclude=scripts
```
