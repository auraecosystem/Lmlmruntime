#!/usr/bin/env bash
set -u

section() { printf '\n== %s ==\n' "$1"; }

section "Host"
uname -a
if command -v lsb_release >/dev/null 2>&1; then lsb_release -a 2>/dev/null || true; fi

section "QEMU"
if command -v qemu-system-riscv64 >/dev/null 2>&1; then
  qemu-system-riscv64 --version
  echo
  qemu-system-riscv64 -machine help 2>&1 | grep -E '(^|[[:space:]])virt([[:space:]]|$)' || echo "No 'virt' machine entry was detected."
else
  echo "qemu-system-riscv64 is not installed."
fi

section "Firmware candidates"
find /usr/share -type f \( -iname '*riscv*.fd' -o -iname '*riscv*code*' -o -iname '*riscv*vars*' \) -print 2>/dev/null | sort || true

section "FreeBSD RISC-V images in workspace"
find . -maxdepth 3 -type f \( -iname '*FreeBSD*14.5*riscv*' -o -iname '*.iso' -o -iname '*.img.xz' \) -print 2>/dev/null | sort || true

section "Tool availability"
for tool in qemu-img xz curl wget file fdisk; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '%-10s %s\n' "$tool" "$(command -v "$tool")"
  else
    printf '%-10s %s\n' "$tool" "not installed"
  fi
done

cat <<'NOTE'

Next step:
  Share this output before attempting to boot the guest.

This diagnostic does not prove that a particular FreeBSD image is compatible
with QEMU's generic 'virt' machine. Confirm the release media, firmware and
device support before launching a VM.
NOTE
