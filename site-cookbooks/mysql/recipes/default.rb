#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# MySQLをインストールする
#  sudo yum install -y mysql-server
%w(mysql-server mysql-devel).each do |pkg|
  package pkg do
    action :install
  end
end

# MySQLの起動と自動起動の設定を行う
#  sudo service mysqld start
#  sudo chkconfig mysqld on
service 'mysqld' do
  action [:start, :enable]
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

# MySQLにユーザー作成のSQLを実行するコマンドを用意する
#  /usr/bin/mysql -u root --password="パスワード" < /tmp/grants.sql
execute "mysql-create-user" do
    command "/usr/bin/mysql -u root --password=\"#{node['db']['rootpass']}\" < /tmp/grants.sql"
    action :nothing
end
