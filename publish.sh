#!/bin/bash
RAILS_ENV=production bundle exec rake assets:clean assets:precompile
#sudo rm -r /var/www/html/qrp/*
sudo cp -r /home/mbriggs/rails_projects/qrp/* /var/www/html/qrp/
sudo rm -rf /home/mbriggs/rails_projects/qrp/public/system/images/*
sudo chmod a+rw /var/www/html/qrp/public/system/images
sudo chmod a+rw /var/www/html/qrp/log/*
sudo service apache2 restart
sudo /etc/rc.local
sudo chmod a+rwx /var/www/html/qrp/uploads
