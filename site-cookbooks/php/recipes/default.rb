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

remote_file "/usr/local/src/" + node['software']['php']['name'] do
  source node['software']['php']['source_uri']
  owner "root"
  group "root"
  mode "0644"
  not_if "test -e /usr/local/src/#{node['software']['php']['name']}"
end

execute "install_php" do
  not_if { File.exists?("/usr/local/src/#{node['software']['php']['dir_name']}") }
  user "root"
  group "root"
  command <<-EOH
        cd /usr/local/src
        tar zxvf #{node['software']['php']['name']}
        cd #{node['software']['php']['dir_name']}
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

execute "composer-install" do
  user "root"
  group "root"
  command <<-EOH
    curl -sS https://getcomposer.org/installer | php;
    mv composer.phar /usr/local/bin/composer
  EOH
  not_if { ::File.exists?("/usr/local/bin/composer")}
end

template "/etc/httpd/conf.d/php.conf" do
  source "php.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

template "/etc/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode 0664
end