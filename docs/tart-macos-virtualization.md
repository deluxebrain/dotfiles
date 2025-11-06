# Using Tart for macOS Virtualization

This guide documents practical notes and lessons learned when migrating from
**Parallels** to **[Tart](https://github.com/cirruslabs/tart)** for macOS
virtualization — specifically for testing a **chezmoi dotfiles** project.

---

## Overview

Tart provides macOS virtual machines using Apple's native Virtualization
framework. Unlike Parallels, Tart is modeled around **VMs** rather than
standalone images. You **clone** existing VM templates (from a registry or local
cache) rather than downloading image files directly.

---

## Installation

```bash
brew install cirruslabs/cli/tart
```

---

## Image Types

Tart offers several macOS VM templates via GitHub Container Registry (GHCR):

| Image Type  | Description                                                          | Includes                                                                       |
| ----------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **Vanilla** | A clean macOS install with basic convenience tweaks.                 | Auto-login admin user (`admin/admin`), SSH enabled, no pre-installed software. |
| **Base**    | Built on the vanilla image with useful developer tools preinstalled. | Homebrew and CLI utilities, but no Xcode. Ideal for most automation tests.     |
| **Xcode**   | Adds development tools for full Apple app builds.                    | Xcode, Flutter, and dependencies.                                              |

For dotfiles or bootstrap testing:

- Use **Base** for quick runs.
- Use **Vanilla** for full end-to-end system bootstrap tests.

**Note:** The “Tahoe” naming convention (e.g., `macos-tahoe-base`) refers to the
latest stable macOS release images published by CirrusLabs. For example,
`macos-sonoma-base` and `macos-tahoe-base` are equivalent depending on the
release cycle.

---

## Quick Start

This is a minimal script to clone, run, test, and clean up a Tart VM for
dotfiles validation.

```bash
#!/usr/bin/env bash
set -euo pipefail

# --- Configuration ---
REPO_URL="https://github.com/yourusername/your-dotfiles"
BASE_IMAGE="ghcr.io/cirruslabs/macos-tahoe-base:latest"
BASE_VM="tahoe-base"
TEST_VM="test-vm-$$"
NET_INTERFACE="en0"   # Use 'networksetup -listallhardwareports' to confirm

# --- Ensure base VM exists ---
if ! tart list | grep -q "$BASE_VM"; then
  echo "Cloning base VM..."
  tart clone "$BASE_IMAGE" "$BASE_VM"
fi

# --- Create test VM clone ---
echo "Creating test VM..."
tart clone "$BASE_VM" "$TEST_VM"

# --- Run VM headless with bridged networking ---
echo "Starting test VM..."
tart run --no-graphics --net-bridged="$NET_INTERFACE" "$TEST_VM" &

# --- Wait for boot ---
echo "Waiting for VM to boot..."
sleep 20

# --- Run chezmoi bootstrap ---
VM_IP=$(tart ip --resolver=arp "$TEST_VM")
echo "VM IP: $VM_IP"

ssh -o StrictHostKeyChecking=no admin@"$VM_IP" "chezmoi init --apply $REPO_URL"

# --- Cleanup ---
echo "Cleaning up..."
tart stop "$TEST_VM"
tart delete "$TEST_VM"

echo "✅ Test complete."
```

**Notes:**

- Default SSH credentials: `admin/admin`
- Adjust `NET_INTERFACE` if your network adapter differs (use
  `networksetup -listallhardwareports`).
- Use `tart run --vnc` instead of `--no-graphics` if you need visual access.

---

## Core Concepts

### VMs vs. Images

- Tart operates on **VMs**, not abstract "images."
- When cloning from a remote registry (like
  `ghcr.io/cirruslabs/macos-tahoe-base`):
  1. The image is first downloaded and cached in `~/.tart/vms/cache/OCIs/`.
  2. A runnable VM is created in `~/.tart/vms/`.

### Cloning Model

- You typically **clone once from the registry** to create a local **base VM**.
- You then **clone again from your local base** for each test run.

```bash
# 1. Clone base image once
tart clone ghcr.io/cirruslabs/macos-tahoe-base:latest tahoe-base

# 2. Keep the base pristine
# 3. Clone for each test
tart clone tahoe-base test-run-001
tart run test-run-001
```

---

## APFS Copy-on-Write Storage

### How It Works

Tart leverages **APFS copy-on-write (COW)** for efficient cloning:

- When you clone a VM, **no data is initially duplicated** — only metadata is
  copied.
- Both VMs share the same underlying disk blocks.
- As each VM runs and diverges, **only changed blocks** consume additional
  space.
- This is block-level deduplication, not file-level.

### Important: `du` Misreports Disk Usage

**⚠️ Standard tools like `du` and Finder report logical sizes, not actual disk
usage.**

```bash
# This will INCORRECTLY show full size for each clone
du -h ~/.tart/vms/

# Check ACTUAL disk usage instead:
df -h ~/.tart
# Or, for APFS-aware true usage:
tmutil calculatedsize ~/.tart/vms
```

### Divergence Over Time (`du` vs. actual disk use)

Once you boot a VM, it immediately starts diverging:

- System logs grow
- Cache files update
- User data accumulates
- Each clone stores **only its unique changed blocks**

**Example:**

```
Base VM: 32GB apparent size
Clone 1 (booted, used 1 hour): +2GB actual changes
Clone 2 (booted, used 1 hour): +2GB actual changes
Clone 3 (never booted): +~0GB actual

Total ACTUAL disk usage: ~36GB (not 96GB)
```

### Practical Implications

✅ **Clone liberally** — initial clones are nearly free ✅ **Delete when done**
— reclaims all diverged blocks ⚠️ **Long-running VMs eventually use full space**
as they diverge ⚠️ **Monitor with `df` or `tmutil calculatedsize`** to see real
usage

---

## Workflow Guidelines

### Pattern 1: Ephemeral Test VMs (Recommended)

Best for CI/CD, testing, experimentation:

```bash
# Maintain one pristine base per macOS version
tart clone ghcr.io/cirruslabs/macos-tahoe-base:latest tahoe-base

# Clone → Test → Delete cycle
for test in feature-1 feature-2 feature-3; do
  tart clone tahoe-base "test-$test"
  tart run "test-$test"
  # ... run tests ...
  tart delete "test-$test"  # Space reclaimed!
done
```

**Benefits:**

- Minimal disk usage (clones share blocks)
- Fast clone operations (~instant)
- Clean slate for each test
- Easy cleanup

### Pattern 2: Persistent Development VMs

For long-running development environments:

```bash
# Create dedicated development VMs
tart clone tahoe-base dev-primary
tart set dev-primary --cpu 4 --memory 8192 --disk-size 80

# Use for extended periods
tart run dev-primary
```

**Trade-offs:**

- VMs will diverge significantly over time
- Eventually approach full disk usage each
- Keep only 2-3 active on limited storage

### Pattern 3: Multiple Base Images

For testing across macOS versions:

```bash
# Maintain bases for each version
tart clone ghcr.io/cirruslabs/macos-sonoma-base:latest sonoma-base
tart clone ghcr.io/cirruslabs/macos-ventura-base:latest ventura-base
tart clone ghcr.io/cirruslabs/macos-sequoia-base:latest sequoia-base

# Clone from appropriate base for each test
tart clone sonoma-base test-sonoma
tart clone ventura-base test-ventura
```

### Storage Management Tips

```bash
# Check REAL disk usage
df -h ~/.tart

# List all VMs
tart list

# Clean up test VMs (example pattern)
tart list | grep "test-" | awk '{print $2}' | xargs -n1 tart delete

# Monitor during usage
watch -n 5 'df -h / | grep disk'
```

---

## Networking

### Default (NAT)

By default, Tart uses **shared NAT networking** — allowing your VM to access the
internet via the host.

**Issue:** In some environments, NAT networking fails (VM can be reached via
`tart ip`, but has no outbound connectivity). This may be due to **firewall or
anti-malware software** intercepting virtual network traffic.

### Bridged Networking (Workaround)

To avoid NAT issues, use bridged networking:

```bash
tart run --net-bridged=en0 my-vm
```

**Finding your network interface:**

```bash
# List all network hardware
networksetup -listallhardwareports

# Check active interfaces
ifconfig | grep "status: active" -B 5

# Common interfaces: en0 (Wi-Fi), en1-en7 (Ethernet/Thunderbolt)
```

#### Getting the VM IP under bridged mode

When using bridged networking, you must use a different resolver:

```bash
tart ip --resolver=arp my-vm
```

---

## Display & UI Modes

### Windowed Mode Issue

On some systems, running Tart's default windowed display results in **no visible
window**.

**Workarounds:**

1. Ensure you're not inside a `tmux` or `screen` session (`echo $TERM`,
   `echo $TMUX`).
2. Run from a normal macOS Terminal window.

### VNC Mode

If the window still doesn't appear:

```bash
tart run --vnc my-vm
```

This opens a VNC server, allowing you to connect with any VNC viewer.

**Note:**

- Use the **standard display mode**, not "high performance."
- VM stability under VNC mode may vary; crashes are still under investigation.

---

## Managing VM Resources

Adjust VM resources before running (must be done while VM is stopped):

```bash
# CPU cores
tart set my-vm --cpu 4

# Memory (MB)
tart set my-vm --memory 8192

# Disk size (GB)
tart set my-vm --disk-size 100
```

Check current VM configuration:

```bash
tart get my-vm
```

**Default resources:** 2 CPUs, 4GB RAM, 1024×768 display

---

## Logs & Diagnostics

Capture Tart and Virtualization.framework logs for troubleshooting:

```bash
log stream --predicate='process=="tart" OR process CONTAINS "Virtualization"' > tart.log
```

Run this in a separate terminal while reproducing the issue, then press Ctrl+C
to stop logging.

---

## Storage Layout

| Path                      | Description                           |
| ------------------------- | ------------------------------------- |
| `~/.tart/vms/`            | All local Tart VMs (runnable clones). |
| `~/.tart/vms/cache/OCIs/` | Cached remote registry images.        |

**Default location:** Tart stores all VMs under `~/.tart/vms`. Each VM is a
directory containing a `disk.img` sparse image and metadata.

List all VMs:

```bash
tart list
```

Example output:

```
Source  Name             Size
local   tahoe-base       167
local   test-vm-001      167
local   tahoe-vanilla    150
```

**Note:** Size shown is apparent size, not actual disk usage due to APFS COW.

---

## Cleanup & Maintenance

```bash
# Stop a running VM
tart stop <vm-name>

# Delete a VM
tart delete <vm-name>

# Prune unused OCI cache (careful - will remove cached images)
tart prune

# Fully reclaim all cached images and base VMs
tart prune --all
```

**Tip:** Use consistent naming patterns (e.g., `tahoe-base`, `test-*`) to easily
identify and batch-remove temporary VMs.

---

## Summary of Key Learnings

| Topic                | Observation                                             | Resolution / Best Practice                                                    |
| -------------------- | ------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **APFS COW**         | Clones share disk blocks; `du` misreports usage.        | Monitor with `df` or `tmutil calculatedsize`. Clone freely for ephemeral VMs. |
| **Storage**          | Running VMs diverge and eventually use full space.      | Use clone → test → delete workflow for efficiency.                            |
| **Networking (NAT)** | VM has no outbound network access in some environments. | Use `--net-bridged=<interface>`.                                              |
| **Bridged IP**       | `tart ip` fails under bridged networking.               | Use `tart ip --resolver=arp`.                                                 |
| **Missing window**   | GUI window not appearing.                               | Avoid `tmux`, or use `--vnc`.                                                 |
| **VNC crashes**      | VM occasionally crashes in VNC mode.                    | Check logs, adjust resources, or use windowed mode.                           |
| **Resources**        | VMs can freeze/crash with insufficient resources.       | Allocate adequate CPU/memory with `tart set`.                                 |
| **Image types**      | Vanilla, base, and xcode serve different purposes.      | Use `base` for routine tests, `vanilla` for full setups.                      |

---

## References

- [Tart GitHub Repository](https://github.com/cirruslabs/tart)
- [Tart Documentation](https://tart.run)
- [Tart macOS VM Images](https://github.com/cirruslabs/macos-image-templates)
- [Apple Virtualization Framework Docs](https://developer.apple.com/documentation/virtualization)
