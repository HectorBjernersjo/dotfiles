#!/bin/python3
import psutil

# Get the percentage of the CPU usage
cpu_usage = psutil.cpu_percent(interval=1)

# Print the CPU usage
print(f"{cpu_usage}%")
