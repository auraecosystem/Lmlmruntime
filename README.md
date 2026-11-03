# Lmlmruntime

Lmlmruntime is the execution-runtime project for LMLM. Its first virtualisation target is **FreeBSD 14.5 on RISC-V 64-bit using QEMU**.

## Project boundaries

- LMLM remains the control plane for orchestration, identity, policy and task management.
- Guest operating systems are execution environments, not dependencies of LMLM Core.
- QEMU is the initial virtual-machine backend; it does not define the whole runtime.
- Remote execution must be authenticated, explicitly authorised and policy-governed.
- Do not assume a board-specific disk image boots on QEMU's generic `virt` machine.

## Current milestone: validate the RISC-V host

This repository includes a GitHub Codespaces development environment and a diagnostic script. From an iPhone, open the repository in GitHub, create a Codespace, then run:

```bash
bash scripts/check-riscv-env.sh
```

The script reports the QEMU version, available RISC-V machines, firmware candidates and any FreeBSD 14.5 RISC-V images found in the workspace. It does not download or boot an image.

## Next milestones

1. Validate QEMU's RISC-V `virt` machine and available firmware.
2. Confirm the supported FreeBSD 14.5 RISC-V boot media and boot path.
3. Boot and verify a FreeBSD RISC-V guest.
4. Add SSH access and a minimal guest-side LMLM execution agent.
5. Add authenticated RPC, explicit policy checks, resource reporting and security tests.

## Documentation

See [docs/Architecture.mdown](docs/Architecture.mdown) for the current architecture and detailed setup notes. Treat boot commands there as candidate configurations until verified against the actual Codespaces environment and release media.
