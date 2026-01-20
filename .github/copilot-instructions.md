# Copilot Instructions for auto_ssh

## Project Overview
- This is a Bash-based command-line tool for discovering SSH hosts in a given IP range and testing login credentials.
- Main script: `ssh_host_finder.sh` (entry point and all logic).
- Purpose: Find the current IP of a device (e.g., robot) when its IP may change due to dynamic assignment.

## Key Workflow
- **Dependencies:** Requires `nmap` and `sshpass` (see README for install commands).
- **Usage:**
  - Run: `./ssh_host_finder.sh <username> <password> [ip_range]`
  - If `[ip_range]` is omitted, the script auto-detects the local subnet or defaults to `192.168.20.0/24`.
- **Host Discovery:** Uses `nmap` to scan for hosts with port 22 open in the specified range.
- **Login Attempts:** Tries SSH login to each discovered host using `sshpass` and reports successful logins.
- **Host Key Issues:** If you see a host key warning, manual intervention is required to clear the old SSH key.

## Patterns & Conventions
- All logic is in a single Bash script; no modularization or external config.
- Uses environment variable `SSHPASS` for password passing to `sshpass`.
- SSH is invoked with `StrictHostKeyChecking=no` to avoid prompts.
- Output is printed directly to the terminal; no files are written.
- Error handling is minimal and mostly prints usage/help messages.

## Examples
- Scan a subnet: `./ssh_host_finder.sh jetson yahboom 192.168.1.0/24`
- Auto-detect subnet: `./ssh_host_finder.sh jetson yahboom`

## Integration Points
- No external APIs or services; only local shell tools (`nmap`, `sshpass`, `ssh`).
- No build, test, or CI/CD scripts present.

## How to Extend
- Add new dependencies or logic directly to `ssh_host_finder.sh`.
- For new features, follow the pattern of argument parsing and direct shell command invocation.
- Document any new usage in `README.md`.

## References
- See `README.md` for usage, prerequisites, and troubleshooting SSH key issues.
- All project logic is in `ssh_host_finder.sh`.

---
**If you add new scripts or workflows, update this file and the README with specific instructions and conventions.**
