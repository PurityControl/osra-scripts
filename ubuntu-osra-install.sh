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
sudo apt-get install -y  git postgresql-9.3 libpq-dev nodejs 

#setup postgres
sudo cp /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf.orig
sudo sed -i -e 's/local\s\+all\s\+postgres\s\+peer/local all postgres trust/g' /etc/postgresql/9.3/main/pg_hba.conf 
sudo service postgresql reload

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
bundle exec rake db:test:prepare

