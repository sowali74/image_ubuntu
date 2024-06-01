# Utiliser une image de base avec l'OS souhaité (e.g., Ubuntu)
FROM ubuntu:latest

# Installer SSH server et les outils nécessaires
RUN apt-get update && apt-get install -y openssh-server ca-certificates curl gnupg lsb-release sudo

# Installer Docker et Docker Compose
RUN apt-get update && apt-get install -y apt-transport-https software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

# Installer supervisord pour gérer plusieurs services
RUN apt-get update && apt-get install -y supervisor

# Créer un utilisateur SSH
RUN useradd -rm -d /home/test -s /bin/bash -g root -G sudo -u 1001 test

# Définir le mot de passe de l'utilisateur SSH (remplacez "password" par le mot de passe souhaité)
RUN echo 'test:test' | chpasswd

# Configurer SSH
RUN mkdir /var/run/sshd

# Créer un fichier de configuration pour supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Exposer le port SSH
EXPOSE 22

# Exposer d'autres ports
EXPOSE 8080 9000 50000 5432 5000

# Ajouter l'utilisateur au groupe Docker
RUN usermod -aG docker test

# Démarrer supervisord pour gérer les services
CMD ["/usr/bin/supervisord"]
