#!/bin/bash

echo "===================================="
echo "      LINUX SERVER HEALTH CHECK"
echo "===================================="
echo "Hostname : $(hostname)"
echo "Date     : $(date)"
echo

# 1. CPU CHECK
echo "----- CPU CHECK -----"
if [ -r /proc/loadavg ]; then
    echo "Load Average (1, 5, 15 min): $(awk '{print $1, $2, $3}' /proc/loadavg)"
else
    echo "CPU load information unavailable"
fi
echo

# 2. MEMORY CHECK
echo "----- MEMORY CHECK -----"
if command -v free >/dev/null 2>&1; then
    free -h
elif [ -r /proc/meminfo ]; then
    awk '/MemTotal:/ {total=$2}
         /MemAvailable:/ {available=$2}
         END {
             if (total > 0 && available > 0)
                 printf "Total: %.0f MB, Available: %.0f MB\n",
                        total/1024, available/1024
             else
                 print "Memory information available in /proc/meminfo"
         }' /proc/meminfo
else
    echo "Memory information unavailable"
fi
echo

# 3. DISK CHECK
echo "----- DISK CHECK -----"
df -P -h
echo

# 4. NETWORK CHECK
echo "----- NETWORK CHECK -----"
if command -v ip >/dev/null 2>&1; then
    ip addr show
    echo
    echo "Default Route:"
    ip route 2>/dev/null | awk '/default/ {print; found=1}
        END {if (!found) print "No default route found"}'
elif command -v ifconfig >/dev/null 2>&1; then
    ifconfig -a
else
    echo "Network interface information unavailable"
fi
echo

# 5. SERVICE CHECK
echo "----- SERVICE CHECK -----"

check_service() {
    service_name="$1"

    if command -v systemctl >/dev/null 2>&1; then
        status=$(systemctl is-active "$service_name" 2>/dev/null)
        echo "$service_name : ${status:-unknown}"
    elif command -v service >/dev/null 2>&1; then
        if service "$service_name" status >/dev/null 2>&1; then
            echo "$service_name : running"
        else
            echo "$service_name : stopped or status unavailable"
        fi
    else
        echo "$service_name : service manager unavailable"
    fi
}

# Adjust these service names for your Linux distribution.
check_service sshd
check_service cron
check_service crond
echo

# 6. UPTIME CHECK
echo "----- UPTIME CHECK -----"
if command -v uptime >/dev/null 2>&1; then
    uptime
elif [ -r /proc/uptime ]; then
    awk '{printf "Uptime: %.2f hours\n", $1/3600}' /proc/uptime
else
    echo "Uptime information unavailable"
fi

echo
echo "===================================="
echo "       HEALTH CHECK COMPLETED"
echo "===================================="
