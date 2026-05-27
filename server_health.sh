#!/bin/bash
# ICT171 Server Status Script - Mobassir Rafin (35731433)
# This script checks and logs the health of the web server environment.
# It verifies Nginx is running, logs disk/memory usage, and confirms port 80/443 are open.

echo "===== Server Health Report ====="
echo "Date: $(date)"

# Check if Nginx is active
echo ""
echo "--- Nginx Status ---"
systemctl is-active --quiet nginx && echo "Nginx: RUNNING" || echo "Nginx: STOPPED"

# Show disk usage
echo ""
echo "--- Disk Usage ---"
df -h /

# Show memory usage
echo ""
echo "--- Memory Usage ---"
free -h

# Check open ports
echo ""
echo "--- Open Ports (80 & 443) ---"
ss -tlnp | grep -E ':80|:443'

echo ""
echo "===== End of Report ====="
