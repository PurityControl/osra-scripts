osra-scripts
============

Broken Scripts
==============
Additional dependencies have temporarily broken the centos and BSD scripts. The only scripts that can
setup the latest osra branches are the ubuntu ones inlcuding the vagrant setups. See the TO DO section.

Installation Instructions
=========================

- Pick the script relevant for your operating system
- source the script
  ```
  source name-of-script.sh
  ```
- sudo will ask you for your password to execute the sudo commands that run in the script. The sudo password is not stored by the script at any point.
- the script should install leaving you with a working osra environment

If you run into difficulty do not panick - go to the osra slack channel and ask for help!

Packages Installed
==================
Each operating system has to have different packages installed but the following packages are required in order to set up the osra environment.

If you do not want any of these packages installed on your system you will need to cherry pick from the script to suit your own needs.

- Bash if not already installed (needed for rvm and to source the script)
- sudo if not already installed
- curl if not already installed (needed to download rvm)
- postgresql
- rvm
- git
- node
- npm
- phantomjs
- qt4 (Dev)
- xvfb

Vagrant
=======
Vagrant files now exist for setting up a fully fledged osra enviroment by downloading the vagrant files
and simpley issuing the `vagrant up` command. Of course to do this you need vagrant and its requirements installed on the machine. See our [wiki page] (https://github.com/PurityControl/osra-scripts/wiki/Vagrant-Installs) for more information.

TO DO
=====

- Add headless javascript driver dependencies for Phantomjs and CapybaraWebkit
  - [x] ubuntu
  - [ ] centos7
  - [ ] freebsd
  - [ ] openbsd
- Make the scripts idempotent (particularly appending to .profile and .bash_profile)
- implement puppet?
- Vagrantfile for vagrant boxes?

