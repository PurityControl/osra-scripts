#ask for the sudo password at the start
echo 'about to ask for the sudo password so the script can install some things'
sudo echo 'thankyou continuing with the script...'

#download and install rvm
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable

# load rvm on login
echo '' >> ~/.bash_profile
echo '#source profile for rvm' >> ~/.bash_profile
echo 'source ~/.profile' >> ~/.bash_profile
echo '#setup qmake environment variable' >> ~/.bash_profile
echo 'export QMAKE=/usr/bin/qmake-qt5' >> ~/.bash_profile

#load rvm to run now
. ~/.bash_profile

# install all packages needed to let rvm do its job
rvm requirements run

# install other necessary packages
sudo yum -y install git postgresql-devel postgresql-server xorg-x11-server-Xvfb
sudo yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo
sudo yum -y install nodejs npm qt5-qtwebkit-devel --enablerepo=epel
sudo npm install -g phantomjs

#setup postgres
sudo postgresql-setup initdb
sudo cp /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf.orig
sudo sed -i -e 's/local\s\+all\s\+all\s\+peer/local all postgres trust/g' /var/lib/pgsql/data/pg_hba.conf
sudo service postgresql start

#clone osra and cd into it
git clone https://github.com/AgileVentures/osra.git
cd osra

# install ruby version needed for osra
ruby_ver=`grep ^ruby Gemfile | cut -d ' ' -f 2 | tr -d "'"`
rvm install ruby-$ruby_ver

#install all the gems
rvm use $ruby_ver
gem install bundler
bundle install --without production

# setup the osra database
bundle exec rake db:setup

