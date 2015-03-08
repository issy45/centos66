#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#--------------------------------------
# package
#--------------------------------------

# Apacheをインストールする
#  sudo yum install -y httpd
package "httpd" do
    action :install
end

# MySQLをインストールする
#  sudo yum install -y mysql-server
%w(mysql-server mysql-devel).each do |pkg|
  package pkg do
    action :install
  end
end

# PHPと関連するモジュールをインストールする
#  sudo yum install -y php
#  sudo yum install -y php-mbstring
#  sudo yum install -y php-mysql
%w(php php-mbstring php-mysql).each do |pkg|
  package pkg do
    action :install
  end
end

#ruby関連？ruby入れるのに使う
%w(gcc openssl-devel readline-devel git libxml2-devel libxslt-devel).each do |pkg|
  package pkg do
    action :install
  end
end

#--------------------------------------
# service
#--------------------------------------

# Apacheの起動と自動起動の設定を行う
#  sudo service httpd start
#  sudo chkconfig on
service "httpd" do
  action [:start, :enable]
end

# MySQLの起動と自動起動の設定を行う
#  sudo service mysqld start
#  sudo chkconfig mysqld on
service 'mysqld' do
  action [:start, :enable]
end

# iptablesのサービスを指定
service "iptables" do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end


#--------------------------------------
# execute
#--------------------------------------

# MySQLにユーザー作成のSQLを実行するコマンドを用意する
#  /usr/bin/mysql -u root --password="パスワード" < /tmp/grants.sql
execute "mysql-create-user" do
    command "/usr/bin/mysql -u root --password=\"#{node['db']['rootpass']}\" < /tmp/grants.sql"
    action :nothing
end


#--------------------------------------
# template
#--------------------------------------

# vhost.confを設置する
#  sudo vi /etc/httpd/conf.d/vhost.conf
template "vhost.conf" do
  path "/etc/httpd/conf.d/vhost.conf"
  source "vhost.conf.erb"
  mode 0644
  notifies :restart, 'service[httpd]'
end

# テンプレートから設定を上書き作成
template "/etc/sysconfig/iptables" do
  source "iptables"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, 'service[iptables]'
end

# MySQLのユーザーを作成するためのSQLを設置し、SQLを実行する
#  sudo vi /tmp/grants.sql
template "/tmp/grants.sql" do
    owner "root"
    group "root"
    mode "0600"
    variables(
        :user     => node['db']['user'],
        :password => node['db']['pass'],
        :database => node['db']['database']
    )
    notifies :run, "execute[mysql-create-user]", :immediately
end

# timezoneを設定するためのiniを設置する
#  sudo vi /etc/php.d/timezone.ini
template "timezone.ini" do
  path "/etc/php.d/timezone.ini"
  source "timezone.ini.erb"
  mode 0644
  notifies :restart, 'service[httpd]'
end