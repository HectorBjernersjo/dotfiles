import psutil
import time

def get_disk_read_rate(interval=1):
    # Retrieve current disk IO stats
    disk_io_start = psutil.disk_io_counters()
    current_read_start = disk_io_start.read_bytes

    # Wait for the specified interval
    time.sleep(interval)

    # Get new disk IO stats after waiting
    disk_io_end = psutil.disk_io_counters()
    current_read_end = disk_io_end.read_bytes

    # Calculate read rate in MB/s
    read_rate = (current_read_end - current_read_start) / (1024 ** 2 * interval)

    return read_rate

# Get disk read rate
read_rate = get_disk_read_rate()

# Print the read rate
print(f"{read_rate:.1f} MB/s")
