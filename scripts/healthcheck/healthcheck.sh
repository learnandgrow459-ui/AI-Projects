#!/bin/bash

# Function to check CPU utilization percentage
check_cpu() {
    cpu_usage=$(top -bn1 | grep 'Cpu(s)' | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$cpu_usage >= 60" | bc -l) )); then
        echo "Not Healthy"
    else
        echo "Healthy"
    fi
}

# Function to check memory utilization percentage
check_memory() {
    mem_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
    if (( $(echo "$mem_usage >= 60" | bc -l) )); then
        echo "Not Healthy"
    else
        echo "Healthy"
    fi
}

# Function to check disk utilization percentage of root filesystem (/)
disk_usage=$(df / | awk '/\//{printf("%.2f"), $5}' | sed 's/%//')
if (( $(echo "$disk_usage >= 60" | bc -l) )); then
    echo "Not Healthy"
else
    echo "Healthy"
fi

# Check if explain mode is used
if [ "$1" == "explain" ]; then
    echo "CPU Utilization: $cpu_usage%"
    echo "Memory Utilization: $mem_usage%"
    echo "Disk Utilization of /: $disk_usage%"
    if (( $(echo "$cpu_usage >= 60" | bc -l) )) || (( $(echo "$mem_usage >= 60" | bc -l) )) || (( $(echo "$disk_usage >= 60" | bc -l) )); then
        echo "Not Healthy"
    else
        echo "Healthy"
    fi
fi