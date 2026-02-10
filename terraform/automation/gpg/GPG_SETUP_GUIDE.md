# GPG Setup Guide: Windows Git Bash and GitHub Integration

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installation Methods](#installation-methods)
4. [Manual Setup (Step-by-Step)](#manual-setup-step-by-step)
5. [Automated Setup (Using Script)](#automated-setup-using-script)
6. [GitHub Integration](#github-integration)
7. [Verification and Testing](#verification-and-testing)
8. [Daily Usage](#daily-usage)
9. [Troubleshooting](#troubleshooting)
10. [Security Best Practices](#security-best-practices)
11. [Key Management](#key-management)

---

## Overview

### What is GPG?

GPG (GNU Privacy Guard) is an open-source implementation of the OpenPGP standard that allows you to:
- **Sign commits and tags**: Prove that code changes come from you
- **Verify signatures**: Confirm that commits are from trusted sources
- **Encrypt communications**: Secure sensitive data and messages

### Why Use GPG with Git and GitHub?

- ✅ **Authentication**: Proves that commits truly come from you
- ✅ **Integrity**: Ensures commits haven't been tampered with
- ✅ **Trust**: Displays a "Verified" badge on GitHub commits
- ✅ **Security**: Required by many organizations for compliance
- ✅ **Protection**: Prevents impersonation of contributors

### How It Works

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│  Your Computer  │         │  Git Repository  │         │     GitHub      │
├─────────────────┤         ├──────────────────┤         ├─────────────────┤
│                 │         │                  │         │                 │
│ 1. Create Key   │         │                  │         │                 │
│ 2. Sign Commit  │────────>│ 3. Store Sig     │────────>│ 4. Verify Sig   │
│ 3. Push Code    │         │                  │         │ 5. Show Badge   │
│                 │         │                  │         │                 │
└─────────────────┘         └──────────────────┘         └─────────────────┘
```

---

## Prerequisites

### System Requirements

- **Operating System**: Windows 10/11 with Git Bash
- **Architecture**: x64 (64-bit)
- **Command Line**: Git Bash (included with Git for Windows)

### Required Software

1. **Git for Windows** (includes Git Bash)
   ```bash
   # Check if installed
   git --version
   
   # Download and install from:
   # https://git-scm.com/download/win
   ```

2. **Gpg4win** (GPG for Windows)
   ```bash
   # Check if installed
   gpg --version
   
   # Download and install from:
   # https://gpg4win.org/
   ```

3. **GitHub Account**
   - Active GitHub account
   - Email address verified on GitHub

4. **GitHub CLI** (optional, for automatic key upload)
   ```bash
   # Download from: https://cli.github.com/
   # Or install via winget:
   winget install GitHub.cli
   ```

---

## Installation Methods

You can set up GPG using two methods:

| Method | Best For | Time Required |
|--------|----------|---------------|
| **Manual Setup** | Learning the process, custom configurations | 15-20 minutes |
| **Automated Script** | Quick setup, standardized configurations | 5 minutes |

---

## Manual Setup (Step-by-Step)

### Step 1: Install GPG and Dependencies

```bash
# Download and install Gpg4win from:
# https://gpg4win.org/

# Verify installation in Git Bash
gpg --version
```

**Expected Output:**
```
gpg (GnuPG) 2.4.x
libgcrypt 1.9.x
Home: C:\Users\yourname\AppData\Roaming\gnupg
```

### Step 2: Configure GPG

#### Create GPG Directory

```bash
# Create directory with proper permissions
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
```

#### Configure GPG Agent

Create `~/.gnupg/gpg-agent.conf`:

```bash
cat > ~/.gnupg/gpg-agent.conf << 'EOF'
# GPG Agent Configuration

# Use Gpg4win pinentry for passphrase prompts
pinentry-program /c/Program Files (x86)/Gpg4win/bin/pinentry.exe
# Or for newer installations:
# pinentry-program /c/Program Files/Gpg4win/bin/pinentry.exe

# Cache passphrase for 8 hours
default-cache-ttl 28800
max-cache-ttl 28800

# Enable SSH support (optional)
enable-ssh-support
EOF

chmod 600 ~/.gnupg/gpg-agent.conf
```

#### Configure GPG Preferences

Create `~/.gnupg/gpg.conf`:

```bash
cat > ~/.gnupg/gpg.conf << 'EOF'
# GPG Configuration

# Use long key IDs
keyid-format long

# Display fingerprints
with-fingerprint

# Use SHA-256 as default hash
personal-digest-preferences SHA256
cert-digest-algo SHA256
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

# Disable comment and version in output
no-comments
no-emit-version

# Trust model
trust-model tofu+pgp
EOF

chmod 600 ~/.gnupg/gpg.conf
```

#### Restart GPG Agent

```bash
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
```

### Step 3: Generate GPG Key

#### Interactive Key Generation

```bash
gpg --full-generate-key
```

**Follow the prompts:**

1. **Key Type**: Select `(1) RSA and RSA` (default)
2. **Key Size**: Enter `4096` for maximum security
3. **Expiration**: Enter `1y` (1 year) - recommended for security
4. **User ID**: 
   - Real name: `Your Full Name`
   - Email: `your.email@company.com` (must match GitHub email)
   - Comment: (leave blank or add identifier)
5. **Passphrase**: Choose a strong passphrase (store in password manager!)

**Example:**
```
Please select what kind of key you want:
   (1) RSA and RSA (default)
   Your selection? 1

What keysize do you want? (3072) 4096

Key is valid for? (0) 1y

Real name: John Doe
Email address: john.doe@company.com
Comment: 
```

#### Verify Key Creation

```bash
# List your keys
gpg --list-secret-keys --keyid-format=long

# Output will show:
# sec   rsa4096/YOUR_KEY_ID 2026-01-28 [SC] [expires: 2027-01-28]
#       FULL_FINGERPRINT
# uid                 [ultimate] Your Name <your.email@company.com>
# ssb   rsa4096/SUBKEY_ID 2026-01-28 [E] [expires: 2027-01-28]
```

**Note the KEY_ID**: It's the 16-character string after `rsa4096/` (e.g., `3AA5C34371567BD2`)

### Step 4: Configure Git

```bash
# Set your GPG key for Git (replace YOUR_KEY_ID)
git config --global user.signingkey YOUR_KEY_ID

# Enable automatic commit signing
git config --global commit.gpgsign true

# Enable automatic tag signing
git config --global tag.gpgsign true

# Set GPG program
git config --global gpg.program gpg

# Verify configuration
git config --global --list | grep -E "(signingkey|gpgsign|gpg.program)"
```

**Expected Output:**
```
user.signingkey=3AA5C34371567BD2
commit.gpgsign=true
tag.gpgsign=true
gpg.program=gpg
```

### Step 5: Configure Shell Environment

Add to your Git Bash profile (`~/.bashrc` or `~/.bash_profile`):

```bash
cat >> ~/.bashrc << 'EOF'

# =============================================================================
# GPG Configuration
# =============================================================================
export GPG_TTY=$(tty)

# Start gpg-agent if not running
if ! pgrep -x "gpg-agent" > /dev/null; then
    gpgconf --launch gpg-agent 2>/dev/null
fi
# =============================================================================
EOF
```

**Apply changes:**
```bash
source ~/.bashrc
```

### Step 6: Export Public Key

```bash
# Export public key to file
gpg --armor --export your.email@company.com > ~/gpg-public-key.txt

# Copy to clipboard (Windows)
gpg --armor --export your.email@company.com | clip.exe

# View the key
cat ~/gpg-public-key.txt
```

**Your key will look like:**
```
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBGb1...
[multiple lines of encoded data]
...
-----END PGP PUBLIC KEY BLOCK-----
```

---

## Automated Setup (Using Script)

The repository includes an automated setup script that handles all configuration steps.

### Basic Usage

#### Interactive Mode (Recommended for First-Time Setup)

```bash
cd /path/to/il-eyx-iac
./automation/gpg/setup-gpg.sh
```

The script will:
1. ✅ **Check for existing GPG keys first** (exits early if key already exists)
2. ✅ **Display existing key for GitHub** (auto-copies to clipboard)
3. ✅ Install pre-commit hook to enforce GPG signing
4. ✅ Configure local repository to require signed commits
5. ✅ Check prerequisites (Git Bash, Git, Windows)
6. ✅ Validate GPG (Gpg4win) installation
7. ✅ Create and configure `~/.gnupg/gpg.conf` and `gpg-agent.conf`
8. ✅ Prompt for your name and email (or detect from Git config)
9. ✅ Generate a 4096-bit RSA key with 1-year expiry (only if no key exists)
10. ✅ Configure Git with signing enabled
11. ✅ Add `GPG_TTY` to your shell profile
12. ✅ Export public key and copy to clipboard (via clip.exe)
13. ✅ Check GitHub CLI connectivity and upload key automatically (if available)
14. ✅ Display full GPG key values for manual GitHub configuration
15. ✅ Optionally test the setup

### Advanced Usage

#### Non-Interactive Mode

```bash
./automation/gpg/setup-gpg.sh \
  --name "John Doe" \
  --email "john.doe@company.com"
```

#### Export Existing Key Only

```bash
# Export key without generating new one
./automation/gpg/setup-gpg.sh \
  --export-only \
  --email "john.doe@company.com"
```

#### Skip Installation Validation

```bash
# Useful if GPG is already installed
./automation/gpg/setup-gpg.sh --skip-install
```

#### Skip Git Configuration

```bash
# Generate key only, don't configure Git
./automation/gpg/setup-gpg.sh --skip-git-config
```

### Script Options

| Option | Description | Example |
|--------|-------------|---------|
| `--name "Name"` | Your full name | `--name "John Doe"` |
| `--email "email"` | Your email (must match GitHub) | `--email "john@example.com"` |
| `--skip-install` | Skip GPG installation validation | |
| `--skip-git-config` | Skip Git configuration | |
| `--export-only` | Only export existing key | |
| `--delete-keys` | Delete all GPG keys (local + GitHub instructions) | |
| `--help` | Show help message | |

### What the Script Does

```
┌─────────────────────────────────────────────────────────┐
│                  GPG Setup Script                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. ✅ Existing Key Check (First Step)                  │
│     - Check for any existing GPG keys                   │
│     - If found: Display key & export for GitHub         │
│     - Copy public key to clipboard (clip.exe)           │
│     - Exit to prevent duplicate keys                    │
│                                                         │
│  2. ✅ Pre-commit Hook Installation                      │
│     - Install pre-commit hook to .git/hooks             │
│     - Configure local repo: commit.gpgsign=true         │
│     - Configure local repo: tag.gpgsign=true            │
│                                                         │
│  3. ✅ Prerequisites Check                               │
│     - Verify Windows Git Bash                           │
│     - Check Git for Windows                             │
│     - Detect pinentry path (Gpg4win)                    │
│                                                         │
│  4. ✅ Installation Validation                           │
│     - Check if GPG (Gpg4win) is installed               │
│     - Provide install instructions if missing           │
│                                                         │
│  4. ✅ GPG Configuration                                 │
│     - Create ~/.gnupg directory                         │
│     - Generate gpg.conf                                 │
│     - Generate gpg-agent.conf                           │
│     - Set proper permissions (700/600)                  │
│                                                         │
│  5. ✅ Key Generation                                    │
│     - Check for existing key (reuse if found)           │
│     - Collect user name and email                       │
│     - Generate 4096-bit RSA key pair (if needed)        │
│     - Set 1-year expiration                             │
│     - Prompt for secure passphrase                      │
│                                                         │
│  6. ✅ Git Integration                                   │
│     - Configure user.signingkey                         │
│     - Enable commit.gpgsign (global)                    │
│     - Enable tag.gpgsign (global)                       │
│                                                         │
│  7. ✅ Shell Configuration                               │
│     - Add GPG_TTY export to profile                     │
│     - Configure gpg-agent auto-start                    │
│                                                         │
│  8. ✅ Key Export                                        │
│     - Export public key to file                         │
│     - Copy to clipboard for GitHub                      │
│                                                         │
│  9. ✅ GitHub Integration                                │
│     - Check if GitHub CLI (gh) is installed             │
│     - Verify GitHub CLI authentication                  │
│     - Test GitHub connectivity                          │
│     - Check if key already exists on GitHub             │
│     - Offer to upload key automatically                 │
│     - Fall back to manual instructions if needed        │
│                                                         │
│  10. ✅ Testing (Optional)                               │
│     - Test GPG signing                                  │
│     - Test signed Git commit                            │
│                                                         │
│  11. ✅ Summary                                          │
│     - Display full GPG public key                       │
│     - Show GitHub URL for manual configuration          │
│     - Provide quick reference commands                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## GitHub Integration

### Automatic Upload (Recommended)

If you have the GitHub CLI (`gh`) installed and authenticated, the script will automatically:

1. ✅ Check if `gh` CLI is installed
2. ✅ Verify you're authenticated with GitHub
3. ✅ Test connectivity to GitHub API
4. ✅ Check if your GPG key is already on GitHub
5. ✅ Offer to upload the key automatically using `gh gpg-key add`

**Prerequisites for automatic upload:**

```bash
# Install GitHub CLI (choose one):
# Download from: https://cli.github.com/
# Or via winget:
winget install GitHub.cli

# Authenticate with GitHub
gh auth login
```

**Sample output:**
```
✓  GitHub CLI (gh) is installed
▶  Checking GitHub CLI authentication...
✓  Connected to GitHub as: your-username
▶  Checking for existing GPG keys on GitHub...
Would you like to upload the GPG key to GitHub now? [Y/n]: y
▶  Uploading GPG key to GitHub...
✓  GPG key successfully added to GitHub!
ℹ  Your commits will now show as 'Verified' on GitHub
```

### Manual Upload

If automatic upload is not available (no `gh` CLI or not authenticated), follow these steps:

#### Step 1: Navigate to GitHub GPG Keys Settings

1. Go to: **https://github.com/settings/gpg/new**
2. Or navigate: **GitHub → Settings → SSH and GPG keys → New GPG key**

#### Step 2: Add New GPG Key

1. Click **"New GPG key"** button
2. Enter a descriptive title (e.g., "MacBook Pro 2026")
3. Paste your public key (already in clipboard, or displayed at end of script)
4. Click **"Add GPG key"**
5. Confirm with your GitHub password if prompted

**Note:** The script always displays your full GPG public key at the end for manual configuration:

### Step 3: Verify Email Match

⚠️ **CRITICAL**: Your GPG key email **MUST** match one of your GitHub verified emails.

**Check your GitHub emails:**
1. Go to: **https://github.com/settings/emails**
2. Ensure the email used in your GPG key is listed and verified
3. If not verified, click "Resend verification email"

### Step 4: Verify Integration

After adding your key to GitHub:

1. Make a signed commit:
   ```bash
   git commit -m "test: verify GPG signing"
   ```

2. Push to GitHub:
   ```bash
   git push
   ```

3. View on GitHub - you should see:
   - ✅ **"Verified"** badge next to your commit
   - Green checkmark icon
   - Tooltip: "This commit was signed with a verified signature"

### Troubleshooting GitHub Verification

If commits don't show "Verified":

1. **Email Mismatch**
   ```bash
   # Check your GPG key email
   gpg --list-keys
   
   # Check your Git email
   git config user.email
   
   # They must match!
   ```

2. **Key Not on GitHub**
   - Verify key is added at https://github.com/settings/keys
   - Try removing and re-adding the key

3. **Expired Key**
   ```bash
   # Check expiration
   gpg --list-keys
   
   # Extend expiration if needed
   gpg --edit-key YOUR_KEY_ID
   > expire
   > save
   ```

---

## Verification and Testing

### Test GPG Signing

```bash
# Test GPG can sign data
echo "test" | gpg --clearsign

# You should see:
# -----BEGIN PGP SIGNED MESSAGE-----
# ...
# -----END PGP SIGNATURE-----
```

### Test Git Signing

```bash
# Create test repository
mkdir ~/gpg-test && cd ~/gpg-test
git init

# Create and commit a file
echo "Test GPG signing" > test.txt
git add test.txt
git commit -m "test: verify GPG signing works"

# Verify the signature
git log --show-signature -1
```

**Expected Output:**
```
gpg: Signature made Wed Jan 28 10:30:00 2026 PST
gpg:                using RSA key YOUR_KEY_ID
gpg: Good signature from "Your Name <your.email@company.com>"
```

### Test Configuration

```bash
# Check Git configuration
git config --global --list | grep -E "(signingkey|gpgsign|gpg)"

# Check GPG keys
gpg --list-secret-keys --keyid-format=long

# Check GPG agent
gpg-agent --version

# Check environment
echo $GPG_TTY
```

---

## Daily Usage

### Signing Commits (Automatic)

With `commit.gpgsign=true`, all commits are automatically signed:

```bash
git commit -m "feat: add new feature"
# Signature is added automatically
```

### Signing Commits (Manual)

If automatic signing is disabled:

```bash
git commit -S -m "feat: add new feature"
```

### Signing Tags

```bash
# Create signed tag
git tag -s v1.0.0 -m "Release version 1.0.0"

# Verify tag signature
git tag -v v1.0.0
```

### Viewing Signatures

```bash
# Show signature on last commit
git log --show-signature -1

# Show signatures on all commits
git log --show-signature

# Show signature with pretty format
git log --pretty="format:%h %G? %aN %s"
```

**Signature Status Codes:**
- `G` = Good signature (valid and trusted)
- `B` = Bad signature (invalid)
- `U` = Good signature but untrusted
- `X` = Good signature but expired
- `Y` = Good signature but key expired
- `R` = Good signature but key revoked
- `E` = Cannot check signature
- `N` = No signature

### Passphrase Entry

When signing:
1. **macOS dialog** will appear (via pinentry-mac)
2. Enter your GPG passphrase
3. Passphrase is cached for 8 hours (default)

---

## Troubleshooting

### Common Issues

#### Issue 1: "gpg: signing failed: No secret key"

**Cause**: Git is configured with wrong key ID or key doesn't exist.

**Solution:**
```bash
# List your keys
gpg --list-secret-keys --keyid-format=long

# Copy the correct KEY_ID and reconfigure
git config --global user.signingkey YOUR_KEY_ID
```

#### Issue 2: "error: gpg failed to sign the data"

**Cause**: GPG agent not running or can't prompt for passphrase.

**Solution:**
```bash
# Ensure GPG_TTY is set
export GPG_TTY=$(tty)

# Restart GPG agent
gpgconf --kill gpg-agent
gpg-agent --daemon

# Test signing
echo "test" | gpg --clearsign
```

#### Issue 3: Passphrase prompt doesn't appear

**Cause**: pinentry-mac not properly configured.

**Solution:**
```bash
# Check pinentry path
which pinentry-mac

# Update gpg-agent.conf with correct path
# For Apple Silicon:
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf

# For Intel:
echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf

# Restart agent
gpgconf --kill gpg-agent
```

#### Issue 4: "Verified" badge not showing on GitHub

**Causes and Solutions:**

1. **Email mismatch**:
   ```bash
   # Check GPG key email
   gpg --list-keys | grep uid
   
   # Check Git email
   git config user.email
   
   # Must match exactly!
   ```

2. **Key not added to GitHub**:
   - Go to https://github.com/settings/keys
   - Add your public key

3. **Email not verified on GitHub**:
   - Go to https://github.com/settings/emails
   - Verify your email address

4. **Wrong key used**:
   ```bash
   # Ensure correct key is configured
   git config user.signingkey
   ```

#### Issue 5: "gpg: WARNING: unsafe permissions"

**Solution:**
```bash
# Fix permissions on GPG directory
chmod 700 ~/.gnupg
chmod 600 ~/.gnupg/*
```

#### Issue 6: Key expired

**Solution:**
```bash
# Edit key
gpg --edit-key YOUR_KEY_ID

# At gpg> prompt:
expire
# Follow prompts to extend expiration

save

# Update on GitHub
gpg --armor --export YOUR_EMAIL | pbcopy
# Re-add to GitHub
```

### Debug Mode

Enable verbose output:

```bash
# Debug Git signing
GIT_TRACE=1 git commit -m "test"

# Debug GPG
gpg --debug-level expert --clearsign
```

### Reset GPG Configuration

If everything fails, reset and start over:

```bash
# ⚠️ WARNING: This deletes all GPG keys and configuration

# Backup first (optional)
tar -czf ~/gnupg-backup-$(date +%Y%m%d).tar.gz ~/.gnupg

# Remove configuration
rm -rf ~/.gnupg

# Re-run setup
./automations/setup-gpg-mac.sh
```

---

## Security Best Practices

### 1. Passphrase Management

✅ **DO:**
- Use a strong, unique passphrase (16+ characters)
- Store in a password manager (1Password, Bitwarden, etc.)
- Use a mix of uppercase, lowercase, numbers, and symbols
- Never share your passphrase

❌ **DON'T:**
- Use a weak or common passphrase
- Store passphrase in plain text
- Use the same passphrase for multiple keys
- Store passphrase in Git repository

### 2. Key Expiration

✅ **Recommended:**
- Set 1-year expiration (forces periodic review)
- Renew keys annually
- Update GitHub when extended

**Extend expiration:**
```bash
gpg --edit-key YOUR_KEY_ID
> expire
> 1y
> save

# Re-export to GitHub
gpg --armor --export YOUR_EMAIL | pbcopy
```

### 3. Key Backup

**Backup your private key** (store securely!):

```bash
# Export private key (encrypted with passphrase)
gpg --export-secret-keys --armor YOUR_KEY_ID > ~/gpg-private-key-backup.asc

# Store in secure location:
# - Encrypted USB drive
# - Password manager's secure notes
# - Encrypted cloud storage (after additional encryption)
```

**⚠️ WARNING:** Anyone with your private key and passphrase can sign as you!

**Restore from backup:**
```bash
gpg --import ~/gpg-private-key-backup.asc
```

### 4. Key Revocation Certificate

Generate a revocation certificate (in case key is compromised):

```bash
# Generate revocation certificate
gpg --output ~/gpg-revoke-cert.asc --gen-revoke YOUR_KEY_ID

# Store securely (same as private key backup)
```

**If key is compromised:**
```bash
# Import revocation certificate
gpg --import ~/gpg-revoke-cert.asc

# Upload revoked key to GitHub to disable verification
gpg --armor --export YOUR_KEY_ID | pbcopy
# Replace key on GitHub
```

### 5. Multiple Devices

**Option 1: Same key on multiple devices** (easier, less secure)
```bash
# On original device, export private key
gpg --export-secret-keys --armor YOUR_KEY_ID > private-key.asc

# On new device, import
gpg --import private-key.asc

# Securely delete private-key.asc after import
```

**Option 2: Separate key per device** (more secure, recommended)
- Generate unique key for each device
- Add all keys to GitHub
- Each key signed by primary key (web of trust)

### 6. Regular Maintenance

**Monthly:**
- Verify key hasn't expired
- Check GitHub "Verified" badges on recent commits

**Annually:**
- Extend key expiration
- Update key on GitHub
- Review and revoke old/unused keys
- Update backups

**When changing jobs/computers:**
- Revoke keys you no longer use
- Remove from GitHub if device is decommissioned

---

## Key Management

### List Keys

```bash
# List public keys
gpg --list-keys --keyid-format=long

# List private keys
gpg --list-secret-keys --keyid-format=long

# List with fingerprints
gpg --fingerprint
```

### Delete Keys

```bash
# Delete private key first
gpg --delete-secret-key YOUR_KEY_ID

# Then delete public key
gpg --delete-key YOUR_KEY_ID
```

### Export Keys

```bash
# Export public key (safe to share)
gpg --armor --export YOUR_EMAIL > public-key.asc

# Export private key (keep secure!)
gpg --armor --export-secret-keys YOUR_KEY_ID > private-key.asc

# Export all keys
gpg --armor --export-secret-keys > all-private-keys.asc
```

### Import Keys

```bash
# Import from file
gpg --import public-key.asc

# Import from clipboard
pbpaste | gpg --import
```

### Edit Key

```bash
gpg --edit-key YOUR_KEY_ID

# Common commands:
# expire   - Change expiration date
# adduid   - Add email address
# deluid   - Remove email address
# addkey   - Add subkey
# passwd   - Change passphrase
# trust    - Set trust level
# save     - Save and quit
```

### Trust Keys

```bash
gpg --edit-key YOUR_KEY_ID
> trust
> 5 (ultimate trust)
> save
```

### Delete All Keys (Complete Cleanup)

If you need to completely remove all GPG keys from your system:

**Using the Automated Script:**

```bash
# Delete all GPG keys (local + GitHub instructions)
./automation/gpg/setup-gpg.sh --delete-keys
```

The script will:
- List all your GPG keys
- Ask for confirmation (twice for safety)
- Delete all secret and public keys
- Remove Git GPG configuration
- Provide GitHub cleanup instructions
- Optionally open GitHub settings in browser

**Manual Deletion:**

```bash
# Delete specific key
gpg --delete-secret-key YOUR_KEY_ID  # Delete private key first
gpg --delete-key YOUR_KEY_ID          # Then delete public key

# Remove Git config
git config --global --unset user.signingkey
git config --global --unset commit.gpgsign
git config --global --unset tag.gpgsign

# Remove from GitHub
# Go to: https://github.com/settings/keys
# Click [Delete] next to each GPG key
```

⚠️ **Important Notes:**
- This is **permanent and irreversible**
- Back up your private key first if you might need it later
- Old commits will still show "Verified" on GitHub
- You must manually remove keys from GitHub

📖 **See `docs/GPG_DELETE_KEYS.md` for detailed deletion guide**

---

## Additional Resources

### Documentation

- **GnuPG Official**: https://gnupg.org/documentation/
- **GitHub GPG Docs**: https://docs.github.com/en/authentication/managing-commit-signature-verification
- **Git Signing Guide**: https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work

### Commands Reference

```bash
# Quick reference card
gpg --help

# Man pages
man gpg
man gpg-agent

# Configuration examples
/opt/homebrew/share/doc/gnupg/examples/
```

### Related Documentation in This Repository

- `docs/GPG_MAC_SETUP.md` - Detailed macOS setup guide
- `docs/GPG_GITHUB_SETUP.md` - GitHub integration specifics
- `docs/GPG_ENFORCE_SIGNED_COMMITS.md` - Enforce signing in repositories
- `docs/GPG_DELETE_KEYS.md` - Complete key deletion guide
- `automations/setup-gpg-mac.sh` - Automated setup script

---

## Quick Reference

### Essential Commands

```bash
# Generate new key
gpg --full-generate-key

# List your keys
gpg --list-secret-keys --keyid-format=long

# Export public key for GitHub
gpg --armor --export YOUR_EMAIL | clip.exe

# Configure Git signing
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true

# Verify commit signature
git log --show-signature -1

# Restart GPG agent
gpgconf --kill gpg-agent && gpgconf --launch gpg-agent

# Set GPG_TTY
export GPG_TTY=$(tty)
```

### Checklist

- [ ] Git for Windows installed (includes Git Bash)
- [ ] Gpg4win installed
- [ ] GitHub CLI installed and authenticated (`gh auth login`) [optional]
- [ ] GPG and pinentry configured
- [ ] `~/.gnupg/gpg.conf` configured
- [ ] `~/.gnupg/gpg-agent.conf` configured
- [ ] Pre-commit hook installed to `.git/hooks/`
- [ ] Local repository configured for signed commits
- [ ] GPG key generated (4096-bit RSA, 1y expiry) or existing key reused
- [ ] Git configured with signing key
- [ ] `GPG_TTY` exported in shell profile
- [ ] Public key added to GitHub (automatic or manual)
- [ ] Email verified on GitHub
- [ ] Test commit shows "Verified" badge
- [ ] Private key backed up securely
- [ ] Revocation certificate generated
- [ ] Passphrase stored in password manager

---

## Summary

You now have:

1. ✅ GPG installed and configured on your Windows machine (via Git Bash)
2. ✅ A secure 4096-bit RSA key pair
3. ✅ Git configured to automatically sign commits
4. ✅ Public key uploaded to GitHub
5. ✅ "Verified" badges on your commits
6. ✅ Understanding of daily usage and troubleshooting

**Next Steps:**

1. Make your first signed commit
2. Verify the "Verified" badge on GitHub
3. Set up on other development machines if needed
4. Back up your private key securely
5. Consider enforcing signed commits on critical repositories

**Remember:**
- 🔐 Keep your passphrase secure
- 💾 Back up your private key
- 📅 Renew your key before it expires
- 🚨 Revoke immediately if compromised

---

## Pre-commit Hook

The script automatically installs a pre-commit hook that enforces GPG signing on all commits.

### What It Does

1. **Installs hook** to `.git/hooks/pre-commit`
2. **Configures local repository** with `commit.gpgsign=true` and `tag.gpgsign=true`
3. **Blocks unsigned commits** with a helpful error message

### Hook Behavior

If someone tries to commit without GPG signing enabled:

```
ERROR: GPG signing is required for all commits in this repository.
Please enable GPG signing by running:
  git config --global commit.gpgsign true
Or for this repository only:
  git config commit.gpgsign true

If you don't have a GPG key set up, you can create one with:
  gpg --gen-key
Then configure it with:
  git config --global user.signingkey <your-key-id>
```

### Hook Location

The pre-commit hook source is at:
- `automations/gpg/pre-commit`

It gets installed to:
- `.git/hooks/pre-commit` (in the current repository)

---

## Duplicate Key Prevention

The script prevents accidentally creating duplicate GPG keys:

### Default Behavior (Early Detection)

The script checks for existing keys **immediately** before any setup steps. If any GPG key exists, the script will:

1. ✅ **Detect the existing key** (before any user interaction)
2. ✅ **Display key information** with email and fingerprint
3. ✅ **Export public key for GitHub** (ready to use)
4. ✅ **Copy to clipboard** (via clip.exe)
5. ✅ **Show GitHub instructions** with direct URL
6. ✅ **Exit cleanly** (no new key generated)

```
✓  A GPG key already exists on this machine!
⚠  You already have a GPG key configured. Creating another key is not recommended.

▶ Your existing GPG key(s):
sec   rsa4096/ABC123DEF456 2026-01-28 [SC] [expires: 2027-01-28]
      ...
uid   [ultimate] Your Name <your.email@company.com>

═══════════════════════════════════════════════════════════════
  GPG Public Key for GitHub
═══════════════════════════════════════════════════════════════

To add this key to GitHub:
  1. Copy the public key below
  2. Go to: https://github.com/settings/gpg/new
  3. Paste the key (Ctrl+V)
  4. Click 'Add GPG key'

✓  Public key copied to clipboard!

─────────────────────────────────────────────────────────────────
Copy everything below (including BEGIN/END lines):
─────────────────────────────────────────────────────────────────

-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----

ℹ  Setup cancelled - no changes were made
ℹ  To delete existing keys and start fresh, use: ./setup-gpg.sh --delete-keys
```

### No Force-New Option

The `--force-new` option has been removed to prevent duplicate keys. To generate a new key:

1. First delete existing keys: `./automation/gpg/setup-gpg.sh --delete-keys`
2. Then run the setup again: `./automation/gpg/setup-gpg.sh`

---

*Last Updated: February 2026*  
*Script Version: setup-gpg.sh for Windows Git Bash (1161 lines)*  
*Platform: Windows 10/11 with Git Bash*
