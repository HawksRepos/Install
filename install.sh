#!/bin/bash
###############################################################################
# Title: PTS Base installer
# Coder : 	MrDoob - freelance Coder | ammj93 | prodengineer pr00f
# GNU: General Public License v3.0E
#
################################################################################
#function
logfile=/var/log/log-install.txt
package_list="curl wget software-properties-common git zip unzip dialog sudo nano htop mc lshw ansible fortune intel-gpu-tools python-apt"

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  INSTALLING: PTS Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
By installing, you agreeing to the terms and conditions of the GNUv3 License!

We don't want to make money or an big ego, so go away or hate me ^^

		┌─────────────────────────────────────┐
		│                                     │
		│ Thanks to:                          │
		│                                     │
		│ Davaz, Deiteq, FlickerRate,         │
		│ ClownFused, MrDoob, Sub7Seven,      │
		│ TimeKills, The_Creator, Desimaniac, │
		│ l3uddz, RXWatcher,Calmcacil, Porkie │
		│                                     │
		│ and all other guys                  │
		│                                     │
		│ @TheShadow you are welcome          │	
		└─────────────────────────────────────┘
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
#check it is being run as root
if [ "$(id -u)" != "0" ]; then
  	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo ""
	echo " ⛔ Warning! "
	echo " ⛔ Warning! insufficient permission "
	echo " ⛔ Warning! "
	echo ""
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && exit 1
fi
##check for open port ( apache and Nginx test )
apt-get install lsof -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Check for existing Webserver is running - Standby
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        service apache2 stop >/dev/null 2>&1
        service nginx stop >/dev/null 2>&1
        apt-get purge apache nginx -yqq >/dev/null 2>&1
        apt-get autoremove -yqq >/dev/null 2>&1
        apt-get autoclean -yqq >/dev/null 2>&1
elif lsof -Pi :443 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        service apache2 stop >/dev/null 2>&1
        service nginx stop >/dev/null 2>&1
        apt-get purge apache nginx -yqq >/dev/null 2>&1
        apt-get autoremove -yqq >/dev/null 2>&1
        apt-get autoclean -yqq >/dev/null 2>&1
else
        echo "Good no service runs on port 80 & 443"
fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED ! Check for existing Webserver is done !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 5
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Base install - Standby  || this can take some minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
apt-get install lsb-release -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
apt-get install software-properties-common -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive

fullrel=$(lsb_release -sd)
osname=$(lsb_release -si)
relno=$(lsb_release -sr)
relno=$(printf "%.0f\n" "$relno")
hostname=$(hostname -I | awk '{print $1}')

# add repo
touch /var/log/osname.log 
echo $osname >> /var/log/osname.log
oo=$(tail -n 1 /var/log/osname.log)

if [ $oo == "Debian" ]; then
	add-apt-repository main >/dev/null 2>&1
	add-apt-repository non-free >/dev/null 2>&1
	add-apt-repository contrib >/dev/null 2>&1
	wget -qN https://raw.githubusercontent.com/MrDoobPG/Install/master/source/ansible-debian-ansible.list /etc/apt/sources.list.d/
elif [ $oo == "Ubuntu" ]; then
	add-apt-repository main >/dev/null 2>&1
	add-apt-repository universe >/dev/null 2>&1
	add-apt-repository restricted >/dev/null 2>&1
	add-apt-repository multiverse >/dev/null 2>&1
        apt-add-repository --yes --update ppa:ansible/ansible >> /dev/null
elif [ $oo  == "Rasbian" || "Fedora" || "CentOS" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Argggggg ......  System Warning! 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Supported: UBUNTU 16.xx - 18.10 ~ LTS/SERVER and Debian 9.* / 10

This server may not be supported due to having the incorrect OS detected!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 2
fi
apt-get update -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
apt-get upgrade -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
apt-get dist-upgrade -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
apt-get autoremove -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
apt-get install $package_list -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED Update the System - finish
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 5

# Delete If it Exist for Cloning
if [ -e "/opt/plexguide" ]; then rm -rf /opt/plexguide; fi
if [ -e "/opt/pgstage" ]; then rm -rf /opt/pgstage; fi
rm -rf /opt/pgstage/place.holder >/dev/null 2>&1

##fast change the editions 
edition=master
##fast change the editions
git clone -b $edition --single-branch https://github.com/MrDoobPG/Install.git /opt/pgstage 1>/dev/null 2>&1

mkdir -p /var/plexguide/logs
echo "" >/var/plexguide/server.ports
echo "51" >/var/plexguide/pg.pythonstart
touch /var/plexguide/pg.pythonstart.stored
start=$(cat /var/plexguide/pg.pythonstart)
stored=$(cat /var/plexguide/pg.pythonstart.stored)

if [ "$start" != "$stored" ]; then
    bash /opt/pgstage/pyansible.sh 1>/dev/null 2>&1
fi
echo "51" >/var/plexguide/pg.pythonstart.stored

#pip upgrade
pip install --upgrade pip >/dev/null 2>&1
echo "PIP updated"

ansible-playbook /opt/pgstage/clone.yml
ansible-playbook /opt/plexguide/menu/alias/alias.yml
ansible-playbook /opt/plexguide/menu/pg.yml --tags journal,system
ansible-playbook /opt/plexguide/menu/motd/motd.yml
ansible-playbook /opt/pgstage/folders/folder.yml

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Verifiying PTS Install @ /bin/pts - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2

if [ ! -e "/bin/pts" ]; then

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! Installed Failed! PTS Installer Failed !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please reinstall PTS by running the Command Again! 
We are doing this to ensure that your installation continues to work!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
exit
fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ PASSED! The PTS Command Installed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED ! Operations System    : $(lsb_release -sd)
✅ PASSED ! Processor            : $(lshw -class processor | grep "product" | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')
✅ PASSED ! CPUs                 : $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk  '{print $2}')
✅ PASSED ! IP from Server       : $hostname
✅ PASSED ! HDD Space            : $(df -h / --total --local -x tmpfs | grep 'total' | awk '{print $2}')
✅ PASSED ! RAM Space            : $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
✅ PASSED ! Logfile              : $logfile
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
rm -rf /var/plexguide/new.install 1>/dev/null 2>&1
sleep 2

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

↘️  Start AnyTime By Typing >>> pts [or] plexguide [or] pgblitz

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

↘️  Want to add an USER with UID 1000 type
↘️  ptsadd

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
