FROM ubuntu:20.04

ARG username=test
ARG password=secret

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
RUN chmod -x /etc/update-motd.d/* && rm /etc/legal
COPY motd /etc/motd

# Create the SSH user
RUN useradd --create-home $username
RUN echo "${username}:${password}" | chpasswd

# SSH login fix. Otherwise user is kicked off after login
RUN mkdir /var/run/sshd
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
