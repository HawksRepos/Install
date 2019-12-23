#!/bin/bash
###############################################################################
# Title: PTS Base installer
# Coder : 	MrDoob PTS Main Developer
# GNU: General Public License v3.0E
#
################################################################################
### FUNCTIONS START #####################################################
###################################
existpg() {
file="/opt/plexguide/menu/pg.yml"
  if [[ -f $file ]]; then
	overwrittingpg
  else nopg ; fi
}

overwrittingpg() {
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ We found an existing PG/PTS installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ Y ] Yes, I want a clean PTS installation.
     ( this create a backup from 2 folders )

[ N ] No, I want to keep my PG/PTS installation 
     ( this breaks the install )

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[ Z ] EXIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
  read -p '↘️  Type Y | N or Z | Press [ENTER]: ' typed </dev/tty

  case $typed in
    Y) ovpgex ;;
	y) ovpgex ;;
	N) nope ;;
	n) nope ;;
    z) exit 0 ;;
    Z) exit 0 ;;
    *) badinput1 ;;
  esac
}

nopg() {
 base && repo && packlist && editionpts && value && endingnonexist
}

ovpgex() {
 backupex && base && repo && packlist && editionpts && value && endingexist
}

nope() {
 echo
  exit 0
}

doneokay() {
 echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
}

backupex() {
  mkdir -p /var/backup-pg/
  tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /opt/plexguide -cf /var/backup-pg/plexguide-old.tar.gz ./
  tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /var/plexguide -cf /var/backup-pg/var-plexguide-old.tar.gz ./
	
printfiles=$(ls -ah /var/backup-pg/ | grep -E 'plex')
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ Backup existing PG / PTS installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
We made a backup of an existing PG / PTS installation for you

$printfiles
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
doneokay
}

badinput1() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
  overwrittingpg
}
### FUNCTIONS END #####################################################
### everything after this line belongs to the installer
### INSTALLER FUNCTIONS START #####################################################
mainstart() {
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  INSTALLING: PTS Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
By installing, you agreeing to the terms and conditions of the GNUv3 License!

Everyone is welcome and everyone can help make it better,
so we like to greet you as a new / old user

		┌─────────────────────────────────────┐
		│                                     │
		│ Thanks to:                          │
		│                                     │
		│ Davaz, Deiteq, FlickerRate,         │
		│ ClownFused, MrDoob, Sub7Seven,      │
		│ TimeKills, The_Creator, Desimaniac, │
		│ l3uddz, RXWatcher, Calmcacil,       │
		│ ΔLPHΔ , Maikash , Porkie            │
		│ CDN_RAGE , hawkinzzz                │
		│ BugHunter : Krallenkiller           │
		│                                     │
		│ and all other guys                  │
		│                                     │
		│ @TheShadow you are welcome          │
		└─────────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
sleep 0.5
}

##############################
sudocheck() {
  if [[ $EUID -ne 0 ]]; then
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
    exit 0
  fi
}

base() {
##check for open port ( apache and Nginx test )
base_list="lsof lsb-release software-properties-common"

apt-get install $base_list -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Check for existing Webserver is running - Standby
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
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
else echo "" ; fi
  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED ! Check for existing Webserver is done !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Base install - Standby  || this can take some minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
versioncheck=$(cat /etc/*-release | grep "Ubuntu" | grep -E '19')
  if [ "$versioncheck" == "19" ]; then
      printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Argggggg ......  System OS Warning! 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Supported: UBUNTU 16.xx - 18.10 ~ LTS/SERVER and Debian 9.*

This server may not be supported due to having the incorrect OS detected!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
  exit 0
  else echo "" ; fi
}
######################
repo() {
# add repo
rm -f /var/log/osname.log 
touch /var/log/osname.log 
echo -e "$(lsb_release -si)" >/var/log/osname.log

if [[ $(lsb_release -si) == "Debian" ]]; then
	add-apt-repository main >/dev/null 2>&1
	add-apt-repository non-free >/dev/null 2>&1
	add-apt-repository contrib >/dev/null 2>&1
	wget -qN https://raw.githubusercontent.com/PTS-Team/Install/master/source/ansible-debian-ansible.list /etc/apt/sources.list.d/
elif [[ $(lsb_release -si) == "Ubuntu" ]]; then
	add-apt-repository main >/dev/null 2>&1
	add-apt-repository universe >/dev/null 2>&1
	add-apt-repository restricted >/dev/null 2>&1
	add-apt-repository multiverse >/dev/null 2>&1
    apt-add-repository --yes --update ppa:ansible/ansible >/dev/null 2>&1
elif [[ $(lsb_release -si) == "Rasbian" || $(lsb_release -si) == "Fedora" || $(lsb_release -si) == "CentOS" ]]; then
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Argggggg ......  System Warning! 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Supported: UBUNTU 16.xx - 18.10 ~ LTS/SERVER and Debian 9.*

This server may not be supported due to having the incorrect OS detected!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
  exit 0
fi
}
##############################
packlist() {
package_list="curl wget software-properties-common git zip unzip dialog sudo nano htop mc lshw ansible fortune intel-gpu-tools python-apt lolcat figlet"
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
apt-get purge unattended-upgrades -yqq >/dev/null 2>&1
	export DEBIAN_FRONTEND=noninteractive
	
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED Update the System - finish
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
} 

editionpts() {
# Delete If it Exist for Cloning
if [ -e "/opt/plexguide" ]; then rm -rf /opt/plexguide; fi
if [ -e "/opt/pgstage" ]; then rm -rf /opt/pgstage; fi
rm -rf /opt/pgstage/place.holder >/dev/null 2>&1

##fast change the editions 
edition=master
##fast change the editions
git clone -b $edition --single-branch https://github.com/PTS-Team/Install.git /opt/pgstage 1>/dev/null 2>&1
git clone https://github.com/PTS-Team/PTS-Update.git /opt/ptsupdate 1>/dev/null 2>&1

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
pip install --upgrade pip 1>/dev/null 2>&1
echo "PIP updated"

ansible-playbook /opt/pgstage/folders/folder.yml
ansible-playbook /opt/pgstage/clone.yml
ansible-playbook /opt/plexguide/menu/alias/alias.yml
ansible-playbook /opt/plexguide/menu/motd/motd.yml
ansible-playbook /opt/plexguide/menu/pg.yml --tags journal,system,rcloneinstall,mergerfsinstall,update
}

value() {
if [ -e "/bin/pts" ]; then
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Verifiying PTS Install @ /bin/pts - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
else
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  WARNING! Installed Failed! PTS Installer Failed !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
We are happy to do this for you again automatically
We are doing this to ensure that your installation continues to work!
Please wait one moment, while PTS now checks and set everything up for you!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
    read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
    sudocheck && base && repo && packlist && editionpts && value && ending
fi
}

endingnonexist() {
logfile=/var/log/log-install.txt
chk=$(figlet "<<< P T S - TEAM >>>" | lolcat)
touch /var/plexguide/new.install 
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$chk

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ PASSED ! PTS-Team is now Installed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED ! Operations System    : $(lsb_release -sd)
✅ PASSED ! Processor            : $(lshw -class processor | grep "product" | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')
✅ PASSED ! CPUs                 : $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk  '{print $2}')
✅ PASSED ! IP from Server       : $(hostname -I | awk '{print $1}')
✅ PASSED ! HDD Space            : $(df -h / --total --local -x tmpfs | grep 'total' | awk '{print $2}')
✅ PASSED ! RAM Space            : $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
✅ PASSED ! Logfile              : $logfile
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start AnyTime By Typing >>> pts [or] plexguide [or] pgblitz
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Want to add an USER with UID 1000 then type ptsadd
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
echo ""
}

endingexist() {
logfile=/var/log/log-install.txt
chk=$(figlet "<<< P T S - TEAM >>>" | lolcat)
touch /var/plexguide/new.install 
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$chk

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ PASSED ! PTS-Team is now Installed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PASSED ! Operations System    : $(lsb_release -sd)
✅ PASSED ! Processor            : $(lshw -class processor | grep "product" | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')
✅ PASSED ! CPUs                 : $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk  '{print $2}')
✅ PASSED ! IP from Server       : $(hostname -I | awk '{print $1}')
✅ PASSED ! HDD Space            : $(df -h / --total --local -x tmpfs | grep 'total' | awk '{print $2}')
✅ PASSED ! RAM Space            : $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
✅ PASSED ! PG/PTS Backup        : /var/backup-pg/
✅ PASSED ! Logfile              : $logfile
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start AnyTime By Typing >>> pts [or] plexguide [or] pgblitz
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Want to add an USER with UID 1000 then type ptsadd
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
echo ""
}

### INSTALLER FUNCTIONS END #####################################################

 #### function layout for order one by one
 
 mainstart
 sudocheck
 existpg
