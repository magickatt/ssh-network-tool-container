FROM ubuntu:20.04

ARG username=test
ARG password=secret

RUN useradd --create-home $username
RUN echo "${username}:${password}" | chpasswd

RUN chmod -x /etc/update-motd.d/* && rm /etc/legal
COPY motd /etc/motd

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
