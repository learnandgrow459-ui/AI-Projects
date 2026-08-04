#!/bin/bash

# Function to check health based on resource utilization
check_health() {
    # Get CPU usage percentage
    cpu_usage=$(top -bn1 | grep 'Cpu(s)' | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

    # Get memory usage percentage
    mem_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

    # Get disk usage percentage of root filesystem
    disk_usage=$(df / | awk '$NF=="/"{printf "%.2f"}, $5}' | sed 's/%//g')

    # Check if any resource is 60% or above
    if (( $(echo "$cpu_usage >= 60" | bc -l) )) || (( $(echo "$mem_usage >= 60" | bc -l) )) || (( $(echo "$disk_usage >= 60" | bc -l) )); then
        echo "Not Healthy"
    else
        echo "Healthy"
    fi
}

# Function to explain health status
explain_health() {
    # Get CPU usage percentage
    cpu_usage=$(top -bn1 | grep 'Cpu(s)' | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

    # Get memory usage percentage
    mem_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

    # Get disk usage percentage of root filesystem
    disk_usage=$(df / | awk '$NF=="/"{printf "%.2f"}, $5}' | sed 's/%//g')

    echo "CPU Usage: ${cpu_usage}%"
    echo "Memory Usage: ${mem_usage}%"
    echo "Disk Usage: ${disk_usage}%"

    if (( $(echo "$cpu_usage >= 60" | bc -l) )) || (( $(echo "$mem_usage >= 60" | bc -l) )) || (( $(echo "$disk_usage >= 60" | bc -l) )); then
        echo "VM is Not Healthy because one or more resources are at or above 60%."
    else
        echo "VM is Healthy because all resources are below 60%."
    fi
}

# Main script logic
case "$1" in
    explain)
        explain_health
        ;;
    *)
        check_health
        ;;
esac