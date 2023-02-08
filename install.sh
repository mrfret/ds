#!/bin/bash
################################################################################
# Title: DS
# Coder :
# GNU: General Public License v3.0E
#
################################################################################

if [[ $EUID -ne 0 ]];then
printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You must execute as a SUDO user or as ROOT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
exit 0
fi

function log() {
   echo "[INSTALL] DS ${1}"
}

[[ ! -d "/opt/ds" ]] && mkdir -p /opt/ds

file=/opt/ds/ds
store=/usr/bin/ds
ds=/opt/ds

git clone https://github.com/mrfret/ds.git /opt/ds 1>/dev/null 2>&1

if test -f "/usr/bin/ds"; then $(which rm) /usr/bin/ds ; fi
if [[ $EUID != 0 ]]; then
    $(which chown) -R $(whoami):$(whoami) /opt/ds
    $(which usermod) -aG sudo $(whoami)
    cp /opt/ds/apps.sh ./apps.sh
    chmod +x ~./apps.sh
    $(which chown) $(whoami):$(whoami) ~./apps.sh
else 
    $(which chown) -R 1000:1000 /opt/ds
    cp /opt/ds/apps.sh ./apps.sh
    chmod +x ./apps.sh
	chmod +x /opt/ds/*.sh
    $(which chown) -R 1000:1000 ./apps.sh
fi

#EOF#
