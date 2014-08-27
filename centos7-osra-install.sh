#ask for the sudo password at the start
echo 'about to ask for the sudo password so the script can install some things'
sudo echo 'thankyou continuing with the script...'

#download and install rvm
\curl -sSL https://get.rvm.io | bash -s stable

# load rvm on login
echo '' >> ~/.bash_profile
echo '#source profile for rvm' >> ~/.bash_profile 
echo 'source ~/.profile' >> ~/.bash_profile 

#load rvm to run now
. ~/.bash_profile

# install all packages needed to let rvm do its job
rvm requirements run

# install other necessary packages
sudo yum -y install git postgresql-devel postgresql-server
sudo yum -y install http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm
sudo yum -y install nodejs npm --enablerepo=epel

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
bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed
bundle exec rake db:test:prepare

