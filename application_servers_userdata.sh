#!/bin/bash

# Update package lists
sudo apt update -y

# Install necessary packages
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the Docker stable repository
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package lists again
sudo apt update -y

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add the current user to the Docker group
sudo usermod -aG docker ${USER} # ${USER} | $USER both will work fine. But, using ${USER} can be a good habit to get into, 
                                # especially in more complex scripts where variable names might be adjacent to other characters.

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker
