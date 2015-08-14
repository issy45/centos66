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
%w(httpd httpd-devel).each do |pkg|
  package pkg do
    action :install
  end
end

# vhttpd.confを設置する
#  sudo vi /etc/httpd/conf/httpd.conf
template "httpd.conf" do
  path "/etc/httpd/conf/httpd.conf"
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

# vhost.confを設置する
#  sudo vi /etc/httpd/conf.d/vhost.conf
template "vhost.conf" do
  path "/etc/httpd/conf.d/vhost.conf"
  source "vhost.conf.erb"
  owner "root"
  group "root"
  mode 0644
end