CLONE_GIT_URL=https://github.com/AgileVentures/osra.git
CLONE_DIR_NAME=osra
CLONE_ABS_PATH="/vagrant/$CLONE_DIR_NAME"

function install_rvm {
  # if rvm is installed don't install it again
  # source profile so if installed rvm script is availalble
  . ~/.bash_profile
  which rvm
  if [ $? -ne 0 ]
  then
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
  else
    echo "rvm already installed, skippping ......."
  fi
}

#ask for the sudo password at the start and immediately update the package library
echo 'about to ask for the sudo password so the script can install some things'
sudo echo 'thankyou continuing with the script...'
sudo apt-get update

install_rvm

# install other necessary packages
sudo apt-get install -y  git postgresql-9.3 libpq-dev nodejs nodejs-legacy npm \
     qt4-dev-tools libqt4-dev libqt4-core libqt4-gui xvfb

# only install phantomjs if it isn't already installed
which phantomjs
if [ $? -ne 0 ]
then
  sudo npm install -g phantomjs
else
  echo "phantomjs already installed, skipping ....."
fi

#setup postgres
sudo cp /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf.orig
sudo sed -i -e 's/local\s\+all\s\+postgres\s\+peer/local all postgres trust/g' /etc/postgresql/9.3/main/pg_hba.conf 
sudo service postgresql reload

#clone project and cd into it if the directory isn't there
if [ ! -d  $CLONE_ABS_PATH ]
then
  echo "no $CLONE_DIR_NAME project at $CLONE_ABS_PATH - cloning it now...."
  git clone $CLONE_GIT_URL $CLONE_ABS_PATH
  cd $CLONE_ABS_PATH
  git remote rename origin upstream
  git remote set-url --push upstream "cannot push here ..."
  echo "master project has been renamed to upstream"
  echo "you will need to set origin to your own downstream repoi with ..."
  echo "git remote add origin YOUR_GIT_URL_HERE"
else
  cd $CLONE_ABS_PATH
fi

# install ruby version needed for osra
ruby_ver=`grep ^ruby Gemfile | cut -d ' ' -f 2 | tr -d "'"`
rvm install ruby-$ruby_ver

#install all the gems
rvm use $ruby_ver
gem install bundler
bundle install --without production

# setup the osra database
bundle exec rake db:setup

