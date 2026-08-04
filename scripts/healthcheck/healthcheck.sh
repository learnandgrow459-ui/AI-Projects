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
disk_usage=$(df / | awk 'NR==2{printf("%.2f"), $5}' | sed 's/%//')
if (( $(echo "$disk_usage >= 60" | bc -l) )); then
    echo "Not Healthy"
else
    echo "Healthy"
fi

# Main script logic
cpu_status=$(check_cpu)
mem_status=$(check_memory)
disk_status=$(check_disk)

if [ "$cpu_status" == "Healthy" ] && [ "$mem_status" == "Healthy" ] && [ "$disk_status" == "Healthy" ]; then
    echo "Healthy"
else
    echo "Not Healthy"
fi

# Explain mode
case $1 in
    explain)
        echo "CPU Utilization: $(check_cpu) %"
        echo "Memory Utilization: $(check_memory) %"
        echo "Disk Utilization: $(check_disk) %"
        if [ "$cpu_status" == "Healthy" ] && [ "$mem_status" == "Healthy" ] && [ "$disk_status" == "Healthy" ]; then
            echo "The VM is Healthy because all resource usages are below 60%."
        else
            echo "The VM is Not Healthy because at least one resource usage is 60% or above."
        fi
        ;;
    *)
        ;;
esac