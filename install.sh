#!/bin/bash
###############################################################################
# Title: PTS Base installer
# Coder : 	MrDoob - freelance Coder | ammj93 | prodengineer pr00f
# GNU: General Public License v3.0E
#
################################################################################
#function
logfile=/var/log/log-install.txt
package_list="curl wget software-properties-common git zip unzip dialog sudo nano htop mc lshw ansible cowsay fortune intel-gpu-tools"
##fast change the editions 
edition=master
##fast change the editions

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
		│ l3uddz, RXWatcher,Calmcacli, Porkie │
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
apt-get install lsof -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Check for existing Webserver is running - Standby
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null ; then
        service apache2 stop 2>&1 >> /dev/null
        service nginx stop 2>&1 >> /dev/null
        apt-get purge apache nginx -yqq 2>&1 >> /dev/null
        apt-get autoremove -yqq 2>&1 >> /dev/null
        apt-get autoclean -yqq 2>&1 >> /dev/null
elif lsof -Pi :443 -sTCP:LISTEN -t >/dev/null ; then
        service apache2 stop 2>&1 >> /dev/null
        service nginx stop 2>&1 >> /dev/null
        apt-get purge apache nginx -yqq 2>&1 >> /dev/null
        apt-get autoremove -yqq 2>&1 >> /dev/null
        apt-get autoclean -yqq 2>&1 >> /dev/null
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
apt-get install lsb-release -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get install software-properties-common -yqq 2>&1 >> /dev/null
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
	add-apt-repository main 2>&1 >> /dev/null
	add-apt-repository non-free 2>&1 >> /dev/null
	add-apt-repository contrib 2>&1 >> /dev/null
	wget -qN https://raw.githubusercontent.com/MrDoobPG/Install/master/source/ansible-debian-ansible.list /etc/apt/sources.list.d/
elif [ $oo == "Ubuntu" ]; then
	add-apt-repository main 2>&1 >> /dev/null
	add-apt-repository universe 2>&1 >> /dev/null
	add-apt-repository restricted 2>&1 >> /dev/null
	add-apt-repository multiverse 2>&1 >> /dev/null
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
apt-get update -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get upgrade -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get dist-upgrade -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get autoremove -yqq 2>&1 >> /dev/null
	export DEBIAN_FRONTEND=noninteractive
apt-get install $package_list -yqq 2>&1 >> /dev/null
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
rm -rf /opt/pgstage/place.holder 2>&1 >> /dev/null

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
pip install --upgrade pip 2>&1 >> /dev/null
echo "PIP updated"

ansible-playbook /opt/pgstage/clone.yml 2>&1 >> /dev/null
pts="/opt/plexguide/menu/alias/templates"
cp -rt /bin $pts/*

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

var="/bin/plexguide /bin/pts /bin/pgblitz /bin/ptsadd /bin/ptsupdate"
chmod +x $var
chown 1000:1000 $var

## Other Folders
mkdir -p /opt/appdata/plexguide
mkdir -p /var/plexguide

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

↘️  Start AnyTime By Typing >>> pts [or] plexguide [or] pgblitz

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

↘️  Want to add an USER with UID 1000 type
↘️  ptsadd

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
