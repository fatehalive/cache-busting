#!/bin/bash

# read size log group by minute
awk '
    BEGIN { separators[1] = "["; separators[2] = ":" }
    {
        n = split($1, time_local, separators[1])
        for (i in time_local) {
            if (separators[i] == ":") {
                split(time_local[i], date_time, ":")
            }
        }
        date = date_time[1]; HH = date_time[2]; mm = date_time[3]; ss = date_time[4]
        timestamp = date ":" HH ":" mm
        bytes_sent = $NF
        total_bytes[timestamp] += bytes_sent
        count[timestamp]++
        logs[timestamp] = logs[timestamp] $0 "\n"
    }
    END {
        for (timestamp in total_bytes) {
            total_kb = total_bytes[timestamp] / 1024
            printf "%s[%s] Total Size: %.2f KB Count: %d\n\n", logs[timestamp], timestamp, total_kb, count[timestamp]
        }
    }' "$1"