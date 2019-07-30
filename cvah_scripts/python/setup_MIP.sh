timedatectl set-local-rtc yes
timedatectl set-ntp yes
timedatectl set-timezone America/Chicago
mkdir /data
mount 10.11.4.198:/data /data
cd /
ln -s /data/CM/configManagement/ /cm

