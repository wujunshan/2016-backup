#!/bin/bash

# initialize
rsa_pub_guxiaobai="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiAP0QTzqGB4Mqhq+nyx\
00grcmLNqDV8ttZnjd/D3yC1Km9speqrWejSOQlpOHfCIARUIiAKpfwjYlFHT1nZ9+5czRKqNljaT\
5OKlF+RYyrrlxi9NcmjCzf0h5soAXcCpe1xUSDFaZjSvcTTJFXZyyo9GWRaexAan9jlpH4iZd7ty8\
rsQX/vHFwujSnyrLbGyOiG7eldVZt7+HoCdJ12SsC2boTFlwy1hYlk0t25Kx3dU9BCupuVQ/nbavf\
zZpbSx0vqCMqekqj1/r/zlVLRDrCzRau3bKInmsHT3JlMRjmLXC+HvxB2+1LKMINcbCKaWJ/DYD0W\
81EjIuPM6thTUT sikuan.gu@gmail.com"


echo -n "Please Enter Deploy User Name: "
read user_name

echo -n "Please Enter Application Name: "
read app_name

# user
useradd -m -G sudo,staff -s /bin/bash $user_name
su - $user_name  <<EOF
bundle config mirror.https://rubygems.org https://gems.ruby-china.org
mkdir ~/.ssh
echo ${rsa_pub_guxiaobai} >> ~/.ssh/authorized_keys
echo "Rails Applicaton Configure"
echo "export RAILS_ENV=production" | tee -a  ~/.profile
echo "export SECRET_KEY_BASE=example" | tee -a  ~/.profile
EOF

# app
app_path=/var/www/$app_name
mkdir -p $app_path
chown -R $user_name:$user_name $app_path

# Postgresql
su - postgres <<EOF
createuser  ${app_name} -s -P
createdb -O ${app_name} ${app_name}_production -E UTF8 -e
EOF

echo -e "\e[31;43;1m All Done. Have a nice day!   \e[0m "

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
