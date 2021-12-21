#!/bin/bash

# ps h --ppid $1 -o pid
#!/bin/env bash

display_cpid() {
    local depth=$1 pid=$2 child_pid
    (( ++depth ))
    while IFS= read -r child_pid; do
        if (( depth < 2 )); then
            display_cpid "$depth" "$child_pid"
        else
            echo "$child_pid"
        fi
    done < <(pgrep -P "$pid" | xargs)
}

display_cpid 0 "$1"