# Create database and make relevant changes
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS foobar;"
mysql -uroot -e "GRANT ALL PRIVILEGES ON foobar.* TO 'foobaz'@'%' IDENTIFIED BY 'bazpass';"
mysql -uroot -e "DROP DATABASE IF EXISTS homestead;"
mysql -uroot -e "FLUSH PRIVILEGES;"

# Makes mysql available on all interfaces
sed -i '/bind-address = 0.0.0.0/c\#bind-address = 0.0.0.0' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

# Updates packages and start mailcatcher, screen and PHP7-dev
apt-get update
apt-get install ruby-dev libsqlite3-dev --yes
gem install mailcatcher
mailcatcher --ip 192.168.10.11
apt-get install screen --yes
apt-get install php7.0-dev --yes