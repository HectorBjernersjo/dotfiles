function dir_stats
    
    if not set -q argv[1]
        echo "current dir:"
        dir_stats .
        echo "subdirs: "
        dir_stats *
    end

    set results # Variable to hold the results for later sorting
    set total_size 0 # Initialize total size

    for dir in $argv
        if test -d $dir  # Check if the argument is a directory
            set size (du -s $dir | awk '{print $1}')  # Get the size of the directory in blocks
            set human_size (du -sh $dir | awk '{print $1}')  # Get the human-readable size of the directory
            set count (find $dir -type f | wc -l)  # Count the number of files
            set results $results "$human_size $count $dir"
            set total_size (math $total_size + $size) # Add the directory's size to the total
        end
    end

    # Convert the total size to a human-readable format at the end
    # Convert the total size to a dynamically appropriate human-readable format
    set total_size_human (echo $total_size | awk '{
        split("K M G T", type);
        for(i=1; $1>=1024 && i<5; i++)
            $1/=1024;
        printf "%.1f%s", $1, type[i]
    }')

    # Now, sort the results by size in reverse order and format them into a table
    for line in (printf "%s\n" $results | sort -hr)
        set -l parts (string split " " $line)
        printf "%-10s %-6s %s\n" $parts[1] $parts[2] $parts[3]
    end
    
    if test (count $argv) -gt 1
        echo "Total disk space used by files: $total_size_human"
    end
end

