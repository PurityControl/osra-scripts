#setup postgres user
sudo -u pgsql createuser -s postgres

#install rvm
\curl -sSL https://get.rvm.io | bash -s stable
. ~/.rvm/scripts/rvm
rvm requirements run

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
