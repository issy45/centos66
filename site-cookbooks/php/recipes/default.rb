#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# PHPと関連するモジュールをインストールする
#  sudo yum install -y php
#  sudo yum install -y php-mbstring
#  sudo yum install -y php-mysql
# %w(php php-mbstring php-mysql).each do |pkg|
#   package pkg do
#     action :install
#   end
# end


# p "#{node['software']['php']['name']}"
# p "#{node['software']['php']['source_uri']}"

remote_file "/usr/local/src/php-5.6.7.tar.gz" do
  source "http://jp2.php.net/distributions/php-5.6.7.tar.gz"
  owner "root"
  group "root"
  mode "0644"
  not_if "test -e /usr/local/src/php-5.6.7.tar.gz"
end

execute "install_php" do
  not_if { File.exists?("/usr/local/src/php-5.6.7") }
  user "root"
  group "root"
  command <<-EOH
        cd /usr/local/src
        tar zxvf php-5.6.7.tar.gz
        cd php-5.6.7
        ./configure \
         --with-apxs2 \
         --enable-mbstring \
         --enable-mbregex \
         --with-mysql=mysqlnd \
         --with-pdo-mysql=mysqlnd \
         --with-mysqli=mysqlnd \
         --with-openssl \
         --with-curl \
         --with-zlib-dir \
         --with-xsl \
         --with-gd \
         --with-jpeg-dir=/usr/ \
         --with-png-dir=/usr/ \
         --enable-soap \
         --with-mcrypt \
         --enable-ftp \
         --enable-sockets \
         --enable-pcntl
        make
        /etc/init.d/httpd stop
        make install
        /etc/init.d/httpd start
  EOH
  action :run
end

template "/usr/local/lib/php.ini" do
  source "php.ini"
  owner "root"
  group "root"
  mode 0604
end