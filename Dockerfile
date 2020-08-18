FROM ubuntu:20.04

ARG username=test

RUN apt-get update && \ 
  apt-get install -y openssh-server \
  apache2-utils \
  dnsutils \
  apache2-utils \
  dnsutils \
  telnet \
  ftp-ssl \
  curl \
  ethtool \
  iperf3 \
  iputils-ping \
  jq \
  lftp \
  mtr \
  netcat \
  net-tools \
  nmap \
  openssh-client \
  openssl \
  postgresql-client \
  rsync \
  socat \
  tcpdump \
  #tshark \
  wget

# Overwrite the message of the day
RUN chmod -x /etc/update-motd.d/* && \
  rm /etc/legal
COPY motd /etc/motd

# Create the SSH user
RUN useradd --create-home $username
RUN mkdir /opt/ssh_network_tool && \
  echo $username > /opt/ssh_network_tool/username && \
  mkdir /home/${username}/.ssh -m 700

# SSH configuration
ENV NOTVISIBLE "in users profile"
RUN mkdir /var/run/sshd && \
  sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \
  echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
  echo "export VISIBLE=now" >> /etc/profile

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22
CMD ["/usr/local/bin/entrypoint.sh"]
