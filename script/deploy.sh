cd /var/www/sites/batsignal-server
git pull
rake assets:precompile
sudo /etc/init.d/httpd restart
