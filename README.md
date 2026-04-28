# ⚡ PowerShell IT Toolkit

A collection of 5 lightweight PowerShell scripts for everyday IT tasks — system auditing, disk cleanup, network scanning, and more. Each script is 25 lines of code or less.

---

## 📋 Table of Contents

- [Requirements](#requirements)
- [Setup](#setup)
- [Scripts](#scripts)
  - [1. System Info Snapshot](#1-system-info-snapshot)
  - [2. Find Large Files](#2-find-large-files)
  - [3. Ping Sweep Subnet](#3-ping-sweep-subnet)
  - [4. List Local Admin Accounts](#4-list-local-admin-accounts)
  - [5. Clear Temp Files](#5-clear-temp-files)
- [Q&A](#qa)

---

## Requirements

- Windows 10 / Windows 11 (or Windows Server 2016+)
- PowerShell 5.1 or later
- Administrator privileges (required for scripts 4 and 5)

---

## Setup

### 1. Download the scripts
Clone the repo or download the `.ps1` files directly:

```bash
git clone https://github.com/your-username/powershell-it-toolkit.git
```

### 2. Set the Execution Policy
By default, Windows blocks PowerShell scripts from running. Open PowerShell **as Administrator** and run:

```powershell
Set-ExecutionPolicy RemoteSigned
```

> ⚠️ This only needs to be done once per machine.

### 3. Running a Script
**Option A — Right-click method:**
Right-click the `.ps1` file → **Run with PowerShell**

**Option B — From a PowerShell terminal:**
```powershell
cd C:\path\to\scripts
.\ScriptName.ps1
```

> 💡 If the window closes immediately after running, open PowerShell manually first and run the script from the terminal instead.

---

## Scripts

### 1. System Info Snapshot
**File:** `SystemInfo.ps1`

Pulls key details about the local machine including hostname, OS, last boot time, CPU, RAM, and current user.

```powershell
.\SystemInfo.ps1
```

**Example Output:**
```
Hostname    : DESKTOP-ABC123
OS          : Microsoft Windows 11 Pro
LastBoot    : 4/27/2026 8:14:03 AM
CPU         : Intel(R) Core(TM) i7-10700 CPU @ 2.90GHz
RAM_GB      : 15.88
CurrentUser : Aaron
```

---

### 2. Find Large Files
**File:** `FindLargeFiles.ps1`

Scans a directory recursively and lists the top 10 largest files. Useful for tracking down what's eating up disk space.

```powershell
# Scan default path (C:\)
.\FindLargeFiles.ps1

# Scan a specific path
.\FindLargeFiles.ps1 -Path "D:\Projects" -Top 20
```

| Parameter | Default | Description |
|-----------|---------|-------------|
| `-Path`   | `C:\`   | Directory to scan |
| `-Top`    | `10`    | Number of results to return |

---

### 3. Ping Sweep Subnet
**File:** `PingSweep.ps1`

Scans all 254 host addresses on a /24 subnet and reports which ones are online. Great for quickly mapping active devices on a network.

```powershell
# Sweep default subnet (192.168.1.x)
.\PingSweep.ps1

# Sweep a specific subnet
.\PingSweep.ps1 -Subnet "10.0.0"
```

| Parameter  | Default       | Description              |
|------------|---------------|--------------------------|
| `-Subnet`  | `192.168.1`   | First three octets of the target subnet |

> ⏱️ This script may take 1–3 minutes to complete depending on network size.

> ⚠️ **PowerShell 5.1 Users:** The `-TimeoutSeconds` parameter is not supported in PowerShell 5.1 and will throw an error. Remove `-TimeoutSeconds 1` from the `Test-Connection` line to fix it. Note that without it, each failed ping will wait the full default timeout (~4 seconds), making the sweep significantly slower. To use `-TimeoutSeconds`, upgrade to [PowerShell 7](https://github.com/PowerShell/PowerShell/releases).

---

### 4. List Local Admin Accounts
**File:** `ListAdmins.ps1`

Audits the local Administrators group and lists every account with admin privileges, including whether they are local or domain accounts.

```powershell
.\ListAdmins.ps1
```

**Example Output:**
```
Name                    ObjectClass PrincipalSource
----                    ----------- ---------------
DESKTOP-ABC123\Aaron    User        Local
DESKTOP-ABC123\Administrator User  Local
```

> 🔒 Requires Administrator privileges to run.

---

### 5. Clear Temp Files
**File:** `ClearTemp.ps1`

Cleans temporary files from `%TEMP%`, `C:\Windows\Temp`, and `C:\Windows\Prefetch`, then reports how much space was freed.

```powershell
.\ClearTemp.ps1
```

**Example Output:**
```
Cleaned approx 1.34 MB of temp files.
```

> 🔒 Requires Administrator privileges to run.
> ⚠️ Test in a safe environment before running on production machines.

---

## Q&A

**Q: Why does double-clicking a `.ps1` file open Notepad instead of running it?**
> Windows intentionally sets the default action for `.ps1` files to open in a text editor as a security measure. To run a script, right-click it and select **Run with PowerShell**, or run it from within a PowerShell terminal.

**Q: I get an error saying "running scripts is disabled on this system." What do I do?**
> You need to update your execution policy. Open PowerShell as Administrator and run:
> ```powershell
> Set-ExecutionPolicy RemoteSigned
> ```

**Q: The script window opens and immediately closes. How do I fix that?**
> This happens when running scripts by right-clicking. Either open PowerShell manually and run the script from the terminal, or add `Read-Host "Press Enter to exit"` to the bottom of the script to keep the window open.

**Q: Do I need admin rights to run all of these scripts?**
> Not all of them. Scripts 1, 2, and 3 (System Info, Find Large Files, Ping Sweep) can run as a standard user. Scripts 4 and 5 (List Admins, Clear Temp Files) require Administrator privileges.

**Q: The Ping Sweep is taking forever. Is that normal?**
> Yes, scanning all 254 addresses sequentially can take a few minutes. If you need speed, you can reduce the range by editing `1..254` in the script to a smaller range like `1..50`.

**Q: I get "A parameter cannot be found that matches parameter name 'TimeoutSeconds'" on the Ping Sweep. How do I fix it?**
> This means you're running PowerShell 5.1, where `-TimeoutSeconds` does not exist — it was added in PowerShell 6+. Remove `-TimeoutSeconds 1` from the `Test-Connection` line:
> ```powershell
> if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
> ```
> The sweep will still work but will run slower since each failed ping waits the full default timeout. To restore full speed, upgrade to [PowerShell 7](https://github.com/PowerShell/PowerShell/releases). You can check your current version by running `$PSVersionTable.PSVersion`.

**Q: Will the Clear Temp Files script delete anything important?**
> It only targets known safe temp locations (`%TEMP%`, `C:\Windows\Temp`, `C:\Windows\Prefetch`). However, always test scripts in a non-production environment first before running them widely.

**Q: Can I run these scripts on a remote machine?**
> Yes, most of these can be adapted for remote use with PowerShell remoting. For example:
> ```powershell
> Invoke-Command -ComputerName REMOTE-PC -FilePath .\SystemInfo.ps1
> ```
> Remote access must be enabled on the target machine via `Enable-PSRemoting`.

**Q: What version of PowerShell do I need?**
> PowerShell 5.1 or later is recommended. All scripts use cmdlets available in 5.1+. You can check your version by running `$PSVersionTable.PSVersion` in a terminal.

---

## License

MIT License — free to use, modify, and distribute.

---

> 💬 Found a bug or have a suggestion? Open an issue or submit a pull request!
