import psutil
import time

def get_disk_write_rate(interval=1):
    # Retrieve current disk IO stats
    disk_io_start = psutil.disk_io_counters()
    current_write_start = disk_io_start.write_bytes

    # Wait for the specified interval
    time.sleep(interval)

    # Get new disk IO stats after waiting
    disk_io_end = psutil.disk_io_counters()
    current_write_end = disk_io_end.write_bytes

    # Calculate write rate in MB/s
    write_rate = (current_write_end - current_write_start) / (1024 ** 2 * interval)

    return write_rate

# Get disk write rate
write_rate = get_disk_write_rate()

# Print the write rate
print(f"{write_rate:.1f} MB/s")
