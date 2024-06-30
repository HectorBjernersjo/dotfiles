import os
import subprocess
from humanize import naturalsize
from collections import namedtuple
import argparse

def dir_stats():
    # Calculate size of the current directory
    current_dir_size = int(subprocess.check_output(['du', '-s', '.']).split()[0])
    current_dir_human_size = naturalsize(current_dir_size * 1024)
    current_dir_count = sum(len(files) for _, _, files in os.walk('.'))
    print(f"{current_dir_human_size:<10} {current_dir_count:<6} current directory")
    # print()

    # List all directories in the current directory
    dirs = [x for x in os.listdir('.') if os.path.isdir(x)]

    DirEntry = namedtuple('DirEntry', ['size','human_size', 'count', 'path'])
    results = []
    total_size = 0
    total_count = 0

    # Process each directory
    for dir_path in dirs:  # Limit to first 15 directories
        # Get size of directory
        size = int(subprocess.check_output(['du', '-s', dir_path]).split()[0])
        human_size = naturalsize(size * 1024)  # Convert size to bytes for humanize

        # Count total files recursively
        count = sum(len(files) for _, _, files in os.walk(dir_path))


        results.append(DirEntry(size, human_size, count, dir_path))

    # Sort results by size in reverse order and print
    results.sort(key=lambda x: int(subprocess.check_output(['du', '-s', x.path]).split()[0]), reverse=True)
    for entry in results[:display_max]:
        total_size += entry.size
        total_count += entry.count
        print(f"{entry.human_size:<10} {entry.count:<6} {entry.path}")

    # Calculate the size of other files and directories outside the top 15
    other_size = current_dir_size - total_size
    other_size_human = naturalsize(other_size * 1024)
    other_count = current_dir_count - total_count
    count = sum(len(files) for _, _, files in os.walk('.')) - sum(x.count for x in results)
    # print()
    print(f"{other_size_human:<10} {other_count:<6} Other")

def file_stats():
    # List all files in the current directory
    files = [f for f in os.listdir('.') if os.path.isfile(f)]

    FileEntry = namedtuple('FileEntry', ['size','human_size', 'path'])
    results = []
    total_size = 0

    # Process each file
    for file_path in files:
        # Get size of file
        size = os.path.getsize(file_path)
        human_size = naturalsize(size)  # Convert size to human-readable format

        total_size += size
        results.append(FileEntry(size, human_size, file_path))


    total_size_human = naturalsize(total_size)
    print(f"{total_size_human:<10} Total")
    # Sort results by size in reverse order and print
    results.sort(key=lambda x: os.path.getsize(x.path), reverse=True)
    other_size = 0

    for entry in results[:display_max]:
        other_size += entry.size
        print(f"{entry.human_size:<10} {entry.path}")

    # Print total size of all files
    other_size = total_size - other_size
    other_size_human = naturalsize(other_size)
    print(f"{other_size_human:<10} Other")

def main():
    global display_max
    parser = argparse.ArgumentParser(description="Display stats for directories and/or files")
    parser.add_argument('-f', '--files', action='store_true', help='Display file statistics only')
    parser.add_argument('-d', '--dirs', action='store_true', help='Display directory statistics only')
    parser.add_argument('-m', '--max', type=int, help='Maximum number of directories or files to display, default 10', default=10)

    args = parser.parse_args()

    if args.max:
        display_max = args.max

    if args.files and not args.dirs:
        file_stats()
    elif args.dirs and not args.files:
        dir_stats()
    elif args.files and args.dirs:
        print("Directory Stats:")
        dir_stats()
        print()
        print("File Stats:")
        file_stats()
    else:
        dir_stats()

if __name__ == '__main__':
    main()
