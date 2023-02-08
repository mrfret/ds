#!/bin/bash
###############################################################################
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

[[ ! -d "/opt/ds" ]] && mkdir -p /opt/ds
git clone https://github.com/mrfret/ds.git /opt/ds 1>/dev/null 2>&1
ds=/opt/ds

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
