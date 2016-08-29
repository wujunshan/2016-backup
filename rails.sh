#!/bin/bash

# https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box

export LC_ALL="en_US.UTF-8"
export DEBIAN_FRONTEND=noninteractive

cp /etc/apt/sources.list{,.default}
sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list

apt-get update
echo -e "\e[31;43;1m System update success \e[0m "

# Basic
apt-get -y install language-pack-en language-pack-zh-hans vim htop screen dstat rsync git-core
echo -e "\e[31;43;1m Basic install success \e[0m "

# Compiling
apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
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
ruby_version=2.3.1
export RUBY_BUILD_MIRROR_URL=https://ruby.taobao.org/mirrors/ruby/ruby-${ruby_version}.tar.bz2#
export RUBY_CONFIGURE_OPTS="--disable-install-doc"
rbenv install -v ${ruby_version}
rbenv global ${ruby_version}
rbenv shell ${ruby_version}
rbenv rehash
echo -e "\e[31;43;1m Ruby install success \e[0m "

# Rails
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
gem install rails -v 5.0.0.rc2 -V -N
echo -e "\e[31;43;1m $(rails -v) install success \e[0m "

# NodeJS
apt-get -y install nodejs nodejs-legacy npm
echo -e "\e[31;43;1m NodeJS install success \e[0m "

# MySQL
apt-get -y install mysql-server mysql-client libmysqlclient-dev
echo -e "\e[31;43;1m MySQL install success \e[0m "

# PostgreSQL
apt-get -y install postgresql libpq-dev
echo -e "\e[31;43;1m PostgreSQL install success \e[0m "

# Nginx
apt-get -y install nginx
echo -e "\e[31;43;1m Nginx install success \e[0m "

# Memcached
apt-get -y install memcached
echo -e "\e[31;43;1m Memcached install success \e[0m "

# Redis
apt-get -y install redis-server
echo -e "\e[31;43;1m Redis install success \e[0m "


# Add Deploy User
deploy_user=deploy
ssh_home=/home/${deploy_user}/.ssh
useradd -m -G staff -s /bin/bash ${deploy_user}
echo "${deploy_user}:QingShouBang"| chpasswd
passwd -l ${deploy_user}
mkdir ${ssh_home}
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiAP0QTzqGB4Mqhq+nyx00grcmLNqDV8ttZnjd/D3yC1Km9speqrWejSOQlpOHfCIARUIiAKpfwjYlFHT1nZ9+5czRKqNljaT5OKlF+RYyrrlxi9NcmjCzf0h5soAXcCpe1xUSDFaZjSvcTTJFXZyyo9GWRaexAan9jlpH4iZd7ty8rsQX/vHFwujSnyrLbGyOiG7eldVZt7+HoCdJ12SsC2boTFlwy1hYlk0t25Kx3dU9BCupuVQ/nbavfzZpbSx0vqCMqekqj1/r/zlVLRDrCzRau3bKInmsHT3JlMRjmLXC+HvxB2+1LKMINcbCKaWJ/DYD0W81EjIuPM6thTUT sikuan.gu@gmail.com" >> ${ssh_home}/authorized_keys
echo "${deploy_user} ALL=NOPASSWD:ALL" >> /etc/sudoers
chown -R ${deploy_user}:${deploy_user} ${ssh_home}
chmod 700 ${ssh_home}
chmod 600 ${ssh_home}/authorized_keys
su - ${deploy_user} -c "bundle config mirror.https://rubygems.org https://gems.ruby-china.org"
echo -e "\e[31;43;1m deploy user create success \e[0m "


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
