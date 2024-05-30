# Use a base image with the desired OS (e.g., Ubuntu, Debian, etc.)
FROM ubuntu:latest

# Install SSH server and required tools
RUN apt-get update && apt-get install -y openssh-server ca-certificates curl gnupg lsb-release sudo

# Install Docker and Docker Compose
RUN apt-get update && apt-get install -y apt-transport-https software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

# Create an SSH user
RUN useradd -rm -d /home/test -s /bin/bash -g root -G sudo -u 1001 test

# Set the SSH user's password (replace "password" with your desired password)
RUN echo 'test:test' | chpasswd

# Allow SSH access
RUN mkdir /var/run/sshd

# Expose the SSH port
EXPOSE 22

# Expose other ports
EXPOSE 8080/tcp
EXPOSE 9000/tcp
EXPOSE 50000/tcp
EXPOSE 5432/tcp
EXPOSE 5000/tcp

# Start Docker daemon on container startup
CMD ["sh", "-c", "/usr/sbin/sshd && dockerd"]
