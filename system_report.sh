#!/bin/bash

echo "========================================"
echo "System Report: $(date)"
echo "========================================"

# Uptime
echo "[Uptime]"
uptime -p
echo ""

# CPU Usage
echo "[CPU Usage]"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
echo ""

# Memory Usage
echo "[Memory Usage]"
free -h | awk '/^Mem:/ {print "Used: " $3 " / Total: " $2}'
echo ""

# Disk Usage
echo "[Disk Usage]"
df -h / | awk 'NR==2 {print "Used: " $3 " / Total: " $2 " (" $5 ")"}'
echo ""

echo "[Top 3 Processes by CPU]"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 4
echo ""