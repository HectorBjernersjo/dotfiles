#!/bin/python3
import psutil

# Get memory details
memory = psutil.virtual_memory()

# Calculate percentages
total_memory = memory.total / (1024 ** 3)  # Convert from bytes to GB
used_memory = memory.used / (1024 ** 3)
available_memory = memory.available / (1024 ** 3)

# print(f"{used_memory:.2f}/{total_memory:.2f} GB")
print(f"{used_memory:.1f} GB")

# # Print memory usage
# print(f"Total RAM: {total_memory:.2f} GB")
# print(f"Used RAM: {used_memory:.2f} GB ({memory.percent}%)")
# print(f"Available RAM: {available_memory:.2f} GB")
#
