#!/bin/bash

# https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box

# initialize
RUBY_VERSION=2.3.1
GEM_SOURCES=https://gems.ruby-china.org/
export RUBY_BUILD_MIRROR_URL=https://ruby.taobao.org/mirrors/ruby/ruby-$RUBY_VERSION.tar.bz2#
export RUBY_CONFIGURE_OPTS="--disable-install-doc"
export LC_ALL="en_US.UTF-8"
export DEBIAN_FRONTEND=noninteractive

cp /etc/apt/sources.list{,.default}
sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list

apt-get update
echo -e "\e[31;43;1m System update success \e[0m "

# Basic
apt-get -yq install language-pack-en language-pack-zh-hans vim htop screen dstat rsync git-core
echo -e "\e[31;43;1m Basic install success \e[0m "

# Compiling
apt-get -yq install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
echo -e "\e[31;43;1m Compiling install success \e[0m "

# Rbenv
git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
echo '# rbenv setup' >> /etc/profile.d/rbenv.sh
echo 'export RBENV_ROOT=/usr/local/rbenv'  >> /etc/profile.d/rbenv.sh
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
source /etc/profile.d/rbenv.sh
echo -e "\e[31;43;1m Rbenv install success \e[0m "

# Ruby
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
rbenv shell $RUBY_VERSION
rbenv rehash
echo -e "\e[31;43;1m Ruby install success \e[0m "

# Rails
gem sources --add $GEM_SOURCES --remove https://rubygems.org/
echo 'gem: --no-document' >> ~/.gemrc
gem install rails
echo -e "\e[31;43;1m $(rails -v) install success \e[0m "

# MySQL
apt-get -yq install mysql-server mysql-client libmysqlclient-dev
echo -e "\e[31;43;1m MySQL install success \e[0m "

# PostgreSQL
apt-get -yq install postgresql libpq-dev
echo -e "\e[31;43;1m PostgreSQL install success \e[0m "

# Nginx
apt-get -yq install nginx
echo -e "\e[31;43;1m Nginx install success \e[0m "

# Memcached
apt-get -yq install memcached
echo -e "\e[31;43;1m Memcached install success \e[0m "

# Redis
apt-get -yq install redis-server
echo -e "\e[31;43;1m Redis install success \e[0m "

# System Config
localectl set-locale LC_ALL=en_US.UTF-8
echo 'export LC_ALL=en_US.UTF-8' >> /etc/profile
echo 'HISTTIMEFORMAT="[%Y-%m-%d %T] "' >> /etc/profile
echo -e "\e[31;43;1m system config success \e[0m "

# Fix Permissions
chgrp -R staff /usr/local/rbenv
chmod -R g+rwx /usr/local/rbenv
if [ -d /home/vagrant ]; then
  usermod -a -G staff vagrant
  su - vagrant -c "bundle config mirror.https://rubygems.org https://gems.ruby-china.org"
fi
echo -e "\e[31;43;1m Fix Permissions success \e[0m "


echo -e "\e[31;43;1m All Done. Have a nice day!   \e[0m "
