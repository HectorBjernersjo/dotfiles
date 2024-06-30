import psutil
import time

def get_disk_io_rate(previous_read, previous_write, interval=1):
    # Retrieve current disk IO stats
    disk_io_start = psutil.disk_io_counters()
    current_read_start = disk_io_start.read_bytes
    current_write_start = disk_io_start.write_bytes

    # Wait for the specified interval
    time.sleep(interval)

    # Get new disk IO stats after waiting
    disk_io_end = psutil.disk_io_counters()
    current_read_end = disk_io_end.read_bytes
    current_write_end = disk_io_end.write_bytes

    # Calculate read and write rates in MB/s
    read_rate = (current_read_end - current_read_start) / (1024 ** 2 * interval)
    write_rate = (current_write_end - current_write_start) / (1024 ** 2 * interval)

    return read_rate, write_rate

# Initial values to start comparison
initial_disk_io = psutil.disk_io_counters()
initial_read = initial_disk_io.read_bytes
initial_write = initial_disk_io.write_bytes

# Get disk read and write rates
read_rate, write_rate = get_disk_io_rate(initial_read, initial_write)

# Print the rates
print(f"R: {read_rate:.2f} MB/s W: {write_rate:.2f} MB/s")
# print(f"W: {write_rate:.2f} MB/s")

