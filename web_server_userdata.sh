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
sudo usermod -aG docker ${USER} 

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Update package lists again
sudo apt update -y

# Install Apache2
sudo apt install -y apache2

# Create a simple web page
echo "<html>
<h1>Your first web app! </h1>
</html>" | sudo tee /var/www/html/index.html

# Start and enable Apache2
sudo systemctl enable apache2
sudo systemctl start apache2
