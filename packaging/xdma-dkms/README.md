# XDMA DKMS Debian Package

This packaging builds the AMD/Xilinx XDMA reference driver as an `xdma-dkms`
Debian package. It targets Debian 13 and Ubuntu 24.04.

## Build

Install the package build dependencies:

```bash
sudo apt update
sudo apt install dh-dkms debhelper devscripts dpkg-dev fakeroot lintian
```

Build the binary package from the repository root:

```bash
./packaging/xdma-dkms/build-deb.sh
```

The resulting package is written to the parent directory:

```text
../xdma-dkms_2025.2.0-1_all.deb
```

## Install

Install matching headers for the running kernel and then install the package:

```bash
sudo apt install "linux-headers-$(uname -r)"
sudo apt install ../xdma-dkms_2025.2.0-1_all.deb
```

The package does not load or reload the module during installation. Load it
manually for the first test:

```bash
sudo modprobe xdma
```

The installed modules-load configuration loads `xdma` on subsequent boots.

## Device Access

Device nodes are restricted to the `xdma` system group with mode `0660`.
Add users that need access to the group, then start a new login session:

```bash
sudo usermod -aG xdma "$USER"
```

## Verify

```bash
dkms status
modinfo xdma
lsmod | grep xdma
ls -l /dev/xdma*
lspci -nnk | grep -A3 -i xilinx
sudo dmesg | grep -i xdma
```

## Remove

```bash
sudo apt remove xdma-dkms
```

The package deliberately leaves the `xdma` system group in place so existing
user group assignments remain stable across reinstalls.

## Troubleshooting

- If DKMS reports missing kernel build files, install
  `linux-headers-$(uname -r)`.
- If `modprobe xdma` fails, inspect `sudo dmesg | tail -100`.
- If device nodes are inaccessible, verify the user belongs to the `xdma`
  group and has started a new login session.
- Secure Boot systems may require signing or enrolling the DKMS module before
  it can be loaded.
