#!/bin/bash

# Copy the SSH public key to the user created in the Docker image
USERNAME=$(</opt/ssh_network_tool/username)
cp /opt/ssh_network_tools/keys/public_key /home/${USERNAME}/.ssh/authorized_keys
chmod 600 /home/${USERNAME}/.ssh/authorized_keys
chown ${USERNAME}: -R /home/${USERNAME}/.ssh

# Start sshd
/usr/sbin/sshd -D
