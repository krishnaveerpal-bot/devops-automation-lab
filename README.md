# Linux Server Health Checker

A Bash script that checks basic Linux server health.

## Features
- CPU load average
- Memory information
- Disk filesystem usage
- Network interfaces and default route
- Selected service status
- Server uptime

## Requirements
- Bash
- Standard Linux utilities
- Optional: ip, ifconfig, free, systemctl

## Usage

Make the script executable:

    chmod +x server_health_checker.sh

Run the health checker:

    ./server_health_checker.sh

## Project Structure

    devops-automation-lab/
    ├── server_health_checker.sh
    └── README.md
