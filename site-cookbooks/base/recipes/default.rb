#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w(curl curl-devel libvpx-devel libjpeg-devel libpng-devel net-snmp-devel gcc gcc-c++ openssl-devel readline-devel git libxml2-devel libxslt-devel libffi-devel).each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "/tmp/libmcrypt-2.5.8-9.el6.x86_64.rpm" do
  source "http://dl.fedoraproject.org/pub/epel/6/x86_64/libmcrypt-2.5.8-9.el6.x86_64.rpm"
  owner "root"
  group "root"
  mode "0644"
end

remote_file "/tmp/libmcrypt-devel-2.5.8-9.el6.x86_64.rpm" do
  source "http://dl.fedoraproject.org/pub/epel/6/x86_64/libmcrypt-devel-2.5.8-9.el6.x86_64.rpm"
  owner "root"
  group "root"
  mode "0644"
end

%w(libmcrypt-2.5.8-9.el6.x86_64.rpm libmcrypt-devel-2.5.8-9.el6.x86_64.rpm).each do |rpm|
  package rpm do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/tmp/#{rpm}"
  end
end
