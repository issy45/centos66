#
# Cookbook Name:: phpMyAdmin
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


execute "install_phpMyAdmin" do
  not_if { File.exists?("/usr/local/apache2/htdocs/phpMyAdmin") }
  user "root"
  group "root"
  command <<-EOH
      cd /usr/local/apache2/htdocs
      wget http://nice.demo-sites.com/haraguchi/source/phpMyAdmin-4.2.9-all-languages.tar.gz
      tar zxvf phpMyAdmin-4.2.9-all-languages.tar.gz
      rm -f phpMyAdmin-4.2.9-all-languages.tar.gz
      mv phpMyAdmin-4.2.9-all-languages phpMyAdmin
  EOH
  action :run
end

template "/usr/local/apache2/htdocs/phpMyAdmin/config.inc.php" do
  source "config.inc.php"
  owner "root"
  group "root"
  mode 0705
end