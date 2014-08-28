#install sudo
su -m root -c 'pkg install -y sudo'
su -m root -c 'sed -i -e s/\#\ %wheel\ ALL=\(ALL\)\ ALL/%wheel\ ALL=\(ALL\)\ ALL/g /usr/local/etc/sudoers'

#install required packages
sudo pkg install -y postgresql93-server git node bash
sudo chsh -s bash $(whoami)

# setup postgres
sudo sh -c "echo 'postgresql_enable="YES"' >> /etc/rc.conf"
sudo /usr/local/etc/rc.d/postgresql initdb

#reboot for changes
sudo reboot


