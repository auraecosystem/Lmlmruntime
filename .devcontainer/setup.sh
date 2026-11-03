#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This setup script currently supports Debian/Ubuntu Codespaces images." >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y \
  qemu-system-misc \
  qemu-utils \
  opensbi \
  xz-utils \
  wget \
  curl \
  file \
  fdisk

# UEFI firmware packaging varies across Ubuntu releases. Install it only
# when the package is available; the diagnostic script reports candidates.
if apt-cache show qemu-efi-riscv64 >/dev/null 2>&1; then
  sudo apt-get install -y qemu-efi-riscv64
else
  echo "Optional package qemu-efi-riscv64 is not available in these apt sources."
fi

echo "Lmlmruntime RISC-V tools setup complete."
