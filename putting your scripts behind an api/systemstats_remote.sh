#!/bin/bash

REMOTE_USER=$1
REMOTE_HOST=$2

echo "System Utilization Report for $REMOTE_HOST"
echo "==========================================="
printf "%-20s %-20s\n" "Metric" "Value"

ssh_execute() {
    ssh -o ConnectTimeout=5 "$REMOTE_USER@$REMOTE_HOST" "$@"
}

UPTIME=$(ssh_execute uptime | awk -F'( |,|:)+' '{if($6=="days"||$6=="day"){print $4,$5",",$6,$7,"hours."}else{print $4,"hours,",$5,"minutes."}}')
printf "%-20s %-20s\n" "Uptime" "$UPTIME"

CPU_USAGE=$(ssh_execute top -b -n 1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}')
printf "%-20s %-20s\n" "CPU Usage" "$CPU_USAGE"

MEMORY_USAGE=$(ssh_execute free | grep Mem | awk '{printf("%.2f%%", $3/$2 * 100.0)}')
printf "%-20s %-20s\n" "Memory Usage" "$MEMORY_USAGE"

DISK_USAGE=$(ssh_execute df -h / | awk 'NR==2 {print $5}')
printf "%-20s %-20s\n" "Disk Usage" "$DISK_USAGE"

