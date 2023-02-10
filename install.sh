#!/bin/bash
####################################
# All rights reserved.              #
# started from Zero                 #
# Docker owned dockserver           #
# Docker Maintainer dockserver      #
#####################################
#####################################
# THIS DOCKER IS UNDER LICENSE      #
# NO CUSTOMIZING IS ALLOWED         #
# NO REBRANDING IS ALLOWED          #
# NO CODE MIRRORING IS ALLOWED      #
#####################################
# shellcheck disable=SC2086
# shellcheck disable=SC2046

function log() {
   echo "[INSTALL] DS ${1}"
}

updates="update upgrade autoremove autoclean"
for upp in ${updates}; do
    sudo $(command -v apt) $upp -yqq 1>/dev/null 2>&1 && clear
done
unset updates

packages=(curl bc tar git jq pv pigz tzdata rsync)
log "**** install build packages ****" && \
sudo $(command -v apt) install $packages -yqq 1>/dev/null 2>&1 && clear
unset packages

remove=(/bin/ds /usr/bin/ds)
log "**** remove old ds bins ****" && \
sudo $(command -v rm) -rf $remove 1>/dev/null 2>&1 && clear
unset remove

if [ ! $(which docker) ]; then
   $(which curl) -fsSL https://get.docker.com -o /tmp/docker.sh && bash /tmp/docker.sh
   $(which systemctl) reload-or-restart docker.service
fi

if [ ! $(which docker-compose) ]; then
    $(which curl) -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose
    $(which ln) -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    $(which chmod) +x /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

[[ ! -d "/opt/ds" ]] && mkdir -p /opt/ds

git clone https://github.com/mrfret/ds.git /opt/ds 1>/dev/null 2>&1

file=/opt/ds/ds
store=/usr/bin/ds
ds=/opt/ds

if test -f "/usr/bin/ds"; then $(which rm) /usr/bin/ds ; fi
if [[ $EUID != 0 ]]; then
    $(which chown) -R $(whoami):$(whoami) /opt/ds
    $(which usermod) -aG sudo $(whoami)
    cp /opt/ds/ds /usr/bin/ds
    ln -sf /usr/bin/ds /bin/ds
    chmod +x /usr/bin/ds
    $(which chown) $(whoami):$(whoami) /usr/bin/ds 
else 
    $(which chown) -R 1000:1000 /opt/ds
    cp /opt/ds/ds /usr/bin/ds
    ln -sf /usr/bin/ds /bin/ds
    chmod +x /usr/bin/ds
    $(which chown) -R 1000:1000 /usr/bin/ds
fi

printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀    DS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

     run ds
     [ sudo ] ds

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
" 
#EOF#
