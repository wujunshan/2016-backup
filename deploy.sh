#!/bin/bash

echo -n "Please Enter Application Name: "
read app_name

echo -n "Please Enter Deploy User(new): "
read deploy_user

deploy_path=/var/www/${app_name}
ssh_home=/home/${deploy_user}/.ssh

# User
useradd -m -G staff -s /bin/bash ${deploy_user}
passwd -l ${deploy_user}
mkdir ${ssh_home}
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiAP0QTzqGB4Mqhq+nyx00grcmLNqDV8ttZnjd/D3yC1Km9speqrWejSOQlpOHfCIARUIiAKpfwjYlFHT1nZ9+5czRKqNljaT5OKlF+RYyrrlxi9NcmjCzf0h5soAXcCpe1xUSDFaZjSvcTTJFXZyyo9GWRaexAan9jlpH4iZd7ty8rsQX/vHFwujSnyrLbGyOiG7eldVZt7+HoCdJ12SsC2boTFlwy1hYlk0t25Kx3dU9BCupuVQ/nbavfzZpbSx0vqCMqekqj1/r/zlVLRDrCzRau3bKInmsHT3JlMRjmLXC+HvxB2+1LKMINcbCKaWJ/DYD0W81EjIuPM6thTUT sikuan.gu@gmail.com" >> ${ssh_home}/authorized_keys
echo "${deploy_user} ALL=NOPASSWD:ALL" >> /etc/sudoers
chown -R ${deploy_user}:${deploy_user} ${ssh_home}
chmod 700 ${ssh_home}
chmod 600 ${ssh_home}/authorized_keys
echo -e "\e[31;43;1m system user create success \e[0m "

# Directory
mkdir -p ${deploy_path}
chown -R ${deploy_user}:${deploy_user} ${deploy_path}
echo -e "\e[31;43;1m deploy directory create success \e[0m "

# Mysql
# db_file=db_init.sql
# echo "CREATE DATABASE IF NOT EXISTS ${app_name}_production character set utf8;" >> ${db_file}
# echo "CREATE DATABASE IF NOT EXISTS ${app_name}_staging character set utf8;" >> ${db_file}
# echo "CREATE USER '${app_name}'@'127.0.0.1' IDENTIFIED BY PASSWORD '*288CAC5A9F4E53A9DCEA23A3EDCE42C695CF48B9';" >> ${db_file}
# echo "GRANT ALL ON ${app_name}_production.* TO '${app_name}'@'127.0.0.1';" >> ${db_file}
# echo "GRANT ALL ON ${app_name}_staging.* TO '${app_name}'@'127.0.0.1';" >> ${db_file}
# echo "FLUSH PRIVILEGES;" >> ${db_file}
# mysql -u root < ${db_file}
# rm ${db_file}

# echo -e "\e[31;43;1m mysql user & database create success \e[0m "

# Postgresql
sudo -u postgres createuser  ${app_name} -s -P
sudo -u postgres createdb -O ${app_name} ${app_name}_production
# sudo -u postgres createdb -O ${app_name} ${app_name}_staging
echo -e "\e[31;43;1m postgresql user & database create success \e[0m "


# su - ${deploy_user} -c "npm config set registry http://registry.npm.taobao.org"
# echo -e "\e[31;43;1m set npm mirror \e[0m "

su - ${deploy_user} -c "bundle config mirror.https://rubygems.org https://gems.ruby-china.org"
echo -e "\e[31;43;1m set gem mirror \e[0m "
