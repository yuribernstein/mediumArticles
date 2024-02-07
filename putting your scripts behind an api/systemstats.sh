#!/bin/bash

echo "System Utilization Report"
echo "========================="
printf "%-20s %-20s\n" "Metric" "Value"

# System uptime
UPTIME=$(uptime | awk -F'( |,|:)+' '{if($6=="days"||$6=="day"){print $4,$5",",$6,$7,"hours."}else{print $4,"hours,",$5,"minutes."}}')
printf "%-20s %-20s\n" "Uptime" "$UPTIME"

# CPU usage
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CPU_USAGE=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}')
fi
printf "%-20s %-20s\n" "CPU Usage" "$CPU_USAGE"

# Memory usage
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    MEMORY_USAGE=$(free | grep Mem | awk '{printf("%.2f%%", $3/$2 * 100.0)}')
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Convert pages to bytes (assuming 4096 bytes per page) and calculate percentage
    TOTAL_MEM=$(sysctl -n hw.memsize)
    FREE_MEM=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
    FREE_MEM_BYTES=$(($FREE_MEM * 4096))
    MEMORY_USAGE=$(echo "scale=2; (1 - $FREE_MEM_BYTES / $TOTAL_MEM) * 100" | bc)
    MEMORY_USAGE="$MEMORY_USAGE%"
fi
printf "%-20s %-20s\n" "Memory Usage" "$MEMORY_USAGE"

# Disk usage
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
printf "%-20s %-20s\n" "Disk Usage" "$DISK_USAGE"
