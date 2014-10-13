# TO DO implement sudo in the script
# TO DO install bash and make default shell

# install all required packages
sudo pkg_add -I git postgresql-server bash node libxml2 libxslt

sudo -u _postgresql mkdir /var/postgresql/data
sudo -u _postgresql initdb -D /var/postgresql/data -U postgres -E UTF8
sudo sh -c "echo 'pkg_scripts="postgresql"' >> /etc/rc.conf.local"
sudo /etc/rc.d/postgresql start


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
bundle config build.nokogiri --use-system-libraries
bundle install --without production

# setup the osra database
bundle exec rake db:setup
