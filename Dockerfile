######################################
#
# Psion Drive Mounter
#
# Using a pre-built image for Ubuntu 16.04,
# installs PLP Tools (https://github.com/rrthomas/plptools)
# and also an SFTP server.
#
######################################

FROM ubuntu:16.04
MAINTAINER Daniel Demby <heliomass@gmail.com>

# Update the package sources
RUN apt-get update

# Install basic tools
RUN apt-get --assume-yes install vim net-tools

# Install PLP Tools
RUN apt-get --assume-yes install plptools

# Install OpenSSH for the SFTP server
RUN apt-get --assume-yes install openssh-server

# Configure the mount point for the psion device
RUN mkdir -p /media/psion
RUN chmod a+x /media/psion

# Configure the SFTP server
RUN groupadd ftpaccess
RUN echo 'Match group ftpaccess' >> /etc/ssh/sshd_config
RUN echo 'ChrootDirectory /media/psion' >> /etc/ssh/sshd_config
RUN echo 'X11Forwarding no' >> /etc/ssh/sshd_config
RUN echo 'AllowTcpForwarding no' >> /etc/ssh/sshd_config
RUN echo 'ForceCommand internal-sftp' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN service ssh restart
RUN useradd -m psion -g ftpaccess -s /usr/sbin/nologin
RUN echo 'psion:psion' | chpasswd
RUN chown root /media/psion

# Install the script which will initiate and control the connection
COPY ./start-link /root/start-link
RUN chmod +x /root/start-link
