#!/bin/bash
set -e

echo $SSH_CLIENT

# default env vars
_USER=${USER:-user}
_UID=${UID:-1000}
_GID=${GID:-1000}
_HOME=${HOME:-/home/$_USER}
_SHELL=${SHELL:-/bin/bash}
_CMD=${@:-$SHELL}

# Disable root login
if [ "$_USER" = "root" ] ; then _USER=user ; fi
if [ "$_UID" = "0" ] ; then _UID=1000 ; fi
if [ "$_GID" = "0" ] ; then _GID=1000 ; fi
if [ "$_HOME" = "/root" ] ; then _HOME=/home/$_USER ; fi

# Set the locale to utf8
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Create user, group and allow sudo without password
if [ -z $(awk -F: -v U="${_GID}" '$3==U {print "1";exit}' /etc/group) ] ; then
    groupadd -g "${_GID}" "${_USER}"
fi
if [ -z $(awk -F: -v U="${_UID}" '$3==U {print "1";exit}' /etc/passwd) ] ; then
    useradd -d "${_HOME}" -g "${_USER}" -G sudo,dialout,tty,video -s "${_SHELL}" -u "${_UID}" "${_USER}"
fi
echo "${_USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${_USER}"
chmod 0440 "/etc/sudoers.d/${_USER}"
mkdir -p "${_HOME}"
chown "${_USER}:${_USER}" "${_HOME}"

# Put dynamic hostname into /etc/hosts to remove sudo warnings
echo "127.0.0.1	`hostname`.localdomain	`hostname`" >> /etc/hosts

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

# Exec CMD or docker run parameter
exec sudo -iu ${_USER} ${_CMD}
