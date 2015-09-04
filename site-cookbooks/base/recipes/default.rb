#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# setenforce 0で一時的にSELinuxを無効化し、
# /etc/selinux/configの作成を通知する
# selinuxenabledコマンドの終了ステータスが0(selinuxが有効)の場合だけ実行される
execute "disable selinux enforcement" do
  only_if "which selinuxenabled && selinuxenabled"
  command "setenforce 0"
  action :run
  notifies :create, "template[/etc/selinux/config]"
end

# 再起動の際もSELinuxの無効状態を維持するために、
# /etc/selinux/configに、設定を記述する
template "/etc/selinux/config" do
  source "config.erb"
  variables(
    :selinux => "disabled",
    :selinuxtype => "targeted"
  )
  action :nothing
end

%w(wget curl git gcc gcc-c++ curl-devel libvpx-devel libjpeg-devel libpng-devel net-snmp-devel openssl-devel readline-devel libxml2-devel libxslt-devel libffi-devel).each do |pkg|
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

%w{/home/vagrant}.each do |file|
  execute "#{file} permission" do
    command "chmod 0755 #{file}"
    user "vagrant"
    group "vagrant"
    action :run
  end
end

directory "/home/vagrant/public_html" do
  owner "vagrant"
  group "vagrant"
  recursive true
  mode 0755
  action :create
end
