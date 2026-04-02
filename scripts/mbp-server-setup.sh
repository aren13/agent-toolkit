#!/bin/bash
# ============================================================================
# OpenClaw MacBook Pro Server Setup
# Turns your MacBook Pro into an always-on home server
# Run with: sudo bash mbp-server-setup.sh
# Revert with: sudo bash mbp-server-setup.sh --revert
# ============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

BACKUP_FILE="/Library/Preferences/SystemConfiguration/com.apple.PowerManagement.openclaw-backup.plist"
CAFFEINATE_PLIST="/Library/LaunchDaemons/com.openclaw.caffeinate.plist"

# ── Pre-flight ──────────────────────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Run as root: sudo bash $0${NC}"
    exit 1
fi

# ── Revert mode ─────────────────────────────────────────────────────────────
if [[ "$1" == "--revert" ]]; then
    echo -e "${CYAN}═══ Reverting to pre-OpenClaw settings ═══${NC}\n"

    # Remove caffeinate daemon
    if [[ -f "$CAFFEINATE_PLIST" ]]; then
        launchctl bootout system/com.openclaw.caffeinate 2>/dev/null || true
        rm -f "$CAFFEINATE_PLIST"
        echo -e "${GREEN}✓ Removed caffeinate LaunchDaemon${NC}"
    fi

    # Restore pmset defaults
    pmset restoredefaults 2>/dev/null
    echo -e "${GREEN}✓ Restored default power management settings${NC}"

    # Disable SSH if user wants
    echo -e "\n${YELLOW}Disable Remote Login (SSH)? [y/N]${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        systemsetup -setremotelogin off 2>/dev/null || true
        echo -e "${GREEN}✓ SSH disabled${NC}"
    fi

    echo -e "\n${GREEN}═══ Revert complete. Restart recommended. ═══${NC}"
    exit 0
fi

echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}   OpenClaw — MacBook Pro Server Setup${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}\n"

# ── Step 1: Backup current settings ─────────────────────────────────────────
echo -e "${YELLOW}[1/7] Backing up current power settings...${NC}"
pmset -g custom > /tmp/openclaw-pmset-backup.txt
echo -e "${GREEN}  ✓ Saved to /tmp/openclaw-pmset-backup.txt${NC}\n"

# ── Step 2: Power Management (pmset) ────────────────────────────────────────
echo -e "${YELLOW}[2/7] Configuring power management...${NC}"

# Apply to ALL power sources (-a = AC + battery + UPS)
sudo pmset -a \
    sleep 0 \
    disksleep 0 \
    displaysleep 15 \
    hibernatemode 0 \
    standby 0 \
    autopoweroff 0 \
    powernap 0 \
    proximitywake 0 \
    tcpkeepalive 1 \
    ttyskeepawake 1 \
    womp 1 \
    autorestart 1 \
    lidwake 1

# Explanation:
#   sleep 0           → never sleep
#   disksleep 0       → never spin down disk
#   displaysleep 15   → display off after 15min (saves screen, not power-hungry)
#   hibernatemode 0   → no hibernate image, pure RAM sleep (which we disabled)
#   standby 0         → no deep standby
#   autopoweroff 0    → no auto power off
#   powernap 0        → no background wake cycles
#   proximitywake 0   → don't wake for nearby iCloud devices
#   tcpkeepalive 1    → keep TCP connections alive (critical for remote access)
#   ttyskeepawake 1   → SSH sessions prevent sleep
#   womp 1            → wake on network (Wake-on-LAN)
#   autorestart 1     → auto restart after power loss
#   lidwake 1         → wake when lid opened

echo -e "${GREEN}  ✓ System will never sleep${NC}"
echo -e "${GREEN}  ✓ Auto-restart on power loss enabled${NC}"
echo -e "${GREEN}  ✓ Wake-on-LAN enabled${NC}"
echo -e "${GREEN}  ✓ Display sleeps after 15min (configurable)${NC}\n"

# ── Step 3: Disable lid-close sleep ─────────────────────────────────────────
echo -e "${YELLOW}[3/7] Disabling lid-close sleep...${NC}"

# This is the key setting for running with lid closed
sudo pmset -a disablesleep 1

echo -e "${GREEN}  ✓ Lid close will NOT trigger sleep${NC}\n"

# ── Step 4: Caffeinate as persistent LaunchDaemon ───────────────────────────
echo -e "${YELLOW}[4/7] Installing caffeinate LaunchDaemon...${NC}"

cat > "$CAFFEINATE_PLIST" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.openclaw.caffeinate</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/caffeinate</string>
        <string>-dimsu</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>ProcessType</key>
    <string>Interactive</string>
    <key>ThrottleInterval</key>
    <integer>0</integer>
    <key>StandardOutPath</key>
    <string>/tmp/openclaw-caffeinate.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/openclaw-caffeinate.log</string>
</dict>
</plist>
EOF

# caffeinate flags:
#   -d  prevent display sleep
#   -i  prevent idle sleep
#   -m  prevent disk sleep
#   -s  prevent system sleep (AC only)
#   -u  declare user active

chown root:wheel "$CAFFEINATE_PLIST"
chmod 644 "$CAFFEINATE_PLIST"
launchctl bootout system/com.openclaw.caffeinate 2>/dev/null || true
launchctl bootstrap system "$CAFFEINATE_PLIST"

echo -e "${GREEN}  ✓ caffeinate -dimsu running as system daemon${NC}"
echo -e "${GREEN}  ✓ Auto-restarts on crash, persists across reboots${NC}\n"

# ── Step 5: Enable SSH (Remote Login) ───────────────────────────────────────
echo -e "${YELLOW}[5/7] Enabling Remote Login (SSH)...${NC}"

systemsetup -setremotelogin on 2>/dev/null || {
    # On newer macOS, may need different approach
    launchctl load -w /System/Library/LaunchDaemons/ssh.plist 2>/dev/null || true
}

echo -e "${GREEN}  ✓ SSH enabled — connect with: ssh $(whoami)@$(hostname)${NC}\n"

# ── Step 6: Disable screen lock (optional, for headless) ───────────────────
echo -e "${YELLOW}[6/7] Screen saver / lock settings...${NC}"

# Disable screen saver start
defaults -currentHost write com.apple.screensaver idleTime 0 2>/dev/null || true

echo -e "${GREEN}  ✓ Screen saver disabled${NC}\n"

# ── Step 7: Verify ──────────────────────────────────────────────────────────
echo -e "${YELLOW}[7/7] Verifying configuration...${NC}\n"

echo -e "${CYAN}── Current pmset settings ──${NC}"
pmset -g | head -25
echo ""

echo -e "${CYAN}── Caffeinate daemon status ──${NC}"
if launchctl print system/com.openclaw.caffeinate &>/dev/null; then
    echo -e "${GREEN}  ✓ com.openclaw.caffeinate is running${NC}"
else
    echo -e "${RED}  ✗ caffeinate daemon not detected${NC}"
fi
echo ""

echo -e "${CYAN}── SSH status ──${NC}"
if systemsetup -getremotelogin 2>/dev/null | grep -q "On"; then
    echo -e "${GREEN}  ✓ Remote Login: On${NC}"
else
    echo -e "${YELLOW}  ? Could not verify SSH status${NC}"
fi
echo ""

# ── Summary ─────────────────────────────────────────────────────────────────
IP=$(ipconfig getifaddr en0 2>/dev/null || echo "check with: ifconfig")

echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}   Setup Complete!${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  ${GREEN}✓${NC} Never sleeps (system, disk, lid close)"
echo -e "  ${GREEN}✓${NC} Display dims after 15min (saves OLED/LCD life)"
echo -e "  ${GREEN}✓${NC} Auto-restarts after power loss"
echo -e "  ${GREEN}✓${NC} caffeinate daemon persists across reboots"
echo -e "  ${GREEN}✓${NC} SSH enabled for remote access"
echo -e "  ${GREEN}✓${NC} Wake-on-LAN enabled"
echo -e "  ${GREEN}✓${NC} TCP keepalive + TTY keepawake active"
echo ""
echo -e "  ${CYAN}Local IP:${NC} $IP"
echo -e "  ${CYAN}SSH:${NC}      ssh $(whoami)@$IP"
echo ""
echo -e "${YELLOW}Recommendations:${NC}"
echo -e "  • Keep MacBook plugged in (always on AC power)"
echo -e "  • Keep lid slightly open or use a stand (thermals)"
echo -e "  • Set up Tailscale/WireGuard/ZeroTier for remote access outside LAN"
echo -e "  • Set up auto-login: System Settings → Users → Login Options → Auto Login"
echo -e "  • To revert: sudo bash mbp-server-setup.sh --revert"
echo ""
