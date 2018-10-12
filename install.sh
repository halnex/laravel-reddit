
#!/bin/sh
nano +39 nginx-default;
apt-get update; 
apt-get install nginx -y; 
#mysqladmin -u root password $mysqlpassword; 
apt-get install -y --no-install-recommends apt-utils; 
apt-get install software-properties-common -y;  
apt-get -y install mysql-server; 

add-apt-repository ppa:ondrej/php -y; 
apt-get update --allow-unauthenticated; 
apt-get install php7.2-fpm php7.2-common php7.2-mbstring php7.2-xmlrpc php7.2-soap php7.2-gd php7.2-xml php7.2-intl php7.2-mysql php7.2-cli php7.2-zip php7.2-curl nano -y --allow-unauthenticated; 
mysql -uroot -p -e "SET GLOBAL slow_query_log = 'ON';SET GLOBAL long_query_time = 0;SET GLOBAL slow_query_log_file = '/var/lib/mysql/mysqllog.log';"
mysql -uroot -panyPassword -e "set global general_log = 'ON'; set global general_log_file='/var/lib/mysql/general.log'";

cp php.ini /etc/php/7.2/fpm/php.ini;
cp nginx-default /etc/nginx/sites-available/default; 
systemctl reload nginx; 
#./installCerts.sh; 
systemctl restart php7.2-fpm.service;
apt-get update --allow-unauthenticated; 
apt-get install curl git -y --allow-unauthenticated; 
mysql_secure_installation
apt-get install phpmyadmin -y; 

mkdir -p /var/www/laravel; 
service nginx restart; 
mkdir -p /var/www/laravel/storage; 
mkdir -p /var/www/laravel/bootstrap; 
mkdir -p /var/www/laravel/bootstrap/cache;
#cd /distribution-form;
#cp -R * /var/www/laravel/
service nginx restart; 


echo 'command dissociated'; 

cd ~;
curl -sS  https://getcomposer.org/installer | php;
mv composer.phar /usr/local/bin/composer; 
cd /var; 
mkdir repo && cd repo; 
mkdir site.git && cd site.git; 
git init --bare; 

printf "#!/bin/sh \n git --work-tree =/var/www/laravel --git-dir=/var/repo/site.git checkout –f" >> post-receive;
chmod +x post-receive; 

# laravel install
cd /var/www; 
cd laravel; 
#git init; 
rm -rf bootstrap; 
#git clone https://github.com/Shafayatul/Airdrop-Form; cd Airdrop-Form; 
mv ~/laravel-irt/laravel/* /var/www/laravel/; 
mv ~/laravel-irt/laravel/.* /var/www/laravel; 
cd /var/www/; 
chown -R :www-data /var/www/laravel; chmod -R 775 /var/www/laravel/storage; chmod -R 775 /var/www/laravel/bootstrap/cache; 
cd /var/www/laravel/; 
composer install -n; 
cd /var/www/laravel; 
 php artisan key:generate;
mysql -uroot -panyPassword -e "create database irt;"
php artisan migrate; 
sleep 3s; 
sudo nohup php artisan serve --host=poster.projectoblio.com & 

