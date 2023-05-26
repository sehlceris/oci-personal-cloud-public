#!/bin/bash

echo "Starting maintenance script $(date)"

# Update package lists for upgrades for packages that need upgrading
echo "Starting package list update..."
sudo apt-get update

# Upgrade all upgradable packages
echo "Starting package upgrade..."
sudo apt-get upgrade -y

# Auto remove any unnecessary packages
echo "Starting auto remove of unnecessary packages..."
sudo apt-get autoremove -y

# Clean up any unnecessary files, old downloaded archive files 
echo "Starting clean up of unnecessary files..."
sudo apt-get clean

# Check for failed system services
echo "Checking for failed system services..."
systemctl --failed

# Check disk usage of the server
echo "Checking disk usage..."
df -h

# Update Docker service images
echo "Updating Docker services images..."
cd ~/docker-services && docker-compose pull

echo "Finished maintenance script $(date)"
