#!/bin/bash



# Print help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 <username> <password> [ip_range]"
    echo -e "\nArguments:"
    echo "  <username>   SSH username to use for login attempts."
    echo "  <password>   SSH password to use for login attempts."
    echo "  [ip_range]   Optional. IP range to scan (default: uses local subnet or 192.168.20.0/24)."
    echo -e "\nExample:"
    echo "  $0 jetson yahboom 192.168.1.0/24"
    exit 0
fi

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <username> <password> [ip_range]"
    exit 1
fi


# Set SSH password and username from arguments
USERNAME="$1"
export SSHPASS="$2"

# If IP range is provided, use it. Otherwise, try to detect local subnet.
if [ -n "$3" ]; then
    IP_RANGE="$3"
else
    # Try to detect local IP and subnet mask
    # Use 'ip' if available, fallback to 'ifconfig'
    if command -v ip >/dev/null 2>&1; then
        # Get the first non-loopback IPv4 address and subnet
        IP_INFO=$(ip -4 addr show scope global | awk '/inet / {print $2; exit}')
    elif command -v ifconfig >/dev/null 2>&1; then
        IP_INFO=$(ifconfig | awk '/inet / && $2 != "127.0.0.1" {print $2"/"$4; exit}' | sed 's/addr://;s/Mask://')
    else
        IP_INFO=""
    fi

    if [ -n "$IP_INFO" ]; then
        IP_RANGE="$IP_INFO"
    else
        IP_RANGE="192.168.20.0/24"
    fi
fi

echo "Scan for hosts with port 22 open in range $IP_RANGE"
HOSTS=$(nmap -p 22 --open -oG - "$IP_RANGE" | awk '/22\/open/ {print $2}')

# Print found hosts
echo -e "Found SSH hosts:\n$HOSTS"


# Try to login to each found host and collect successful IPs
SUCCESSFUL_IPS=()
for ip in $HOSTS; do
    echo "Trying SSH login to $ip..."
    sshpass -e ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$USERNAME"@$ip exit
    if [ $? -eq 0 ]; then
        echo "Login successful: $ip"
        SUCCESSFUL_IPS+=("$ip")
    else
        echo "Login failed: $ip"
    fi
done

# Print out successful IPs
if [ ${#SUCCESSFUL_IPS[@]} -gt 0 ]; then
	echo -e "\nSuccessfully logged in to the following IPs:"
	for ip in "${SUCCESSFUL_IPS[@]}"; do
		echo "$USERNAME@$ip"
	done
else
	echo -e "\nNo successful logins!!!"
fi
