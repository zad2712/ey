#!/bin/bash
# =============================================================================
# GPG Setup Script for Windows (Git Bash)
# =============================================================================
# This script automates the GPG installation and configuration on Windows
# using Git Bash, following the instructions in automation/gpg/GPG_SETUP_GUIDE.md
#
# Usage: ./setup-gpg.sh [options]
#
# Options:
#   --name "Your Name"     Your full name for the GPG key
#   --email "email@ex.com" Your email address (must match GitHub email)
#   --skip-install         Skip GPG installation validation
#   --skip-git-config      Skip Git configuration
#   --export-only          Only export existing key (skip generation)
#   --force-new            Force generation of new key even if one exists
#   --delete-keys          Delete all GPG keys (local and GitHub instructions)
#   --help                 Show this help message
#
# =============================================================================

# What the Script Does
# ✅ Installs pre-commit hook to enforce GPG signing (first step)
# ✅ Configures local repository to require signed commits
# ✅ Checks prerequisites (Git Bash, Git, Windows)
# ✅ Validates GPG (Gpg4win) installation
# ✅ Creates ~/.gnupg/gpg.conf and gpg-agent.conf
# ✅ Prompts for name/email (or uses Git config)
# ✅ Reuses existing GPG key if one exists (avoids duplicates)
# ✅ Generates a 4096-bit RSA key with 1-year expiry (only if no key exists)
# ✅ Configures Git with signing key
# ✅ Adds GPG_TTY to your shell profile
# ✅ Exports public key and copies to clipboard (clip.exe)
# ✅ Checks GitHub CLI connectivity and uploads key automatically (if available)
# ✅ Optionally tests the setup
# ✅ Can delete all GPG keys (local + GitHub instructions)


set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================

SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Default values
USER_NAME=""
USER_EMAIL=""
SKIP_INSTALL=false
SKIP_GIT_CONFIG=false
EXPORT_ONLY=false
FORCE_NEW=false
DELETE_KEYS=false
KEY_TYPE="RSA"
KEY_SIZE="4096"
KEY_EXPIRY="1y"
OS_TYPE=""
PINENTRY_PATH=""
CLIP_CMD=""
OPEN_CMD=""
TEMP_DIR=""

# =============================================================================
# Helper Functions
# =============================================================================

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}▶${NC} ${BOLD}$1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ${NC}  $1"
}

print_success() {
    echo -e "${GREEN}✓${NC}  $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

print_error() {
    echo -e "${RED}✗${NC}  $1"
}

print_usage() {
    cat << EOF
${BOLD}GPG Setup Script for Windows (Git Bash)${NC}

${BOLD}Usage:${NC}
    $SCRIPT_NAME [options]

${BOLD}Options:${NC}
    --name "Your Name"     Your full name for the GPG key
    --email "email@ex.com" Your email address (must match GitHub email)
    --skip-install         Skip GPG installation validation
    --skip-git-config      Skip Git configuration
    --export-only          Only export existing key (skip generation)
    --force-new            Force generation of new key even if one exists
    --delete-keys          Delete all GPG keys (local and GitHub instructions)
    --help                 Show this help message

${BOLD}Examples:${NC}
    # Interactive mode (prompts for name and email)
    $SCRIPT_NAME

    # Non-interactive mode
    $SCRIPT_NAME --name "John Doe" --email "john.doe@company.com"

    # Export existing key only
    $SCRIPT_NAME --export-only --email "john.doe@company.com"

    # Delete all GPG keys
    $SCRIPT_NAME --delete-keys

${BOLD}Documentation:${NC}
    See automation/gpg/GPG_SETUP_GUIDE.md for detailed instructions

EOF
}

confirm() {
    local prompt="${1:-Continue?}"
    local default="${2:-y}"

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -r -p "$prompt" response
    response="${response:-$default}"

    [[ "$response" =~ ^[Yy]$ ]]
}

# =============================================================================
# Parse Arguments
# =============================================================================

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --name)
                USER_NAME="$2"
                shift 2
                ;;
            --email)
                USER_EMAIL="$2"
                shift 2
                ;;
            --skip-install)
                SKIP_INSTALL=true
                shift
                ;;
            --skip-git-config)
                SKIP_GIT_CONFIG=true
                shift
                ;;
            --export-only)
                EXPORT_ONLY=true
                shift
                ;;
            --force-new)
                FORCE_NEW=true
                shift
                ;;
            --delete-keys)
                DELETE_KEYS=true
                shift
                ;;
            --help|-h)
                print_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done
}

# =============================================================================
# Check for Existing GPG Keys (Early Exit)
# =============================================================================

check_existing_gpg_keys() {
    print_header "Checking for Existing GPG Keys"

    # Check for any existing secret keys (regardless of email)
    local existing_keys
    existing_keys=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep "^sec" || true)

    if [[ -n "$existing_keys" ]]; then
        print_success "A GPG key already exists on this machine!"
        echo ""
        print_warning "You already have a GPG key configured. Creating another key is not recommended."
        echo ""
        
        # Display existing key information
        print_step "Your existing GPG key(s):"
        gpg --list-secret-keys --keyid-format=long 2>/dev/null || true
        echo ""

        # Get the email from the first key
        local key_email
        key_email=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep "uid" | head -1 | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' || echo "")

        if [[ -n "$key_email" ]]; then
            # Export the public key
            print_header "GPG Public Key for GitHub"
            
            echo -e "${BOLD}To add this key to GitHub:${NC}"
            echo ""
            echo "  1. Copy the public key below"
            echo "  2. Go to: ${CYAN}https://github.com/settings/gpg/new${NC}"
            echo "  3. Paste the key (Ctrl+V)"
            echo "  4. Click 'Add GPG key'"
            echo ""
            
            # Copy to clipboard
            if command -v clip.exe &> /dev/null; then
                gpg --armor --export "$key_email" | clip.exe 2>/dev/null
                print_success "Public key copied to clipboard!"
            fi
            
            echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
            echo -e "${YELLOW}Copy everything below (including BEGIN/END lines):${NC}"
            echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
            echo ""
            gpg --armor --export "$key_email" 2>/dev/null || echo "Could not export key"
            echo ""
            echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
            echo ""
        fi

        print_info "Setup cancelled - no changes were made"
        print_info "To delete existing keys and start fresh, use: ./setup-gpg.sh --delete-keys"
        exit 0
    fi

    print_info "No existing GPG keys found - proceeding with setup"
}

# =============================================================================
# Prerequisite Checks
# =============================================================================

check_prerequisites() {
    print_header "Checking Prerequisites"

    # Check if running on Windows Git Bash
    local uname_str
    uname_str="$(uname -s)"
    case "$uname_str" in
        MINGW*|MSYS*|CYGWIN*)
            OS_TYPE="windows"
            ;;
        *)
            print_error "This script is designed for Windows Git Bash only"
            print_info "Detected OS: $uname_str"
            exit 1
            ;;
    esac

    print_success "Running on Windows (Git Bash)"

    # Check for Git
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed"
        print_info "Install Git for Windows: https://git-scm.com/download/win"
        exit 1
    fi
    print_success "Git is installed ($(git --version | head -1))"

    # Determine pinentry path (Gpg4win)
    local pinentry_candidates=(
        "/c/Program Files (x86)/GnuPG/bin/pinentry.exe"
        "/c/Program Files/GnuPG/bin/pinentry.exe"
        "/c/Program Files (x86)/Gpg4win/bin/pinentry.exe"
        "/c/Program Files/Gpg4win/bin/pinentry.exe"
    )

    for candidate in "${pinentry_candidates[@]}"; do
        if [[ -f "$candidate" ]]; then
            PINENTRY_PATH="$candidate"
            break
        fi
    done

    if [[ -n "$PINENTRY_PATH" ]]; then
        print_info "Pinentry path detected: $PINENTRY_PATH"
    else
        print_warning "Pinentry not found in default locations"
        print_info "Install Gpg4win (includes pinentry): https://gpg4win.org/"
    fi

    CLIP_CMD="clip.exe"
    OPEN_CMD="cmd.exe /c start"

    if [[ -n "${TEMP:-}" ]]; then
        TEMP_DIR="$(cygpath "$TEMP" 2>/dev/null || echo "$TEMP")"
    else
        TEMP_DIR="/tmp"
    fi
}

# =============================================================================
# Install Pre-commit Hook
# =============================================================================

install_pre_commit_hook() {
    print_header "Installing Pre-commit Hook"

    # Find the git repository root
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [[ -z "$git_root" ]]; then
        print_warning "Not inside a Git repository. Skipping pre-commit hook installation."
        print_info "Run this script from within a Git repository to install the hook."
        return 0
    fi

    local hooks_dir="$git_root/.git/hooks"
    local pre_commit_src="$SCRIPT_DIR/pre-commit"
    local pre_commit_dest="$hooks_dir/pre-commit"

    # Check if source pre-commit file exists
    if [[ ! -f "$pre_commit_src" ]]; then
        print_warning "Pre-commit hook source not found: $pre_commit_src"
        print_info "Skipping pre-commit hook installation."
        return 0
    fi

    # Create hooks directory if it doesn't exist
    mkdir -p "$hooks_dir"

    # Check if pre-commit hook already exists
    if [[ -f "$pre_commit_dest" ]]; then
        # Check if it's the same file
        if diff -q "$pre_commit_src" "$pre_commit_dest" &>/dev/null; then
            print_success "Pre-commit hook is already installed and up-to-date"
        else
            print_info "Pre-commit hook exists but differs from source"
            cp "$pre_commit_dest" "$pre_commit_dest.backup.$(date +%Y%m%d%H%M%S)"
            print_info "Backed up existing hook"
            cp "$pre_commit_src" "$pre_commit_dest"
            chmod +x "$pre_commit_dest"
            print_success "Updated pre-commit hook"
        fi
    else
        cp "$pre_commit_src" "$pre_commit_dest"
        chmod +x "$pre_commit_dest"
        print_success "Installed pre-commit hook to $pre_commit_dest"
    fi

    # Configure local repository to require signed commits
    print_step "Configuring local repository to require signed commits..."

    git -C "$git_root" config commit.gpgsign true
    print_success "Enabled commit.gpgsign for this repository"

    git -C "$git_root" config tag.gpgsign true
    print_success "Enabled tag.gpgsign for this repository"

    print_info "Repository: $git_root"
    echo ""
}

# =============================================================================
# Install GPG
# =============================================================================

install_gpg() {
    print_header "Installing GPG and Dependencies"

    if [[ "$SKIP_INSTALL" == true ]]; then
        print_warning "Skipping installation (--skip-install flag)"
        return 0
    fi

    # Check if already installed
    if command -v gpg &> /dev/null; then
        local current_version
        current_version=$(gpg --version | head -1)
        print_info "GPG is already installed: $current_version"
        print_info "If you need to reinstall or update, use the Gpg4win installer."
    else
        print_error "GPG is not installed"
        print_info "Install Gpg4win from https://gpg4win.org/ and re-run this script."
        exit 1
    fi

    # Verify installation
    print_step "Verifying installation..."
    gpg --version | head -3
    echo ""
    print_success "GPG installation verified"
}

# =============================================================================
# Configure GPG
# =============================================================================

configure_gpg() {
    print_header "Configuring GPG"

    # Create GPG directory
    print_step "Creating GPG directory..."
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    print_success "Created ~/.gnupg with correct permissions"

    # Configure GPG agent
    print_step "Configuring GPG agent..."

    # Backup existing config if present
    if [[ -f ~/.gnupg/gpg-agent.conf ]]; then
        cp ~/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf.backup.$(date +%Y%m%d%H%M%S)
        print_info "Backed up existing gpg-agent.conf"
    fi

    {
        echo "# GPG Agent Configuration"
        echo "# Generated by setup-gpg.sh on $(date)"
        echo ""
        if [[ -n "$PINENTRY_PATH" ]]; then
            echo "# Use pinentry for passphrase prompts"
            echo "pinentry-program $PINENTRY_PATH"
        else
            echo "# pinentry-program not set (pinentry not found)"
        fi
        echo ""
        echo "# Cache passphrase for 8 hours (28800 seconds)"
        echo "default-cache-ttl 28800"
        echo "max-cache-ttl 28800"
        echo ""
        echo "# Enable SSH support (optional)"
        echo "enable-ssh-support"
    } > ~/.gnupg/gpg-agent.conf

    chmod 600 ~/.gnupg/gpg-agent.conf
    print_success "Created gpg-agent.conf"

    # Configure GPG
    print_step "Configuring GPG preferences..."

    if [[ -f ~/.gnupg/gpg.conf ]]; then
        cp ~/.gnupg/gpg.conf ~/.gnupg/gpg.conf.backup.$(date +%Y%m%d%H%M%S)
        print_info "Backed up existing gpg.conf"
    fi

    cat > ~/.gnupg/gpg.conf << 'EOF'
# GPG Configuration
# Generated by setup-gpg.sh

# Use long key IDs
keyid-format long

# Display fingerprints
with-fingerprint

# Use SHA-256 as default hash
personal-digest-preferences SHA256
cert-digest-algo SHA256
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

# Disable comment string in clear text signatures
no-comments

# Disable version string in output
no-emit-version

# Trust model
trust-model tofu+pgp
EOF

    chmod 600 ~/.gnupg/gpg.conf
    print_success "Created gpg.conf"

    # Restart GPG agent
    print_step "Restarting GPG agent..."
    gpgconf --kill gpg-agent 2>/dev/null || true
    gpgconf --launch gpg-agent 2>/dev/null || true
    print_success "GPG agent restarted"
}

# =============================================================================
# Generate GPG Key
# =============================================================================

get_user_info() {
    print_header "User Information"

    # Get name
    if [[ -z "$USER_NAME" ]]; then
        # Try to get from Git config
        local git_name
        git_name=$(git config --global user.name 2>/dev/null || echo "")

        if [[ -n "$git_name" ]]; then
            print_info "Found Git user name: $git_name"
            if confirm "Use this name?"; then
                USER_NAME="$git_name"
            fi
        fi

        if [[ -z "$USER_NAME" ]]; then
            read -r -p "Enter your full name: " USER_NAME
        fi
    fi

    # Validate name
    if [[ -z "$USER_NAME" || ${#USER_NAME} -lt 2 ]]; then
        print_error "Name must be at least 2 characters"
        exit 1
    fi

    # Get email
    if [[ -z "$USER_EMAIL" ]]; then
        # Try to get from Git config
        local git_email
        git_email=$(git config --global user.email 2>/dev/null || echo "")

        if [[ -n "$git_email" ]]; then
            print_info "Found Git user email: $git_email"
            if confirm "Use this email?"; then
                USER_EMAIL="$git_email"
            fi
        fi

        if [[ -z "$USER_EMAIL" ]]; then
            read -r -p "Enter your email (must match GitHub email): " USER_EMAIL
        fi
    fi

    # Validate email
    if [[ ! "$USER_EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        print_error "Invalid email format"
        exit 1
    fi

    echo ""
    print_info "Name:  $USER_NAME"
    print_info "Email: $USER_EMAIL"
    echo ""

    if ! confirm "Is this information correct?"; then
        print_error "Aborted by user"
        exit 1
    fi
}

generate_gpg_key() {
    print_header "Generating GPG Key"
    print_step "Generating new GPG key..."
    print_info "Key type: RSA and RSA"
    print_info "Key size: 4096 bits"
    print_info "Expiration: 1 year"
    echo ""
    print_warning "You will be prompted to enter a passphrase."
    print_warning "Use a strong passphrase and store it in a password manager!"
    echo ""

    # Generate key using batch mode for automation
    # But still require passphrase entry via pinentry
    cat > /tmp/gpg-key-params << EOF
%echo Generating GPG key...
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $USER_NAME
Name-Email: $USER_EMAIL
Expire-Date: 1y
%ask-passphrase
%commit
%echo Key generation complete
EOF

    # Generate the key
    gpg --batch --generate-key /tmp/gpg-key-params

    # Clean up
    rm -f /tmp/gpg-key-params

    print_success "GPG key generated successfully!"

    # Display the new key
    echo ""
    print_step "Your new GPG key:"
    gpg --list-secret-keys --keyid-format=long "$USER_EMAIL"
}

# =============================================================================
# Configure Git
# =============================================================================

configure_git() {
    print_header "Configuring Git for GPG Signing"

    if [[ "$SKIP_GIT_CONFIG" == true ]]; then
        print_warning "Skipping Git configuration (--skip-git-config flag)"
        return 0
    fi

    # Get the key ID
    print_step "Getting GPG key ID..."
    local key_id
    key_id=$(gpg --list-secret-keys --keyid-format=long "$USER_EMAIL" 2>/dev/null | grep sec | head -1 | awk -F'/' '{print $2}' | awk '{print $1}')

    if [[ -z "$key_id" ]]; then
        print_error "Could not find GPG key for $USER_EMAIL"
        exit 1
    fi

    print_success "Found key ID: $key_id"

    # Configure Git
    print_step "Configuring Git..."

    git config --global user.signingkey "$key_id"
    print_success "Set user.signingkey = $key_id"

    git config --global commit.gpgsign true
    print_success "Enabled automatic commit signing"

    git config --global tag.gpgsign true
    print_success "Enabled automatic tag signing"

    git config --global gpg.program gpg
    print_success "Set GPG program"

    # Ensure user name and email are set
    if [[ -z "$(git config --global user.name 2>/dev/null)" ]]; then
        git config --global user.name "$USER_NAME"
        print_success "Set user.name = $USER_NAME"
    fi

    if [[ -z "$(git config --global user.email 2>/dev/null)" ]]; then
        git config --global user.email "$USER_EMAIL"
        print_success "Set user.email = $USER_EMAIL"
    fi

    echo ""
    print_info "Current Git GPG configuration:"
    git config --global --list | grep -E "(signingkey|gpgsign|gpg.program)" | while read -r line; do
        echo "    $line"
    done
}

# =============================================================================
# Configure Shell
# =============================================================================

configure_shell() {
    print_header "Configuring Shell Environment"

    local shell_profile=""
    local shell_name=""

    # Detect shell
    case "$SHELL" in
        */zsh)
            shell_profile="$HOME/.zshrc"
            shell_name="Zsh"
            ;;
        */bash)
            if [[ -f "$HOME/.bash_profile" ]]; then
                shell_profile="$HOME/.bash_profile"
            else
                shell_profile="$HOME/.bashrc"
            fi
            shell_name="Bash"
            ;;
        *)
            print_warning "Unknown shell: $SHELL"
            shell_profile="$HOME/.profile"
            shell_name="Unknown"
            ;;
    esac

    print_info "Detected shell: $shell_name"
    print_info "Profile file: $shell_profile"

    # Check if GPG_TTY is already configured
    if grep -q "GPG_TTY" "$shell_profile" 2>/dev/null; then
        print_success "GPG_TTY is already configured in $shell_profile"
        return 0
    fi

    # Add GPG configuration
    print_step "Adding GPG configuration to $shell_profile..."

    cat >> "$shell_profile" << 'EOF'

# =============================================================================
# GPG Configuration (added by setup-gpg.sh)
# =============================================================================
export GPG_TTY=$(tty)

# Start gpg-agent if not running
if ! pgrep -x "gpg-agent" > /dev/null; then
    gpgconf --launch gpg-agent 2>/dev/null
fi
# =============================================================================
EOF

    print_success "Added GPG configuration to $shell_profile"

    # Source the profile
    print_step "Reloading shell configuration..."
    export GPG_TTY=$(tty)
    print_success "GPG_TTY is now set"
}

# =============================================================================
# Export Public Key
# =============================================================================

export_public_key() {
    print_header "Exporting Public Key"

    local key_email="$USER_EMAIL"

    # If export only mode without email, try to find first key
    if [[ -z "$key_email" ]]; then
        key_email=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep uid | head -1 | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' || echo "")

        if [[ -z "$key_email" ]]; then
            print_error "No GPG keys found. Generate a key first."
            exit 1
        fi
        print_info "Using key for: $key_email"
    fi

    # Export to file
    local export_file="$HOME/gpg-public-key-$(date +%Y%m%d).txt"

    print_step "Exporting public key..."
    gpg --armor --export "$key_email" > "$export_file"
    print_success "Exported to: $export_file"

    # Copy to clipboard
    print_step "Copying to clipboard..."
    if command -v "$CLIP_CMD" &> /dev/null; then
        gpg --armor --export "$key_email" | "$CLIP_CMD"
        print_success "Public key copied to clipboard!"
    else
        print_warning "Clipboard command not found; skipping clipboard copy"
    fi

    echo ""
    print_info "Your public key has been:"
    print_info "  1. Saved to: $export_file"
    print_info "  2. Copied to clipboard (paste with Ctrl+V)"
    echo ""

    # Show the key
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
    gpg --armor --export "$key_email" | head -20
    echo "..."
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
    echo ""

    # Check GitHub CLI connectivity and offer to upload key
    add_key_to_github "$export_file"
}

# =============================================================================
# Add GPG Key to GitHub
# =============================================================================

add_key_to_github() {
    local export_file="$1"

    print_header "Adding GPG Key to GitHub"

    # Check if GitHub CLI is installed
    if ! command -v gh &> /dev/null; then
        print_warning "GitHub CLI (gh) is not installed"
        print_info "Install it from https://cli.github.com/ or via winget"
        echo ""
        print_info "Manual steps to add your GPG key to GitHub:"
        print_info "  1. Go to: https://github.com/settings/keys"
        print_info "  2. Click 'New GPG key'"
        print_info "  3. Paste the key from your clipboard (Ctrl+V)"
        echo ""
        return 0
    fi

    print_success "GitHub CLI (gh) is installed"

    # Check if user is authenticated with GitHub
    print_step "Checking GitHub CLI authentication..."

    if ! gh auth status &> /dev/null; then
        print_warning "GitHub CLI is not authenticated"
        print_info "Run 'gh auth login' to authenticate with GitHub"
        echo ""
        print_info "Manual steps to add your GPG key to GitHub:"
        print_info "  1. Go to: https://github.com/settings/keys"
        print_info "  2. Click 'New GPG key'"
        print_info "  3. Paste the key from your clipboard (Ctrl+V)"
        echo ""
        return 0
    fi

    # Get authenticated user info
    local gh_user
    gh_user=$(gh api user --jq '.login' 2>/dev/null || echo "")

    if [[ -z "$gh_user" ]]; then
        print_warning "Could not verify GitHub connectivity"
        print_info "Check your network connection and try again"
        echo ""
        print_info "Manual steps to add your GPG key to GitHub:"
        print_info "  1. Go to: https://github.com/settings/keys"
        print_info "  2. Click 'New GPG key'"
        print_info "  3. Paste the key from your clipboard (Ctrl+V)"
        echo ""
        return 0
    fi

    print_success "Connected to GitHub as: $gh_user"
    echo ""

    # Check if key already exists on GitHub
    print_step "Checking for existing GPG keys on GitHub..."

    local existing_keys
    existing_keys=$(gh gpg-key list 2>/dev/null || echo "")

    local key_id
    key_id=$(gpg --list-secret-keys --keyid-format=long "$USER_EMAIL" 2>/dev/null | grep sec | head -1 | awk -F'/' '{print $2}' | awk '{print $1}')

    if echo "$existing_keys" | grep -q "$key_id" 2>/dev/null; then
        print_success "GPG key is already added to GitHub"
        return 0
    fi

    # Offer to upload the key
    if confirm "Would you like to upload the GPG key to GitHub now?"; then
        print_step "Uploading GPG key to GitHub..."

        if gh gpg-key add "$export_file" 2>/dev/null; then
            print_success "GPG key successfully added to GitHub!"
            echo ""
            print_info "Your commits will now show as 'Verified' on GitHub"
        else
            print_error "Failed to upload GPG key to GitHub"
            echo ""
            print_info "Manual steps to add your GPG key:"
            print_info "  1. Go to: https://github.com/settings/keys"
            print_info "  2. Click 'New GPG key'"
            print_info "  3. Paste the key from your clipboard (Ctrl+V)"
        fi
    else
        print_info "Skipped uploading to GitHub"
        echo ""
        print_info "To add your key manually:"
        print_info "  1. Go to: https://github.com/settings/keys"
        print_info "  2. Click 'New GPG key'"
        print_info "  3. Paste the key from your clipboard (Ctrl+V)"
    fi
    echo ""
}

# =============================================================================
# Delete GPG Keys
# =============================================================================

delete_gpg_keys() {
    print_header "Delete GPG Keys"

    print_warning "This will delete ALL GPG keys from your local system!"
    echo ""
    print_info "This operation will:"
    print_info "  1. List all your GPG keys"
    print_info "  2. Delete secret (private) keys"
    print_info "  3. Delete public keys"
    print_info "  4. Remove Git GPG configuration"
    print_info "  5. Provide instructions to remove keys from GitHub"
    echo ""

    if ! confirm "Are you sure you want to delete all GPG keys?" "n"; then
        print_info "Aborted - no keys were deleted"
        exit 0
    fi

    # List all secret keys
    print_step "Listing all GPG keys..."
    echo ""
    gpg --list-secret-keys --keyid-format=long 2>/dev/null || {
        print_warning "No GPG keys found on this system"
        exit 0
    }
    echo ""

    # Get all key IDs
    local key_ids
    key_ids=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep "^sec" | awk '{print $2}' | awk -F'/' '{print $2}')

    if [[ -z "$key_ids" ]]; then
        print_warning "No secret keys found to delete"
        exit 0
    fi

    # Get all emails for GitHub instructions
    local key_emails
    key_emails=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep "^uid" | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' | sort -u)

    # Count keys
    local key_count
    key_count=$(echo "$key_ids" | wc -l | tr -d ' ')
    print_warning "Found $key_count key(s) to delete"
    echo ""

    if ! confirm "Proceed with deletion? THIS CANNOT BE UNDONE!" "n"; then
        print_info "Aborted - no keys were deleted"
        exit 0
    fi

    # Delete each key
    print_header "Deleting Keys"

    while IFS= read -r key_id; do
        print_step "Deleting key: $key_id"
        
        # Delete secret key (requires --batch and --yes for non-interactive)
        if gpg --batch --yes --delete-secret-keys "$key_id" 2>/dev/null; then
            print_success "Deleted secret key: $key_id"
        else
            print_warning "Failed to delete secret key: $key_id (may not exist)"
        fi

        # Delete public key
        if gpg --batch --yes --delete-keys "$key_id" 2>/dev/null; then
            print_success "Deleted public key: $key_id"
        else
            print_warning "Failed to delete public key: $key_id (may not exist)"
        fi
    done <<< "$key_ids"

    # Remove Git configuration
    print_header "Removing Git GPG Configuration"
    
    if [[ -n "$(git config --global user.signingkey 2>/dev/null)" ]]; then
        git config --global --unset user.signingkey 2>/dev/null || true
        print_success "Removed user.signingkey from Git config"
    fi

    if [[ "$(git config --global commit.gpgsign 2>/dev/null)" == "true" ]]; then
        git config --global --unset commit.gpgsign 2>/dev/null || true
        print_success "Disabled automatic commit signing"
    fi

    if [[ "$(git config --global tag.gpgsign 2>/dev/null)" == "true" ]]; then
        git config --global --unset tag.gpgsign 2>/dev/null || true
        print_success "Disabled automatic tag signing"
    fi

    # Verify deletion
    print_header "Verification"
    
    local remaining_keys
    remaining_keys=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null || echo "")

    if [[ -z "$remaining_keys" ]]; then
        print_success "All GPG keys have been deleted from your local system!"
    else
        print_warning "Some keys may still remain:"
        echo "$remaining_keys"
    fi

    # GitHub instructions
    print_header "GitHub Cleanup Instructions"
    
    echo -e "${BOLD}To remove GPG keys from GitHub:${NC}"
    echo ""
    echo "  1. Go to: ${CYAN}https://github.com/settings/keys${NC}"
    echo "  2. Find your GPG key(s) in the list"
    
    if [[ -n "$key_emails" ]]; then
        echo "  3. Look for keys associated with:"
        while IFS= read -r email; do
            echo "     • $email"
        done <<< "$key_emails"
    fi
    
    echo "  4. Click ${RED}[Delete]${NC} next to each key"
    echo "  5. Confirm deletion"
    echo ""
    print_info "Old commits will still show 'Verified' but you can't sign new commits with deleted keys"
    echo ""
    
    # Optional: Open GitHub in browser
    if command -v cmd.exe &> /dev/null; then
        if confirm "Open GitHub GPG settings in browser now?"; then
            cmd.exe /c start "" "https://github.com/settings/keys" >/dev/null 2>&1
            print_success "Opened GitHub settings in your default browser"
        fi
    fi

    print_header "Cleanup Complete! ✓"
    
    echo -e "${BOLD}Summary:${NC}"
    echo ""
    echo "  ✓ Deleted $key_count GPG key(s) from local system"
    echo "  ✓ Removed Git GPG configuration"
    echo "  ⚠ Remember to remove keys from GitHub (see instructions above)"
    echo ""
    echo -e "${BOLD}Next Steps:${NC}"
    echo ""
    echo "  • If you want to set up GPG again, run:"
    echo "    $SCRIPT_NAME"
    echo ""
}

# =============================================================================
# Test Setup
# =============================================================================

test_setup() {
    print_header "Testing GPG Setup"

    # Test GPG signing
    print_step "Testing GPG signing..."

    local test_result
    if echo "test" | gpg --clearsign --armor 2>/dev/null | grep -q "BEGIN PGP SIGNED MESSAGE"; then
        print_success "GPG signing works!"
    else
        print_warning "GPG signing test had issues (may need passphrase entry)"
    fi

    # Test Git commit (optional)
    if confirm "Do you want to test a Git commit signature?" "n"; then
        print_step "Creating test repository..."

        local test_dir="$TEMP_DIR/gpg-test-$(date +%s)"
        mkdir -p "$test_dir"
        cd "$test_dir"
        git init --quiet

        echo "Test GPG signing" > test.txt
        git add test.txt

        print_step "Creating signed commit..."
        if git commit -m "test: verify GPG signing works" 2>/dev/null; then
            print_success "Signed commit created!"
            echo ""
            git log --show-signature -1
        else
            print_warning "Commit test failed (check passphrase/configuration)"
        fi

        # Cleanup
        cd - > /dev/null
        rm -rf "$test_dir"
    fi
}

# =============================================================================
# Summary
# =============================================================================

print_summary() {
    print_header "Setup Complete! 🎉"

    local key_id
    key_id=$(gpg --list-secret-keys --keyid-format=long "$USER_EMAIL" 2>/dev/null | grep sec | head -1 | awk -F'/' '{print $2}' | awk '{print $1}' || echo "N/A")

    local export_file="$HOME/gpg-public-key-$(date +%Y%m%d).txt"

    echo -e "${BOLD}Summary:${NC}"
    echo ""
    echo "  GPG Key ID:     $key_id"
    echo "  Email:          $USER_EMAIL"
    echo "  Name:           $USER_NAME"
    echo "  Public Key:     $export_file"
    echo ""
    echo -e "${BOLD}Next Steps:${NC}"
    echo ""
    echo "  1. ${GREEN}Add your public key to GitHub (if not done automatically):${NC}"
    echo "     → Go to: https://github.com/settings/keys"
    echo "     → Click 'New GPG key'"
    echo "     → Paste the key (already in your clipboard!)"
    echo ""
    echo "  2. ${GREEN}Make a signed commit:${NC}"
    echo "     git commit -m \"feat: my first signed commit\""
    echo ""
    echo "  3. ${GREEN}Verify the signature:${NC}"
    echo "     git log --show-signature -1"
    echo ""
    echo -e "${BOLD}Documentation:${NC}"
    echo ""
    echo "  → GPG Setup Guide:   automation/gpg/GPG_SETUP_GUIDE.md"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    # Always show GPG values for manual GitHub configuration
    echo -e "${BOLD}GPG Values for Manual GitHub Configuration:${NC}"
    echo ""
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}GitHub URL:${NC} https://github.com/settings/gpg/new"
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "${YELLOW}Your GPG Public Key (copy everything below including BEGIN/END lines):${NC}"
    echo ""
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
    if [[ -f "$export_file" ]]; then
        cat "$export_file"
    else
        gpg --armor --export "$USER_EMAIL" 2>/dev/null || echo "Could not export key"
    fi
    echo -e "${CYAN}─────────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "${BOLD}Quick Commands:${NC}"
    echo ""
    echo "  # Copy public key to clipboard again:"
    echo "  gpg --armor --export $USER_EMAIL | clip.exe"
    echo ""
    echo "  # View your key ID:"
    echo "  gpg --list-secret-keys --keyid-format=long $USER_EMAIL"
    echo ""
    echo "  # Export key to file:"
    echo "  gpg --armor --export $USER_EMAIL > ~/my-gpg-key.txt"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

# =============================================================================
# Main
# =============================================================================

main() {
    print_header "GPG Setup for Windows (Git Bash)"

    # Parse command line arguments
    parse_args "$@"

    if [[ "$DELETE_KEYS" == true ]]; then
        # Delete keys mode
        delete_gpg_keys
        exit 0
    fi

    if [[ "$EXPORT_ONLY" == true ]]; then
        # Export only mode
        export_public_key
        exit 0
    fi

    # Check for existing keys first (before any user interaction)
    check_existing_gpg_keys

    # Run setup steps
    install_pre_commit_hook
    check_prerequisites
    install_gpg
    configure_gpg
    get_user_info
    generate_gpg_key
    configure_git
    configure_shell
    export_public_key
    test_setup
    print_summary
}

# Run main function
main "$@"
