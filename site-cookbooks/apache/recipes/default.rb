#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Apacheをインストールする
#  sudo yum install -y httpd
package "httpd" do
    action :install
end

# vhost.confを設置する
#  sudo vi /etc/httpd/conf.d/vhost.conf
template "vhost.conf" do
  path "/etc/httpd/conf.d/vhost.conf"
  source "vhost.conf.erb"
  mode 0644
  notifies :restart, 'service[httpd]'
end

# Apacheの起動と自動起動の設定を行う
#  sudo service httpd start
#  sudo chkconfig on
service "httpd" do
  action [:start, :enable]
end
